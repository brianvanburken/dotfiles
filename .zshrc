export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="robbyrussell"

plugins=(git osx bundler npm rails ember-cli)

source $ZSH/oh-my-zsh.sh
source ~/.bash_profile

# Disable .zcompdup files
rm -f ~/.zcompdump*; compinit -D
