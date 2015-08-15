#!/bin/sh
echo Install all AppStore Apps at first!
read -p "Press any key to continue... " -n1 -s
echo  '\n'
echo Installing homebrew caskroom...
brew tap phinze/cask
brew install brew-cask

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

read -p "Do you want to install Afred? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  brew cask install alfred
  brew cask alfred link
fi

read -p "Do you want to install Firefox? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  brew cask install firefox
fi

read -p "Do you want to install Opera? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  brew cask install opera
fi

read -p "Do you want to install Google Chrome? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  brew cask install google-chrome
fi

read -p "Do you want to install f.lux? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  brew cask install flux
fi

read -p "Do you want to install Slate? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  brew cask install mattr-slate
fi

read -p "Do you want to install Cookie? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  brew cask install cookie
fi

echo Cleaning up...
brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*
