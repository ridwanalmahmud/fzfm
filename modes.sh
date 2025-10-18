#!/usr/bin/env bash

# file handles
# have to exit and restart fzf to reset key binds
mode_file="/tmp/fzf_mode_$$" # for mode change
restart_file="/tmp/fzf_restart_$$" # restart after mode change
echo "NORMAL" >"$mode_file"

cleanup() {
    rm -f "$mode_file"
    rm -f "$restart_file"
}
trap cleanup EXIT

fzf_insert() {
    local file="$1"
    echo "INSERT" >"$file"
    echo ""
    return 0
}

fzf_normal() {
    local file="$1"
    echo "NORMAL" >"$file"
    echo ""
    return 0
}

declare -A NORMAL_BINDINGS=(
    [j]="down"
    [k]="up"
    [l]="accept"
    [h]="pos(2)+accept"
    [K]="preview-up"
    [J]="preview-down"
    [q]="abort"
    [i]="execute(bash -c 'fzf_insert $mode_file && touch $restart_file')+abort"
    [t]="execute(bash -c 'fzf_touch {+}')+reload(\$find_cmd)"
    [o]="execute(bash -c 'fzf_mkdir {+}')+reload(\$find_cmd)"
    [y]="execute(bash -c 'fzf_copy {+}')+reload(\$find_cmd)"
    [m]="execute(bash -c 'fzf_move {+}')+reload(\$find_cmd)"
    [d]="execute(bash -c 'fzf_remove {+}')+reload(\$find_cmd)"
    [x]="execute(bash -c 'fzf_chmod {+}')+reload(\$find_cmd)"
)

declare -A INSERT_BINDINGS=(
    [ctrl-h]="execute(bash -c 'fzf_normal $mode_file && touch $restart_file')+abort"
)

build_bind_keys() {
    local mode=$1
    local -n bindings_ref="${mode}_BINDINGS"
    local bind_keys=""

    for key in "${!bindings_ref[@]}"; do
        # evaluate variables at runtime
        binding=$(eval "echo \"${bindings_ref[$key]}\"")
        bind_keys+=",$key:$binding"
    done

    cwd=$(echo "$PWD" | sed "s|^$HOME/||")
    bind_keys+=",focus:transform-header:echo \[$mode\] $cwd"
    echo "${bind_keys#,}"
}

export -f fzf_insert fzf_normal build_bind_keys
