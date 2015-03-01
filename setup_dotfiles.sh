#!/bin/bashln -s ~/Dropbox/Dotfiles/.bash_aliases
sudo -v

cd ~/

sudo rm -rf ~/.bash_aliases
sudo rm -rf ~/.bash_profile
sudo rm -rf ~/.bashrc
sudo rm -rf ~/.bundle
sudo rm -rf ~/.csscomb.json
sudo rm -rf ~/.gemrc
sudo rm -rf ~/.gitconfig
sudo rm -rf ~/.gitignore_global
sudo rm -rf ~/.powconfig
sudo rm -rf ~/.profile
sudo rm -rf ~/.railsrc
sudo rm -rf ~/.slate
sudo rm -rf ~/.vim
sudo rm -rf ~/.vimrc
sudo rm -rf ~/.zlogin
sudo rm -rf ~/.zshrc

ln -s ~/.dotfiles/.bash_aliases     ~/.bash_aliases
ln -s ~/.dotfiles/.bash_profile     ~/.bash_profile
ln -s ~/.dotfiles/.bashrc           ~/.bashrc
ln -s ~/.dotfiles/.bundle           ~/.bundle
ln -s ~/.dotfiles/.csscomb.json     ~/.csscomb.json
ln -s ~/.dotfiles/.gemrc            ~/.gemrc
ln -s ~/.dotfiles/.gitconfig        ~/.gitconfig
ln -s ~/.dotfiles/.gitignore_global ~/.gitignore_global
ln -s ~/.dotfiles/.powconfig        ~/.powconfig
ln -s ~/.dotfiles/.profile          ~/.profile
ln -s ~/.dotfiles/.railsrc          ~/.railsrc
ln -s ~/.dotfiles/.slate            ~/.slate
ln -s ~/.dotfiles/.vim              ~/.vim
ln -s ~/.dotfiles/.vimrc            ~/.vimrc
ln -s ~/.dotfiles/.zlogin           ~/.zlogin
ln -s ~/.dotfiles/.zshrc            ~/.zshrc
