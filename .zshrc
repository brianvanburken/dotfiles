# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="avit"

plugins=(git git-flow osx rails ruby npm brew elixir)

source $ZSH/oh-my-zsh.sh
source $HOME/.profile
source $HOME/.bash_aliases
source $HOME/.asdf/asdf.sh
source $HOME/.zsh_functions

if [ -f $HOME/.shell_local ]
then
  source $HOME/.shell_local
fi
