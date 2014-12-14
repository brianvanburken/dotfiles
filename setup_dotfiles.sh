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
sudo rm -rf ~/.vim
sudo rm -rf ~/.vimrc
sudo rm -rf ~/.zlogin
sudo rm -rf ~/.zshrc

ln -s ~/Dropbox/Home/Dotfiles/.bash_aliases ~/.bash_aliases
ln -s ~/Dropbox/Home/Dotfiles/.bash_profile ~/.bash_profile
ln -s ~/Dropbox/Home/Dotfiles/.bashrc ~/.bashrc
ln -s ~/Dropbox/Home/Dotfiles/.bundle ~/.bundle
ln -s ~/Dropbox/Home/Dotfiles/.csscomb.json ~/.csscomb.json
ln -s ~/Dropbox/Home/Dotfiles/.gemrc ~/.gemrc
ln -s ~/Dropbox/Home/Dotfiles/.gitconfig ~/.gitconfig
ln -s ~/Dropbox/Home/Dotfiles/.gitignore_global ~/.gitignore_global
ln -s ~/Dropbox/Home/Dotfiles/.powconfig ~/.powconfig
ln -s ~/Dropbox/Home/Dotfiles/.profile ~/.profile
ln -s ~/Dropbox/Home/Dotfiles/.railsrc ~/.railsrc
ln -s ~/Dropbox/Home/Dotfiles/.vim ~/.vim
ln -s ~/Dropbox/Home/Dotfiles/.vimrc ~/.vimrc
ln -s ~/Dropbox/Home/Dotfiles/.zlogin ~/.zlogin
ln -s ~/Dropbox/Home/Dotfiles/.zshrc ~/.zshrc
