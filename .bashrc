export CC=gcc
export EDITOR='vim'
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export CLICOLOR=1
export TERM="xterm-256color"

# Improve Ruby GC
export RUBY_GC_HEAP_INIT_SLOTS=2000000
export RUBY_HEAP_SLOTS_INCREMENT=500000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=70000000
export RUBY_GC_HEAP_FREE_SLOTS=100000

export NC='\e[0m' # No Color
export WHITE='\e[1;37m'
export BLACK='\e[0;30m'
export BLUE='\e[0;34m'
export LIGHT_BLUE='\e[1;34m'
export GREEN='\e[0;32m'
export LIGHT_GREEN='\e[1;32m'
export CYAN='\e[0;36m'
export LIGHT_CYAN='\e[1;36m'
export RED='\e[0;31m'
export LIGHT_RED='\e[1;31m'
export PURPLE='\e[0;35m'
export LIGHT_PURPLE='\e[1;35m'
export BROWN='\e[0;33m'
export YELLOW='\e[1;33m'
export GRAY='\e[0;30m'
export LIGHT_GRAY='\e[0;37m'

git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  local status=$(git status --porcelain 2> /dev/null)

  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    printf " ${LIGHT_GRAY}("
    if [[ "$status" != "" ]]; then
      printf "${LIGHT_RED}"
    else
      printf "${LIGHT_GREEN}"
    fi
    printf "$branch"
    printf "${LIGHT_GRAY})"
  fi
}

export PS1="\[${LIGHT_BLUE}\]\W\$(git_branch) \[${LIGHT_GRAY}\]→\[${NC}\] "
