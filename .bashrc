source ~/.profile
source ~/.bash_aliases


bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Fix rendering issues with Tmux
[ -n "$TMUX" ] && export TERM=screen-256color

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)";
  if [ "$branch" != "" ]; then
    local status="$(git status --porcelain 2> /dev/null)";
    echo -ne "$LIGHT_GRAY";
    echo -ne ":";
    if [ "$status" != "" ]; then
      echo -ne "$LIGHT_RED";
    else
      echo -ne "$LIGHT_GREEN";
    fi
    echo -ne "$branch";
    echo -ne "$LIGHT_GRAY$NC ";
  else
    echo -ne " ";
  fi;
}

PS1="\[$LIGHT_BLUE\]\W\[$NC\]"
PS1="$PS1\$(git_branch)"
PS1="$PS1\[$YELLOW\]\$(battery) "
PS1="$PS1\[$LIGHT_GRAY\]\n→\[$NC\] "
