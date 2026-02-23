export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM="xterm-256color"
export EDITOR="nvim"

# plugin manager
if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

#cute prompt
source "${ZINIT_HOME}/zinit.zsh"
zinit ice depth=1; zinit light romkatv/powerlevel10k

#adding plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

autoload -Uz compinit && compinit

zinit cdreplay -q


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Keybindings
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
autoload -Uz add-zsh-hook

# load_nix_shell() {
#   if [[ -f "flake.nix" && -z "$IN_NIX_SHELL" && -z "$SHLVL_NIX" ]]; then
#     echo "❄️ Entering Nix Develop..."
#     export SHLVL_NIX=1
#     nix develop -c $SHELL
#     
#     unset SHLVL_NIX
#   fi
# }
#
# add-zsh-hook chpwd load_nix_shell


zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
# bindkey '^f' fzf-tab-complete

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' fzf-flags '--bind=ctrl-f:accept'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias v='nvim'
alias c='clear'
alias py='python3'
alias cmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
alias venv="source .venv/bin/activate"
alias nix-shell='nix-shell --run $SHELL'

if command -v xdg-open >/dev/null 2>&1
then
    alias open='xdg-open'
fi


# Shell integrations
eval "$(fzf --zsh)"
fzf-history-widget-smart() {
  local out
  # We add --height and --layout to keep it from taking over the whole screen
  out=$(fc -rl 1 | awk '{ line = $0; sub(/^[ \t]*[0-9]+[ \t]+/, "", line); if (!seen[line]++) print line }' | 
        fzf +m \
        --height 40% \
        --layout=reverse \
        --query="$LBUFFER" \
        --print-query \
        --bind "ctrl-c:print-query+abort,esc:print-query+abort")
  
  if [ -n "$out" ]; then
    local lines=("${(@f)out}")
    if [[ ${#lines[@]} -gt 1 ]]; then
      LBUFFER="${(j:\n:)lines[2,-1]}"
    else
      LBUFFER="${lines[1]}"
    fi
  fi
  zle reset-prompt
}

zle -N fzf-history-widget fzf-history-widget-smart
eval "$(zoxide init --cmd cd zsh)"
#
if [[ -r "~/.env" ]]; then
  source ~/.env
fi
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


