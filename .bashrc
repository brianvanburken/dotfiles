source ~/.profile
source ~/.bash_aliases

export TERM=xterm-256color

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)";
  if [ "$branch" != "" ]; then
    local status="$(git status --porcelain 2> /dev/null)";
    echo -ne "$LIGHT_GRAY";
    echo -ne ":";
    if [ "$status" != "" ]; then
      echo -ne "$LIGHT_RED";
    else
      echo -ne "$LIGHT_GREEN";
    fi
    echo -ne "$branch";
    echo -ne "$LIGHT_GRAY$NC ";
  else
    echo -ne " ";
  fi;
}

# Update software
updatify() {
  read -p "Do you want to search for Applestore updates? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    sudo softwareupdate -i -a;
  fi

  read -p "Do you want to update brew and its packages? " -n 1 -r
  echo    # (optional) move to a new line
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

  read -p "Do you want to update NPM and its packages? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    npm update npm -g;
    npm update -g;
  fi

  read -p "Do you want to update all the gems? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    gem update;
  fi

  read -p "Do you want to update Vim? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
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
  fi
}

PS1="\[$LIGHT_BLUE\]\W\[$NC\]"
PS1="$PS1\$(git_branch)"
PS1="$PS1\[$YELLOW\]\$(battery) "
PS1="$PS1\[$LIGHT_GRAY\]\n→\[$NC\] "
