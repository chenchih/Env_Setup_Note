# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
ZSH_THEME="powerlevel10k/powerlevel10k"
#DEFAULT_USER=$USER

#Plugin
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-z web-search)

source $ZSH/oh-my-zsh.sh


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

HISTFILE=~/.zsh_history
HISTSIZE=5000
#SAVEHIST=10000
SAVEHIST=$HISTSIZE
setopt APPEND_HISTORY       # don’t overwrite history file
setopt SHARE_HISTORY        # share history across terminals
setopt HIST_IGNORE_DUPS     # don’t record duplicates
setopt HIST_IGNORE_SPACE    # ignore commands starting with space
setopt HIST_IGNORE_ALL_DUPS #Clean history when searching (Ctrl+R)

export FZF_DEFAULT_OPTS='--reverse --border --exact --height=50%'

#export STARSHIP_CONFIG=~/.config/starship.toml
#eval "$(starship init zsh)"
