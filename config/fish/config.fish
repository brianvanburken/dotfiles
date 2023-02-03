# Unset welcome message
set -g fish_greeting

if status is-interactive 
and not set -q TMUX
  set -l session_name "workspace"
  tmux new -t "$session_name"
  tmux attach -t "$session_name"
end

# Cache zoxide init command to a file to cache
set -l zoxide_cached_file "$XDG_CONFIG_HOME/fish/conf.d/zoxide-cached.fish"
if not test -e "$zoxide_cached_file"
  zoxide init fish >> "$zoxide_cached_file"
end
