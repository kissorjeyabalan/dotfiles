# plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d $ZINIT_HOME ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# load plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-auto-notify

# Snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

autoload -U select-word-style
select-word-style bash

# keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# history
HISTSIZE=10000
SAVEHIsT=10000
HISTFILE=~/.zsh_history
HISTDUPE=erase

# zsh options
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# envs
export EDITOR=nvim
export MANPAGER="$EDITOR +Man!"
export PATH=$HOME/.local/bin:$PATH
export AUTO_NOTIFY_THRESHOLD=20
export AUTO_NOTIFY_TITLE="'%command' has just finished"
export AUTO_NOTIFY_BODY="Took %elapsed seconds"

# aliases
# alias learnkey='gpg-connect-agent "scd serialno" "learn --force" /bye'
# alias gpgkill='gpgconf --kill gpg-agent && gpg-agent --daemon'
alias ls='lsd --tree --depth 1 --group-dirs=first'
alias lsr='lsd --recursive --depth 1 --group-dirs=first'
alias v="nvim"
alias cat="bat --theme base16"
alias upgr="sudo pacman -Syyu"
alias zshconf="$EDITOR ~/.zshrc && source ~/.zshrc"

# completion styling
zstyle ':completion:*' matcher-list \
    'm:{[:lower:]}={[:upper:]}' \
    'l:|=* r:|=*' \
    'r:|=*'
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*:*:*:*:files' ignored-patterns ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always --icon=always $realpath'


# shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh --cmd cd)"
eval "$(starship init zsh)"