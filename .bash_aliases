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
alias ll='ls -la'
alias restart='sudo shutdown -r now'

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

# Alias vim to mvim
alias vi='vim'
      v () { vim ${1:-.}; }
alias e="$EDITOR"

# Brew
alias updatify='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; brew doctor; npm update npm -g; npm update -g; sudo gem update'
alias brewify='brew update && brew upgrade && brew prune && brew cleanup && brew doctor'

# Heroku
# Force the use of Heroku Toolbelt instead of a locally installed gem
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
      rsn () { rails new ${1} ${@:2} && cd ${1} && git init && git add . && git commit -m "Initial commit."; }
alias spec='bin/rspec .'
alias rubo='rubocop -R -l -c rubocop.yml'

# Git aliases
alias g='git'
alias ga='git add'
alias gl='git pull'
alias gp='git push'
alias gs='git status'
alias gd='git diff'
alias gco='git checkout'
alias gcm='git commit -m'
alias gap='git add --patch'
alias gunstage='git reset HEAD'
alias gundo='git stash save --keep-index && git stash drop'
alias glog='git log --pretty=format:"%C(yellow)%h%C(reset) %C(green)%ar%C(reset) %C(bold blue)%an%C(reset) %C(red)%d%C(reset) %s" --graph --abbrev-commit --decorate'

# Build vim
alias update_vim='dev && cd vim/ && hg pull && hg update && sudo make && sudo make install'

# Check battery
battery () { pmset -g ps | sed -n 's/.*[[:blank:]]+*\(.*%\).*/\1/p' }

# Compare orginal and gzipped file size
# https://github.com/quoo/dotfiles
gz() {
  local origsize=$(wc -c < "$1")
  local gzipsize=$(gzip -c "$1" | wc -c)
  local ratio=$(echo "$gzipsize * 100/ $origsize" | bc -l)
  printf "orig: %d bytes\n" "$origsize"
  printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio"
}
