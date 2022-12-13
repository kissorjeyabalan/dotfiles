# dotfiles

## Setup
Run the appropriate snippet:

| OS | Snippet |
|:---|:---|
| macOS | `bash -c "$(curl -LsS https://raw.github.com/kissorjeyabalan/dotfiles/main/src/os/setup.sh)"` |
| Ubuntu | `bash -c "$(wget -qO - https://raw.github.com/kissorjeyabalan/dotfiles/main/src/os/setup.sh)"` |

## Customize
### Local Settings

The dotfiles can be extended by adding the following files:

#### `~/.bash.local`

Example:
```shell
#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set PATH additions.

PATH="/Users/kij/projects/dotfiles/src/bin/:$PATH"

export PATH

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set local aliases.

alias g="git"
```

#### `~/.gitconfig.local`

Example:
```gitconfig
[commit]
    gpgSign = true

[user]
    name = 
    email = 
    signingKey = 
```

#### `~/.vimrc.local`

Example:
```vim
" Disable arrow keys in insert mode.

inoremap <Down>  <ESC>:echoe "Use j"<CR>
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>

" Disable arrow keys in normal mode.

nnoremap <Down>  :echoe "Use j"<CR>
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
```