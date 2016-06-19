# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="avit"

plugins=(git git-flow osx rails ruby npm brew elixir)

source $ZSH/oh-my-zsh.sh
source $HOME/.profile
source $HOME/.bash_aliases
source $HOME/.zsh_functions

if [ -f $HOME/.shell_local ]
then
  source $HOME/.shell_local
fi

function t() {
  # Defaults to 3 levels deep, do more with `t 5` or `t 1`
  # pass additional args after
  local levels=${1:-3}; shift
  tree -I '.git|node_modules|bower_components|.DS_Store' --dirsfirst -L $levels -aC $@
}

# Update software
updatify() {
  brew update;
  brew upgrade;
  brew prune;
  brew cleanup --force;
  brew cask cleanup;
  brew doctor;
  rm -f -r /Library/Caches/Homebrew/*;
}
