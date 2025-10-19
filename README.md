## Prerequisites
- [fzf](https://github.com/junegunn/fzf) (Core)
- [bat](https://github.com/sharkdp/bat) (Optional: For colored preview)
- [zathura](https://github.com/pwmt/zathura) (Optional: Only if you need pdf viewer)

## NORMAL Mode Commands
### Navigation
| Motions | Description |
| :------ | :---------- |
| `j` | Goes down an element |
| `k` | Goes up an element |
| `h` | Goes to parent directory |
| `l` | Goes to child directory |
| `J` | Preview Up |
| `K` | Preview Down |
| `g` | Jump to first element |
| `G` | Jump to last element |

### Operations
> [!NOTE]
> All of these operations can be done in bulk

| Motions | Description |
| :--------- | :---------- |
| `t` | Create file in CWD |
| `o` | Create dir in CWD |
| `y` | Copy to specific location |
| `r` | Rename selected item |
| `m` | Moves to specific location |
| `d` | Delete selected item |
| `x` | Change permissions |
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
### fzf opts
- Additional fzf options can be added in `fzfm.sh` with the `fzf_opts` variable `fzf_opts="${options}"`

> [!NOTE]
> Remove the --ansi to get better performance

## Issues
- Needs to restart fzf to change modes
- Trying to cd into a dir in the main shell but can't find a way
