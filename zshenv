export EDITOR='vim'
export GIT_EDITOR='vim'
export HOMEBREW_EDITOR='vim'
export CLICOLOR=1
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Block ADs and other analytics
export HOMEBREW_NO_ANALYTICS=1 # Disable homebrew analytics
export ADBLOCK=true
export DISABLE_OPENCOLLECTIVE=true
export DO_NOT_TRACK=1 # https://consoledonottrack.com/
export HOMEBREW_NO_ANALYTICS=1
export NG_CLI_ANALYTICS=false # https://github.com/angular/angular-cli/blob/master/docs/design/analytics.md

# Disable shell sessions
export SHELL_SESSIONS_DISABLE=1

# Silent direnv
export DIRENV_LOG_FORMAT=""

# If FZF is installed and The Silver Searcher I configure fzf to use ag as the
# default command. This makes it faster in searching and also makes use of the
# .gitignore
export FZF_DEFAULT_COMMAND='ag --path-to-ignore $HOME/.agignore --hidden -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE

# Set PATH
export HOMEBREW_DIR=/usr/local

export PATH="$PATH:$HOMEBREW_DIR/sbin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.shell"
