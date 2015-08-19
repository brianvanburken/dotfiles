# Shortkeys to make live easier
alias q='exit'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cp='cp -i'
alias rm='rm -i'
alias rrm='rm -rf'
alias mv='mv -i'
alias ln='ln -i'
alias ll='ls -lahL'
alias mine='sudo chown -R `whoami`'

alias ...='cd ../..'
alias home='cd ~/'
alias root='cd ~/'
alias desk='cd ~/Desktop'
alias dev='cd ~/Developer/'
alias dot='cd ~/.dotfiles/'
o () { open ${1:-.}; }

alias kill_ds="find . -name .DS_Store -type f -delete"
alias mkdir='mkdir -p'
alias md='mkdir'
alias grep='ag'

# Tmux
alias tma='tmux attach -d -t'
alias tmn='tmux new -s'

# Vim
alias vi='vim'
v () { vim ${1:-.}; }
alias e="$EDITOR"

# Brew
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

# NPM
alias npms='npm i -S'
alias npmsd='npm i -D'

# Heroku
alias h='heroku'
alias hr='heroku run'
alias hc='heroku run rails c'
alias hm='heroku run rake db:migrate'

# Bundler
alias be="bundle exec"
alias bl="bundle list"
alias bp="bundle package"
alias bo="bundle open"
alias bu="bundle update"
alias bi="bundle install"

# Rake
alias migrate='rake db:migrate'
alias resetdb='rake db:drop && rake db:create && rake db:migrate && rake db:seed'

# Ember
alias es='ember serve'
alias ea='ember addon'
alias eb='ember build'
alias ed='ember destroy'
alias eg='ember generate'
alias eh='ember help'
alias ein='ember init'
alias eia='ember install:addon'
alias eib='ember install:bower'
alias ein='ember install:npm'
alias ei='ember install'
alias et='ember test'
alias eu='ember update'
alias ev='ember version'

# Rails
alias rc='rails console'
alias rd='rails destroy'
alias rdb='rails dbconsole'
alias rg='rails generate'
alias rgm='rails generate migration'
alias rs='rails server'
rn () { rails new ${1} ${@:2} && cd ${1} && git init && git add . && git commit -m "Initial commit."; }

# Git
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'
alias gb='git branch'
alias gba='git branch -a'
alias gbr='git branch --remote'
alias gc!='git commit -v --amend'
alias gc='git commit -v'
alias gca!='git commit -v -a --amend'
alias gca='git commit -v -a'
alias gcl='git config --list'
alias gclean='git reset --hard && git clean -dfx'
alias gcm='git checkout master'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdt='git difftool'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias gl='git pull'
alias glog='git log --pretty=format:"%C(yellow)%h%C(reset) %C(green)%ar%C(reset) %C(bold blue)%an%C(reset) %C(red)%d%C(reset) %s" --graph --abbrev-commit --decorate'
alias gm='git merge'
alias gp='git push'
alias gr='git remote'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grup='git remote update'
alias grv='git remote -v'
alias gs='git status'
alias gss='git status -s'
alias gsta='git stash'
alias gstd='git stash drop'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gundo='git stash save --keep-index && git stash drop'
alias gunignore='git update-index --no-assume-unchanged'
alias gunstage='git reset HEAD'
alias gup='git pull --rebase'
alias gwc='git whatchanged -p --abbrev-commit --pretty=medium'

battery () { pmset -g ps | sed -n 's/.*[[:blank:]]+*\(.*%\).*/\1/p'; }
isBatteryCharging() { ioreg -n AppleSmartBattery -r | awk '$1~/ExternalConnected/{gsub("Yes", "+");gsub("No", "%"); print substr($0, length, 1)}'; }
