source $HOME/.aliases
source $HOME/.zsh_functions
source $HOMEBREW_DIR/opt/asdf/asdf.sh

export EDITOR=nvim

export PROMPT="%F{blue}%1~%f %(?.%F{green}.%F{red})%#%f "

# Lazy-load Z only when called to speed up zsh load time
function z() {
  unfunction z
  source "$HOMEBREW_DIR/opt/z/etc/profile.d/z.sh"
  _z "$@"
}

# Cache direnv hook
_evalcache direnv hook zsh

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

# Don't need to type cd to change directories
setopt autocd
setopt autopushd
setopt pushdignoredups
