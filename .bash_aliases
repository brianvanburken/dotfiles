# Shortkeys to make live easier
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias ln='ln -i'
alias ll='ls -lahg'
alias mkdir='mkdir -p'

alias dev='cd ~/Developer/'
alias dot='cd ~/.dotfiles/'

alias kill_ds="find . -name .DS_Store -type f -delete"
alias mine='sudo chown -R $(whoami):admin '

# NPM
alias npmci='rm -rf node_modules/ && echo "Removed node_modules" && npm cache clear && echo "Cleared NPM cache" && npm install'

# Vim
alias vi='vim'
alias v='vim'
alias e="$EDITOR"

# Git
alias gap='git add --patch'
alias gunstage='git reset HEAD'
alias gs='git status'
alias gix='git clean -ix'

# Open all merge conflicts or currently changed files in Vim
alias fix="git diff --name-only | uniq | xargs -o vim"

# Work with dotfiles
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
