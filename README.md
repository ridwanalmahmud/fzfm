## Prerequisites
- [`fzf`](https://github.com/junegunn/fzf) (Core)
- [`bat`](https://github.com/sharkdp/bat) (Optional: For colored preview)
- [`zathura`](https://github.com/pwmt/zathura) (Optional: Only if you need pdf viewer)
- `zip` && `unzip` (Needed)

## NORMAL Mode Commands
### Navigation
| Motions | Description |
| :------ | :---------- |
| `j` | Jump to the next element |
| `k` | Jump to the previous element |
| `h` | cd into parent directory |
| `l` | cd into child directory |
| `n` | Relative jump |
| `J` | Preview Up |
| `K` | Preview Down |
| `g` | Jump to first element |
| `G` | Jump to last element |

### Operations
> [!NOTE]
> All of these operations can be done in bulk

| Motions | Description |
| :--------- | :---------- |
| `e` | Create file in CWD |
| `o` | Create dir in CWD |
| `y` | Copy to specific location |
| `r` | Rename selected item |
| `m` | Moves to specific location |
| `d` | Delete selected item |
| `x` | Change permissions |
| `z` | `zip` files |
| `t` | `tar` with compression |
| `u` | Extract archived files |
| `i` | Switches to INSERT mode |
| `q` | Quit |

## INSERT Mode Commands
### Navigation
| Motions | Description |
| :------ | :---------- |
| `ctrl-h` | Goes to parent directory |
| `ctrl-l` | Goes to child directory |

### Operations
| Motions | Description |
| :------ | :---------- |
| `esc` | Switches to NORMAL mode |
| `ctrl-q` | Quit |

## Config
### ENV
- Text files will be opened in `$FZFM_EDITOR` (default: `$EDITOR`)
- PDF files will be opened in `$FZFM_PDF_READER` (default: `zathura`)
### Keybinds
- To add custom keybinds or change the default ones check `modes.sh`

> [!NOTE]
> Remove the --ansi to get better performance

## Issues
- Needs to restart fzf to change modes
- Trying to cd into a dir in the main shell but can't find a way
