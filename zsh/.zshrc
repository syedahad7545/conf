# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# ALIASES
alias vim="nvim"
alias ls="eza -l"
alias vi="nvim"
alias ivim='nvim $(fzf -m --preview="bat --color=always {}")'

# Usage: vcheck ./my_program
function vcheck() {
    valgrind --leak-check=full \
             --show-leak-kinds=all \
             --track-origins=yes \
             --error-exitcode=1 \
             "$@"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH=~/.npm-global/bin:$PATH

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

bindkey -v
# Map the encoded 'Ctrl + [' sequence to Vi Normal Mode
bindkey '^[[91;5u' vi-cmd-mode

# Tool Initializations
source <(fzf --zsh)
eval "$(zoxide init zsh)"
# Disable Zsh spelling correction
unsetopt correct
unsetopt correct_all
export EDITOR="nvim"
export VISUAL="nvim"
