export PROMPT="%F{blue}%25>..>%1~%<< %(?.%F{green}.%F{red})$%f "

export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$HOMEBREW_PREFIX/opt/fzf/bin:$XDG_DATA_HOME/shell:$PATH"

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
setopt auto_pushd             # Push the current directory visited on the stack.
setopt pushd_ignore_dups      # Do not store duplicates in the stack.
setopt pushd_silent           # Do not print the directory stack after pushd or popd.

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR

# Load user functions
autoload -Uz $ZDOTDIR/functions/**/*

# Load autocompletions
autoload -Uz compinit

# Run compinit once a day based on the date of the zcompdump file
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' $ZCOMPDUMP 2>/dev/null || echo -1) ]; then
  compinit -C -d "$ZCOMPDUMP"
  # Update time of zcompdump file in case nothing has changed
  touch "$ZCOMPDUMP"
else
  compinit -C
fi

csource "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"
csource "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
csource "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
csource "$ZDOTDIR/aliases"
csource "$ZDOTDIR/.zshrc.local"

# Cache direnv hook
evalcache direnv hook zsh
