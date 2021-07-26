# Execute code in the background to not affect the current session
{
  # Compile zcompdump, if modified, to increase startup speed.
  if [[ -s "$ZCOMPDUMP" && (! -s "$ZCOMPDUMP.zwc" || "$ZCOMPDUMP" -nt "$ZCOMPDUMP.zwc") ]]; then
    zcompile "$ZCOMPDUMP"
  fi
} &!
