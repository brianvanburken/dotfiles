# If it's been more than this number of seconds since Homebrew was last
# updated, automatically run `brew update` before `brew install`.
# 604800 is 1 week in seconds (60 * 60 * 24 * 7).
set -gx HOMEBREW_AUTO_UPDATE_SECS 604800
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_INSTALL_CLEANUP 1
set -gx HOMEBREW_CLEANUP_MAX_AGE_DAYS 7 # Decrease from default 120 days
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx HOMEBREW_NO_EMOJI 1

set -q PATH; or set PATH ''; set -gx PATH "$CARGO_HOME/bin" $PATH;

abbr -a kill_ds fd -I -H '.DS_Store' -tf -X rm -rf
abbr -a kill_modules fd 'node_modules' -td -X rm -rf

# Cache the brew shellenv command to a file to cache it
set -l homebrew_cached_file "$XDG_CONFIG_HOME/fish/conf.d/homebrew-cached.fish"
if not test -e "$homebrew_cached_file"
  brew shellenv >> "$homebrew_cached_file"
end
