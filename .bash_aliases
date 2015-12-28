# Shortkeys to make live easier
alias q='exit'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias ln='ln -i'
alias ll='ls -lahL'
alias mkdir='mkdir -p'

alias home='cd ~/'
alias root='cd ~/'
alias desk='cd ~/Desktop'
alias dev='cd ~/Developer/'
alias dot='cd ~/.dotfiles/'
o () { open ${1:-.}; }

alias kill_ds="find . -name .DS_Store -type f -delete"
alias grep='ag'
alias mine='sudo chown -R $(whoami):admin '

# NPM
alias npmci='rm -rf node_modules/ && echo "Removed node_modules" && npm cache clear && echo "Cleared NPM cache" && npm install'

# Tmux
alias tma='tmux attach -d -t'
alias tmn='tmux new -s'

# Vim
alias vi='vim'
alias v='vim'
alias e="$EDITOR"

# Git
alias gap='git add --patch'
alias gunstage='git reset HEAD'
alias gs='git status'
