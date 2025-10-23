#!/usr/bin/env bash

fzf_touch() {
    local selected=$(dirname "$1")
    read -e -p "File Name(s): " file_names
    printf '%s\n' $file_names | xargs -I{} touch "$selected/{}"
}

fzf_mkdir() {
    local selected=$(dirname "$1")
    read -e -p "Dir Name(s): " dir_names
    printf '%s\n' $dir_names | xargs -I{} mkdir -p "$selected/{}"
}

fzf_copy() {
    local selected=()
    for arg in "$@"; do
        selected+=("$arg")
    done
    echo "Copy the following items:"
    printf '  %s\n' "${selected[@]}"
    read -e -p "Dest dir: " -i "$PWD/" dest_dir

    if [[ ! -d "$dest_dir" ]]; then
        echo -e "$dest_dir does not exist."
        read -e -p "Create $dest_dir Dir? (y/n): " prompt
        if [[ "$prompt" =~ ^[Yy]$ ]]; then
            mkdir -p "$dest_dir"
        fi
    fi
    for item in "${selected[@]}"; do
        cp -r "$item" "$dest_dir"
    done
}

fzf_move() {
    local selected=()
    for arg in "$@"; do
        selected+=("$arg")
    done
    echo "Move the following items:"
    printf '  %s\n' "${selected[@]}"
    read -e -p "Dest dir: " -i "$PWD/" dest_dir
    mkdir -p "$dest_dir"
    mv "${selected[@]}" "$dest_dir"
}

fzf_rename() {
    local selected=()
    for arg in "$@"; do
        selected+=("$arg")
    done

    local count=${#selected[@]}

    # single file case
    if [[ $count -eq 1 ]]; then
        local old_name="${selected[0]}"
        local dir_name=$(dirname "$old_name")
        local base_name=$(basename "$old_name")

        echo "Renaming: $old_name"
        read -e -p "New name: " -i "$base_name" new_name

        mv "$old_name" "$dir_name/$new_name"

    # multiple files case
    elif [[ $count -gt 1 ]]; then
        local temp_file=$(mktemp)

        # create a file with current names for editing
        printf '# Edit the names below, then save and quit to rename\n' >"$temp_file"
        printf '# Original files will be renamed to the names on the left\n' >>"$temp_file"
        printf '# WARNING: Do not change the order of lines!\n\n' >>"$temp_file"

        for item in "${selected[@]}"; do
            printf '%s\n' "$(basename "$item")" >>"$temp_file"
        done

        # open in nvim for editing
        ${FZFM_EDITOR:-$EDITOR} "$temp_file"

        # read the edited names
        local new_names=()
        while IFS= read -r line; do
            # skip comment lines and empty lines
            [[ "$line" =~ ^#.*$ ]] && continue
            [[ -z "$line" ]] && continue
            new_names+=("$line")
        done <"$temp_file"

        # verify we have the same number of names
        if [[ ${#new_names[@]} -ne $count ]]; then
            err "Number of names changed (${#new_names[@]}) doesn't match original ($count)"
            rm -f "$temp_file"
            return 1
        fi

        for ((i = 0; i < count; i++)); do
            local old_path="${selected[$i]}"
            local dir_name=$(dirname "$old_path")
            local old_name=$(basename "$old_path")
            local new_name="${new_names[$i]}"

            if [[ "$old_name" != "$new_name" ]]; then
                mv "$old_path" "$dir_name/$new_name" 2>/dev/null
            fi
        done

        rm -f "$temp_file"
    fi
}

fzf_remove() {
    local selected=()
    for arg in "$@"; do
        selected+=("$arg")
    done

    echo "The following items will be PERMANENTLY removed:"
    printf '  %s\n' "${selected[@]}"

    read -e -p "Remove all above items? (y/N): " prompt
    if [[ "$prompt" =~ ^[Yy]$ ]]; then
        rm -rf "${selected[@]}" || err "Failed to delete some items"
    else
        err "Deletion cancelled"
    fi
}

fzf_chmod() {
    local selected="$1"
    echo "Permissions: $(stat -c %A "$selected")/$(stat -c %a "$selected")"
    read -e -p "Change Permissions: " -i "+x" perm
    chmod "$perm" "$selected"
}

fzf_zip() {
    local selected=()
    for arg in "$@"; do
        selected+=("$arg")
    done

    echo "The following items will be ziped:"
    printf '  %s\n' "${selected[@]}"

    read -e -p "Archive filename: " zip_name
    zip -r "$zip_name" "${selected[@]}"
}

fzf_unzip() {
    local selected="$1"
    local curr_dir=$(dirname "$selected")
    read -e -p "Destination dir: " -i "$PWD/" dest_dir
    unzip "$selected" -d "$dest_dir"
}

fzf_tar() {
    local selected=()
    for arg in "$@"; do
        selected+=("$arg")
    done

    echo "The following items will be archived by tar:"
    printf '  %s\n' "${selected[@]}"

    read -e -p "Archive filename: " zip_name
    echo "Available compressions -> gzip, bzip2, xz, zstd"
    read -e -p "Choose Compression: " compress

    local final_name="$zip_name"

    if [[ "$compress" == "gzip" ]]; then
        [[ "$final_name" != *.tar.gz ]] && final_name="${final_name}.tar.gz"
        tar -czf "$final_name" "${selected[@]}"
    elif [[ "$compress" == "bzip2" ]]; then
        [[ "$final_name" != *.tar.bz2 ]] && final_name="${final_name}.tar.bz2"
        tar -cjf "$final_name" "${selected[@]}"
    elif [[ "$compress" == "xz" ]]; then
        [[ "$final_name" != *.tar.xz ]] && final_name="${final_name}.tar.xz"
        tar -cJf "$final_name" "${selected[@]}"
    elif [[ "$compress" == "zstd" ]]; then
        [[ "$final_name" != *.tar.zst ]] && final_name="${final_name}.tar.zst"
        tar --zstd -cf "$final_name" "${selected[@]}"
    elif [[ "$compress" == "" ]]; then
        [[ "$final_name" != *.tar ]] && final_name="${final_name}.tar"
        tar -cf "$final_name" "${selected[@]}"
    else
        err "Compression not supported"
    fi
}

fzf_untar() {
    local selected="$1"
    local curr_dir=$(dirname "$selected")

    read -e -p "Destination dir: " -i "$PWD" dest_dir
    mkdir -p "$dest_dir"

    case "$selected" in
    *.tar.gz | *.tgz)
        tar -xzf "$selected" -C "$dest_dir"
        ;;
    *.tar.bz2 | *.tbz2)
        tar -xjf "$selected" -C "$dest_dir"
        ;;
    *.tar.xz | *.txz)
        tar -xJf "$selected" -C "$dest_dir"
        ;;
    *.tar.zst | *.tzst)
        tar --zstd -xf "$selected" -C "$dest_dir"
        ;;
    *.tar)
        tar -xf "$selected" -C "$dest_dir"
        ;;
    *)
        err "Unknown archive format: $selected"
        return 1
        ;;
    esac
}

fzf_extract() {
    local selected="$1"

    case "$selected" in
    *.zip)
        fzf_unzip "$selected"
        ;;
    *.tar | *.tar.gz | *.tgz | *.tar.bz2 | *.tbz2 | *.tar.xz | *.txz | *.tar.zst | *.tzst)
        fzf_untar "$selected"
        ;;
    *)
        err "Unknown archive format: $selected"
        return 1
        ;;
    esac
}

export -f fzf_touch fzf_mkdir fzf_copy fzf_move fzf_rename fzf_remove fzf_chmod
export -f fzf_zip fzf_tar fzf_unzip fzf_untar fzf_extract
