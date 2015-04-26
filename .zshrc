export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="robbyrussell"

plugins=(git osx)

source $ZSH/oh-my-zsh.sh
source ~/.bash_profile

# Disable .zcompdup files
rm -f ~/.zcompdump*; compinit -D
