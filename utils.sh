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

    if [[ ! -d "$dest_dir" ]]; then
        echo -e "$dest_dir does not exist."
        read -e -p "Create $dest_dir Dir? (y/n): " prompt
        if [[ "$prompt" =~ ^[Yy]$ ]]; then
            mkdir -p "$dest_dir"
        fi
    fi

    mv "${selected[@]}" "$dest_dir"
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
        rm -rf "${selected[@]}" || err "✗ Failed to delete some items"
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

fzf_create_project() {
    local selected=$(dirname "$1")
    read -e -p "Project Name: " project_name
    read -e -p "Project Type: " -i "c" project_type
    read -e -p "Build Type: " -i "make" build_type
    read -e -p "Lib Support: " -i "never" lib_support

    $DOTFILES/scripts/workflow/createproject.sh -d $selected -N $project_name -t $project_type -B $build_type -L $lib_support
}

export -f fzf_touch fzf_mkdir fzf_copy fzf_move fzf_remove fzf_chmod fzf_create_project
