#!/usr/bin/env bash

err() {
    echo -e "ERROR: $1" >&2
    sleep 0.5
}

fzf_preview() {
    local selected="$(pwd)/$1"
    if [[ -d "$selected" ]]; then
        ls "$selected" --color -Av --group-directories-first
    elif [[ -f "$selected" ]]; then
        bat --style=numbers --theme=gruvbox-dark --color=always "$selected" || cat "$selected"
    fi
}

fzf_file_handlers() {
    local selected="$1"
    local mime=$(file -L --mime-type -b "$selected")

    case "$mime" in
    text/* | application/json | application/octet-stream)
        ${FZFM_EDITOR:-$EDITOR} "$selected"
        exit 0
        ;;
    application/pdf)
        ${FZFM_PDF_READER:-zathura} "$selected"
        exit 0
        ;;
    *)
        err "Unknown mime type"
        exit 0
        ;;
    esac
}

export -f err fzf_preview

curr_dir=$(dirname "$0")
source $curr_dir/utils.sh
source $curr_dir/modes.sh

while true; do
    # cleanup previous restart flags
    [[ -f "$restart_file" ]] && rm "$restart_file"

    find_cmd="ls -av --group-directories-first --color"
    fzf_mode=$(cat "$mode_file")

    bind_keys=$(build_bind_keys "$fzf_mode")
    fzf_opts="--multi --height=80% --layout=reverse --style full --ansi --border --preview-window right:65%"
    if [[ "$fzf_mode" == "NORMAL" ]]; then
        fzf_opts+=" --disabled"
    fi

    selected=$(eval "$find_cmd" | fzf $fzf_opts --input-label=" $fzf_mode " --border-label=" $(pwd)/ " \
        --bind "focus:transform-header:stat -c %A {}" \
        --bind "$bind_keys" --preview="bash -c 'fzf_preview {}'" --exit-0)

    # check if restart flag is up
    [[ -f "$restart_file" ]] && continue

    [[ -z "$selected" ]] && break
    if [[ -d "$selected" ]]; then
        cd "$selected"
        continue
    elif [[ -f "$selected" ]]; then
        fzf_file_handlers "$selected"
    else
        break
    fi
done
