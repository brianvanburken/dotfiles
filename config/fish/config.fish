if status is-interactive 
and not set -q TMUX
  set -l session_name "workspace"
  tmux new -t "$session_name"
  tmux attach -t "$session_name"
end

# TODO: Should be cached
#  write function that outputs to a file in a folder and sources it
#  check time of file and renew after n days
zoxide init fish | source

# Unset welcome message
set -g fish_greeting
