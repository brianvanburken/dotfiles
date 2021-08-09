# Execute code in the background to not affect the current session
{

  # Run compinit once a day based on the date of the zcompdump file
  autoload -Uz compinit
  if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' $ZCOMPDUMP 2>/dev/null || echo -1) ]; then
    compinit -C -d $ZCOMPDUMP
    # Update time of zcompdump file in case nothing has changed
    touch $ZCOMPDUMP
  else
    compinit -C
  fi

  # All files to precompile
  local files=(
    "$ZCOMPDUMP"
    "$ZDOTDIR/aliases"
    "$ZDOTDIR/functions"
  )

  for x in $files; do
    # Compile file, if modified, to increase startup speed.
    if [[ -s "$x" && (! -s "$x.zwc" || "$x" -nt "$x.zwc") ]]; then
      zcompile "$x"
    fi
  done

} &!
