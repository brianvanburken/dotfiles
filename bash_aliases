# Shortkeys to make live easier
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias ln='ln -i'
alias mkdir='mkdir -p'
alias cls='clear'
alias dev='cd ~/Developer/'

alias kill_ds="find . -name .DS_Store -type f -delete"
alias mine='sudo chown -R $(whoami):admin '

# NPM
alias nr='npm run'
alias ni='npm install'
alias nci='rm -rf node_modules/ package-lock.json && npm install'
alias nt='npm test'

# Vim
alias vi='vim'
alias v='vim'
alias e='vim'

# Open all merge conflicts or currently changed files in Vim
alias fix='git diff --name-only | uniq | xargs -o vim'

# Work with dotfiles
alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Fix ctags on macOS/OS X
alias ctags="`brew --prefix`/bin/ctags"

# Shortcuts for checking NPM packages using npm-check
alias ncu='npm-check -u --no-emoji'
alias ncgu='npm-check -gu --no-emoji'

# Elm shortcuts
alias em='elm make'
alias er='elm repl'
alias et='elm test'
alias el='elm live'
alias ef='elm format'
alias epi='elm-package install'

# The silver searcher
alias af='ag -g'
