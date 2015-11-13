# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export TERM=xterm-256color
export PATH="/Users/Brian/.rbenv/shims:~/bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/share/npm/sbin:/usr/local/sbin:/usr/sbin:/sbin:/opt/X11/bin:/Users/Brian/.rbenv/shims:~/bin"

ZSH_THEME="robbyrussell"

plugins=(git osx rails ruby npm brew)

source $ZSH/oh-my-zsh.sh

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Shortkeys to make live easier
alias q='exit'
alias ll='ls -lahL'
alias mine='sudo chown -R `whoami`'

alias home='cd ~/'
alias root='cd ~/'
alias desk='cd ~/Desktop'
alias dev='cd ~/Developer/'
alias dot='cd ~/.dotfiles/'

o () { open ${1:-.}; }

alias kill_ds="find . -name .DS_Store -type f -delete"
alias mkdir='mkdir -p'
alias grep='ag'

# Git
alias gap='git add --patch'
alias gunstage='git reset HEAD'
alias gs='git status'

# Tmux
alias tma='tmux attach -d -t'
alias tmn='tmux new -s'

# Vim
alias vi='vim'
v () { vim ${1:-.}; }

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
    rm -f -r /Library/Caches/Homebrew/*;
    brew doctor;
  fi

  read -q "REPLY?Do you want to update NPM and its packages? "
  echo # Move to next line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    npm update npm -g;
    npm update -g;
  fi

  read -q "REPLY?Do you want to update all the gems? "
  echo # Move to next line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    gem update;
  fi

  read -q "REPLY?Do you want to update mix?  "
  echo # Move to next line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    mix local.hex;
  fi

  read -q "REPLY?Do you want to update Vim? "
  echo # Move to next line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    working_dir=$(pwd);
    if [ ! -d "~/Developer/vim" ]; then
      echo "Vim directory not found. Creating one..."
      mkdir -p ~/Developer;
      cd ~/Developer;
      git clone git@github.com:vim/vim.git;
      cd vim;
      ./configure --with-features=huge \
        --prefix=/usr/local/ \
        --enable-multibyte \
        --enable-rubyinterp \
        --with-ruby-command=/usr/bin/ruby \
        --enable-pythoninterp \
        --with-python-config-dir=/usr/lib/python2.7/config \
        --enable-gui=no
    else
      cd ~/Developer/vim
    fi
    git pull;
    sudo make;
    sudo make install;
    cd working_dir;
  fi
}
