# Shortkeys to make live easier
alias :q='exit'
alias ..='cd ..;' # can then do .. .. .. to move up multiple directories.
alias ...='.. ..'
alias cp='cp -i'
alias rm='rm -i'
alias rrm='rm -rf'
alias mv='mv -i'
alias ln='ln -i'
alias ll='la'
alias restart='sudo shutdown -r now'

alias ...='../..'
alias hm='~/'
alias root='~/'
alias desk='~/Desktop'
alias dev='~/Dropbox/Home/Developer/'
      o () { open ${1:-.} }

alias kill_ds="find . -name .DS_Store -type f -delete"
alias mkdir='mkdir -p'
alias md='mkdir'
alias reload='source $ZSH/oh-my-zsh.sh'
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias grep='ag'

# Alias vim to mvim
alias vim='mvim'
alias vi='vim'
      v () { vim ${1:-.} }
alias e="$EDITOR"

# Brew
alias brewify='brew update && brew upgrade && brew prune && brew cleanup && brew cask cleanup && brew doctor'

# Heroku
# Force the use of Heroku Toolbelt instead of a locally installed gem
alias heroku='/usr/bin/heroku'
alias heroky='heroku'
alias h='heroku'
alias hr='h run'
alias hc='h run rails c'
alias hm='h run rake db:migrate'

# Rake
alias r='rake'
alias migrate='r db:migrate'
alias resetdb='rake db:drop && rake db:create && rake db:migrate && rake db:seed'

# Rails
alias rsc='rails console'
alias rss='rails server'
      rsn () { rails new ${1} ${@:2} && cd ${1} && git init && git add . && git commit -m "Initial commit." }
alias spec='bin/rspec .'
alias rubo='rubocop -R -l -c rubocop.yml'

# Git aliases
alias ga='git add'
alias gl='git pull'
alias gp='git push'
alias gs='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias gap='git add --patch'
alias gunstage='git reset HEAD'
alias gundo='git stash save --keep-index && git stash drop'
alias glog='git log --pretty=format:"%C(yellow)%h%C(reset) %C(green)%ar%C(reset) %C(bold blue)%an%C(reset) %C(red)%d%C(reset) %s" --graph --abbrev-commit --decorate'
