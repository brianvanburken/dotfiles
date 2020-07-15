source $HOME/.aliases
source $HOME/.zsh_functions

export EDITOR="vim"
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Block ADs and other analytics
export HOMEBREW_NO_ANALYTICS=1 # Disable homebrew analytics
export ADBLOCK=true
export DISABLE_OPENCOLLECTIVE=true
export DO_NOT_TRACK=1 # https://consoledonottrack.com/
export HOMEBREW_NO_ANALYTICS=1

# If FZF is installed and The Silver Searcher I configure fzf to use ag as the
# default command. This makes it faster in searching and also makes use of the
# .gitignore
export FZF_DEFAULT_COMMAND='ag --path-to-ignore $HOME/.agignore --hidden -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

# Set PATH
export ASDF_DATA_DIR=${ASDF_DATA_DIR:-$HOME/.asdf}
export HOMEBREW_BIN=/usr/local/opt

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$ASDF_DATA_DIR/shims"
export PATH="$PATH:$HOME/.shell"

export NEWLINE=$'\n'
export PS1="${NEWLINE}> "
export PROMPT=$PS1

export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE

setopt bang_hist              # Treat the '!' character specially during expansion.
setopt extended_history       # Write the history file in the ":start:elapsed;command" format.
setopt inc_append_history     # Write to the history file immediately, not when the shell exits.
setopt share_history          # Share history between all sessions.
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history.
setopt hist_ignore_dups       # Don't record an entry that was just recorded again.
setopt hist_ignore_all_dups   # Delete old recorded entry if new entry is a duplicate.
setopt hist_find_no_dups      # Do not display a line previously found.
setopt hist_ignore_space      # Don't record an entry starting with a space.
setopt hist_save_no_dups      # Don't write duplicate entries in the history file.
setopt hist_reduce_blanks     # Remove superfluous blanks before recording entry.
setopt hist_verify            # Don't execute immediately upon history expansion.
setopt hist_beep              # Beep when accessing nonexistent history.

# don't need to type cd to change directories
setopt autocd
setopt autopushd
setopt pushdignoredups

source $HOMEBREW_BIN/asdf/asdf.sh
source $HOMEBREW_BIN/z/etc/profile.d/z.sh

eval "$(direnv hook zsh)"

# Speed up ZSH by compiling and checking less
# https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
for dump in $HOME/.zcompdump(N.mh+24); do
  compinit
done
compinit -C
