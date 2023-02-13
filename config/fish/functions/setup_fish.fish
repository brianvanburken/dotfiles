function setup_fish -d "Setup variables for Fish"
  # Block ads and other analytics
  set -U ADBLOCK true
  set -U DISABLE_OPENCOLLECTIVE true
  set -U DO_NOT_TRACK 1 # https://consoledonottrack.com/

  # Set lang
  set -U LANG "en_US.UTF-8"
  set -U LC_ALL "$LANG"
  set -U LC_CTYPE "$LANG"

  # Silent direnv
  set -U DIRENV_LOG_FORMAT ""

  # Homebrew
  set -U HOMEBREW_PREFIX "/opt/homebrew"
  set -U HOMBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
  set -U HOMBREW_REPOSITORY "$HOMEBREW_PREFIX"
  set -Ux MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH
  set -Ux INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH
  fish_add_path "$HOMEBREW_PREFIX/bin"
  fish_add_path "$HOMEBREW_PREFIX/sbin"

  # https://0x46.net/thoughts/2019/02/01/dotfile-madness/
  set -U XDG_CONFIG_HOME "$HOME/.config"
  set -U XDG_CACHE_HOME "$HOME/.cache"
  set -U XDG_DATA_HOME "$HOME/.local/share"
  set -U XDG_STATE_HOME "$HOME/.local/state"
  set -U XDG_RUNTIME_DIR "$XDG_DATA_HOME"
  set -U XDG_CONFIG_DIRS "/etc/xdg:$XDG_CONFIG_HOME"
  set -U XDG_DATA_DIRS "/usr/local/share:/usr/share:$XDG_DATA_HOME"

  set -U EDITOR "nvim"
  set -U VISUAL "$EDITOR"

  # Set XDG for tools
  # Less
  set -U LESSHISTFILE "$XDG_CACHE_HOME/less/history"
  set -U LESSKEY "$XDG_CONFIG_HOME/less/keys"

  # Asdf
  set -U ASDF_DIR "$HOMEBREW_PREFIX/opt/asdf/libexec"
  set -U ASDF_BIN "$ASDF_DIR/bin"
  set -U ASDF_DATA_DIR "$XDG_DATA_HOME/asdf"
  set -U ASDF_USER_SHIMS "$ASDF_DATA_DIR/shims"
  set -U ASDF_CONFIG_DIR "$XDG_CONFIG_HOME/asdf"
  set -U ASDF_CONFIG_FILE "$ASDF_CONFIG_DIR/asdfrc"
  set -U ASDF_GEM_DEFAULT_PACKAGES_FILE "$ASDF_CONFIG_DIR/default-gems"
  set -U ASDF_NPM_DEFAULT_PACKAGES_FILE "$ASDF_CONFIG_DIR/default-npm-packages"
  set -U ASDF_PYTHON_DEFAULT_PACKAGES_FILE "$ASDF_CONFIG_DIR/default-python-packages"
  fish_add_path "$ASDF_BIN"
  fish_add_path "$ASDF_USER_SHIMS"

  # Node.js
  set -U BABEL_CACHE_PATH "$XDG_CACHE_HOME/babel.json"
  set -U NODE_REPL_HISTORY "$XDG_CACHE_HOME/node/repl_history"
  set -U NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
  set -U NPM_CONFIG_DEVDIR "$XDG_CACHE_HOME/node-gyp"
  set -U NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/config"

  # Elm
  set -U ELM_HOME "$XDG_CACHE_HOME/elm"

  # Ruby
  set -U GEMRC "$XDG_CONFIG_HOME/gem/config.yml"
  set -U GEM_HOME "$XDG_DATA_HOME/gem"
  set -U GEM_SPEC_CACHE "$GEM_HOME/specs"
  set -U IRBRC "$XDG_CONFIG_HOME/irb/config"
  set -U BUNDLE_USER_HOME "$XDG_CONFIG_HOME/bundler"
  set -U BUNDLE_USER_CONFIG "$BUNDLE_USER_HOME/config.yml"
  set -U BUNDLE_USER_CACHE "$XDG_CACHE_HOME/bundler"
  set -U BUNDLE_USER_PLUGIN "$XDG_DATA_HOME/bundler"

  # Rust
  set -U CARGO_CACHE_DIR "$XDG_CACHE_HOME/cargo"
  set -U CARGO_CONFIG_DIR "$XDG_CONFIG_HOME/cargo"
  set -U CARGO_HOME "$XDG_DATA_HOME/cargo"
  set -U RUSTUP_HOME "$XDG_DATA_HOME/rustup"
end
