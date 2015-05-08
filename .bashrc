source ~/.profile
source ~/.bash_aliases


bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

tmxdev() {
  tmux new-session -d 'vim';
  tmux split-window -h;
  tmux split-window -v;
  tmux split-window -v;
  tmux -2 attach-session -d;
}

git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  local status=$(git status --porcelain 2> /dev/null)

  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    printf "$LIGHT_GRAY"
    printf "("
    if [[ "$status" != "" ]]; then
      printf "$LIGHT_RED"
    else
      printf "$LIGHT_GREEN"
    fi
    echo -ne "$branch"
    echo -ne "$LIGHT_GRAY)${NC}"
  fi
}

PS1="\[$LIGHT_GREEN\]\u\[$NC\] at \[$LIGHT_BLUE\]\W"
PS1="$PS1\$(git_branch)"
PS1="$PS1\[$LIGHT_GRAY\] ruby-\$(rbenv version | sed -e 's/ .*//')"
PS1="$PS1\[$YELLOW\] \$(battery)"
PS1="$PS1\[$LIGHT_GRAY\]\n→\[$NC\] "
