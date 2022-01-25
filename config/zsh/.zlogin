# Execute code in the background to not affect the current session
{
  source "$ZDOTDIR/functions/zcompare"

  zcompare "$ZCOMPDUMP"
  zcompare "$ZDOTDIR/.zshrc"

} &!
