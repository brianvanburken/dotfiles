# Shortkeys to make live easier
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias ln='ln -i'
alias mkdir='mkdir -p'
alias cls='clear'
alias dev='cd ~/Developer/'
alias dot='cd ~/.dotfiles/'

alias kill_ds="find . -name .DS_Store -type f -delete"
alias mine='sudo chown -R $(whoami):admin '

# NPM
alias npmci='rm -rf node_modules/ && echo "Removed node_modules" && npm cache clear && echo "Cleared NPM cache" && npm install'

# Yarn
alias y='yarn'
alias ya='yarn add'
alias yi='yarn init'
alias yu='yarn upgrade'
alias yg='yarn global'
alias yv='yarn --version'
alias yci='rm -rf node_modules/ && yarn'

# Vim
alias vi='vim'
alias v='vim'
alias e='vim'

# Git
alias gunstage='git reset HEAD'
alias gap='git add --patch'
alias gs='git status'

# Open all merge conflicts or currently changed files in Vim
alias fix="git diff --name-only | uniq | xargs -o vim"

# Work with dotfiles
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Fix ctags on macOS/OS X
alias ctags="`brew --prefix`/bin/ctags"

function replace() {
  find_this="$1"
  shift
  replace_with="$1"
  shift
  ag -l --nocolor "${find_this}" $* | xargs sed -i "" -e "s/${find_this}/${replace_with}/g"
}
