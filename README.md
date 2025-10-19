## Prerequisites
- [fzf](https://github.com/junegunn/fzf) (Core)
- [bat](https://github.com/sharkdp/bat) (Optional: For colored preview)
- [zathura](https://github.com/pwmt/zathura) (Optional: Only if you need pdf viewer)

## NORMAL Mode Commands
### Motions
| Motions | Description |
| :------ | :---------- |
| `j` | Goes down an element |
| `k` | Goes up an element |
| `h` | Goes to parent directory |
| `l` | Goes to child directory |
| `J` | Preview Up |
| `K` | Preview Down |
| `i` | Switches to INSERT mode |
| `q` | Quit |

### Operations
> [!NOTE]
> All of these operations can be done in bulk

| Operations | Description |
| :--------- | :---------- |
| `t` | Create file in CWD |
| `o` | Create dir in CWD |
| `y` | Copy to specific location |
| `m` | Moves to specific location |
| `d` | Delete selected item |
| `x` | Change permissions |

## INSERT Mode Commands
| Motions | Description |
| :------ | :---------- |
|`ctrl-h`| Switches to NORMAL mode |

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
