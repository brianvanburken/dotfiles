#!/bin/bashln -s ~/Dropbox/Dotfiles/.bash_aliases
sudo -v

files=(.agignore .bash_aliases .bash_profile .bashrc .bundle .csscomb.json .gemrc
       .gitconfig .gitignore_global .powconfig .profile .railsrc .slate .vim
       .vimrc .zlogin .zshrc)
dir="$PWD/"

for i in ${files[@]}; do
  sudo rm -rf ~/${i} && ln -s ${dir}${i} ~/${i}
done
