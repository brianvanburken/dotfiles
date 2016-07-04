# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="avit"

plugins=(git git-flow osx rails ruby npm brew elixir)

source $ZSH/oh-my-zsh.sh
source $HOME/.profile
source $HOME/.bash_aliases

[[ -f $HOME/.asdf/asdf.sh  ]] && source $HOME/.asdf/asdf.sh
[[ -f $HOME/.zsh_functions ]] && source $HOME/.zsh_functions
[[ -f $HOME/.shell_local   ]] && source $HOME/.shell_local
