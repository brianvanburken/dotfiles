export EDITOR="vim"
export TERM="xterm-256color"
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="/usr/local/sbin:$PATH"

# If FZF is installed and The Silver Searcher I configure fzf to use ag as the
# default command. This makes it faster in searching and also makes use of the
# .gitignore AND .agignore!
export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

export DOT_PATH="$(pwd)"
