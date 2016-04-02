# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="avit"

plugins=(git git-flow osx rails ruby npm brew elixir)

source $ZSH/oh-my-zsh.sh
source $HOME/.profile
source $HOME/.bash_aliases

if [ -f $HOME/.shell_local ]
then
  source $HOME/.shell_local
fi

# Update software
updatify() {
  read -q "REPLY?Do you want to upgrade oh-my-zsh? "
  echo # Move to next line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    upgrade_oh_my_zsh
  fi

  read -q "REPLY?Do you want to install Applestore updates? "
  echo # Move to next line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    sudo softwareupdate -i -a;
  fi

  read -q "REPLY?Do you want to update brew and its packages? "
  echo # Move to next line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    brew update;
    brew upgrade;
    brew prune;
    brew cleanup --force;
    brew cask cleanup;
    brew doctor;
    rm -f -r /Library/Caches/Homebrew/*;
  fi

  read -q "REPLY?Do you want to update global NPM packages? "
  echo # Move to next line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    npm update -g;
  fi

  read -q "REPLY?Do you want to update all the gems? "
  echo # Move to next line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    gem update;
  fi
}
