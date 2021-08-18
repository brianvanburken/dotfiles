# Execute code in the background to not affect the current session
{
  # Function to determine the need of a zcompile. If the .zwc file
  # does not exist, or the base file is newer, we need to compile.
  # These jobs are asynchronous, and will not impact the interactive shell
  zcompare() {
    if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc) ]]; then
      zcompile ${1}
    fi
  }

  # # All files to precompile
  local files=(
    "$ZCOMPDUMP"
    "$ZDOTDIR/.zshrc"
    "$ZDOTDIR/.zshrc.local"
    "$ZDOTDIR/aliases"
    "$ZDOTDIR/functions"
  )

  for x in $files; do
    zcompare ${file}
  done

} &!
