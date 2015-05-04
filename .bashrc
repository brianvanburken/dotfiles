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

export NC='\033[0m' # No Color
export WHITE='\033[1;37m'
export BLACK='\033[0;30m'
export BLUE='\033[0;34m'
export LIGHT_BLUE='\033[1;34m'
export GREEN='\033[0;32m'
export LIGHT_GREEN='\033[1;32m'
export CYAN='\033[0;36m'
export LIGHT_CYAN='\033[1;36m'
export RED='\033[0;31m'
export LIGHT_RED='\033[1;31m'
export PURPLE='\033[0;35m'
export LIGHT_PURPLE='\033[1;35m'
export BROWN='\033[0;33m'
export YELLOW='\033[1;33m'
export GRAY='\033[0;30m'
export LIGHT_GRAY='\033[0;37m'

git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  local status=$(git status --porcelain 2> /dev/null)

  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    printf " $LIGHT_GRAY"
    printf "("
    if [[ "$status" != "" ]]; then
      printf "$LIGHT_RED"
    else
      printf "$LIGHT_GREEN"
    fi
    echo -ne "$branch"
    echo -ne "${LIGHT_GRAY})${NC} "
  fi
}

battery_prompt() {
  echo -ne " ${LIGHT_GRAY}["
  echo -ne "$(battery)"
  echo -ne "]${NC}"
}

export PS1="\[${LIGHT_BLUE}\]\W\$(battery_prompt)\$(git_branch)\[${LIGHT_GRAY}\]→\[${NC}\] "
