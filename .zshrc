export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="robbyrussell"

plugins=(git github osx ruby rails brew gem rvm bundler)

source $ZSH/oh-my-zsh.sh
source ~/.bash_profile

alias zshconfig="e ~/.zshrc"
alias ohmyzsh="e ~/.oh-my-zsh"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
