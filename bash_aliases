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
alias nr='npm run'
alias ni='npm install'
alias nis='npm install --save'
alias niS='npm install --save-dev'
alias ngi='npm install -g'
alias nci='rm -rf node_modules/ && npm install'
alias nt='npm test'

# Yarn
alias yi='yarn install'
alias yis='yarn add --save'
alias yiS='yarn add --save-dev'
alias ygi='yarn global add'
alias yci='rm -rf node_modules/ && yarn install'

# Vim
alias vi='echo "Use e"'
alias v='echo "Use e"'
alias e='vim'

# Open all merge conflicts or currently changed files in Vim
alias fix='git diff --name-only | uniq | xargs -o vim'
alias gbr='git branch | grep -v "master" | xargs git branch -D'

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
alias epi='elm install'
alias et='elm-thanks'
alias eci='rm -rf elm-stuff/ && elm-package install -y'
alias emt='elm make --docs=/dev/null --yes'

# The silver searcher
alias af='ag -g'
