function setup_fish -d "Setup variables for Fish"
    # Block ads and other analytics
    set -Ux ADBLOCK true
    set -Ux DISABLE_OPENCOLLECTIVE true
    set -Ux DO_NOT_TRACK 1 # https://consoledonottrack.com/

    # Set lang
    set -Ux LANG "en_US.UTF-8"
    set -Ux LC_ALL "$LANG"
    set -Ux LC_CTYPE "$LANG"

    # Silent direnv
    set -Ux DIRENV_LOG_FORMAT ""

    # Homebrew
    set -Ux HOMEBREW_NO_ANALYTICS 1
    set -Ux HOMEBREW_PREFIX "/opt/homebrew"
    set -Ux HOMBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
    set -Ux HOMBREW_REPOSITORY "$HOMEBREW_PREFIX"
    set -Ux MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH
    set -Ux INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH
    fish_add_path "$HOMEBREW_PREFIX/bin"
    fish_add_path "$HOMEBREW_PREFIX/sbin"

    # https://0x46.net/thoughts/2019/02/01/dotfile-madness/
    set -Ux XDG_CONFIG_HOME "$HOME/.config"
    set -Ux XDG_CACHE_HOME "$HOME/.cache"
    set -Ux XDG_DATA_HOME "$HOME/.local/share"
    set -Ux XDG_STATE_HOME "$HOME/.local/state"
    set -Ux XDG_RUNTIME_DIR "$XDG_DATA_HOME"
    set -Ux XDG_CONFIG_DIRS "/etc/xdg:$XDG_CONFIG_HOME"
    set -Ux XDG_DATA_DIRS "/usr/local/share:/usr/share:$XDG_DATA_HOME"

    set -Ux EDITOR "nvim"
    set -Ux VISUAL "$EDITOR"

    # Set XDG for tools
    # Less
    set -Ux LESSHISTFILE "$XDG_CACHE_HOME/less/history"
    set -Ux LESSKEY "$XDG_CONFIG_HOME/less/keys"

    # Asdf/mise
    set -Ux ASDF_DIR "$HOMEBREW_PREFIX/opt/asdf/libexec"
    set -Ux ASDF_BIN "$ASDF_DIR/bin"
    set -Ux ASDF_DATA_DIR "$XDG_DATA_HOME/asdf"
    set -Ux ASDF_USER_SHIMS "$ASDF_DATA_DIR/shims"
    set -Ux ASDF_CONFIG_DIR "$XDG_CONFIG_HOME/asdf"
    set -Ux ASDF_CONFIG_FILE "$ASDF_CONFIG_DIR/asdfrc"
    set -Ux ASDF_GEM_DEFAULT_PACKAGES_FILE "$ASDF_CONFIG_DIR/default-gems"
    set -Ux ASDF_NPM_DEFAULT_PACKAGES_FILE "$ASDF_CONFIG_DIR/default-npm-packages"
    set -Ux ASDF_PYTHON_DEFAULT_PACKAGES_FILE "$ASDF_CONFIG_DIR/default-python-packages"
    fish_add_path "$ASDF_BIN"
    fish_add_path "$ASDF_USER_SHIMS"

    # Node.js
    set -Ux BABEL_CACHE_PATH "$XDG_CACHE_HOME/babel.json"
    set -Ux NODE_REPL_HISTORY "$XDG_CACHE_HOME/node/repl_history"
    set -Ux NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
    set -Ux NPM_CONFIG_DEVDIR "$XDG_CACHE_HOME/node-gyp"
    set -Ux NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/config"

    # Elm
    set -Ux ELM_HOME "$XDG_CACHE_HOME/elm"

    # Ruby
    set -Ux GEMRC "$XDG_CONFIG_HOME/gem/config.yml"
    set -Ux GEM_HOME "$XDG_DATA_HOME/gem"
    set -Ux GEM_SPEC_CACHE "$GEM_HOME/specs"
    set -Ux IRBRC "$XDG_CONFIG_HOME/irb/config"
    set -Ux BUNDLE_USER_HOME "$XDG_CONFIG_HOME/bundler"
    set -Ux BUNDLE_USER_CONFIG "$BUNDLE_USER_HOME/config.yml"
    set -Ux BUNDLE_USER_CACHE "$XDG_CACHE_HOME/bundler"
    set -Ux BUNDLE_USER_PLUGIN "$XDG_DATA_HOME/bundler"

    # Rust
    set -Ux CARGO_CACHE_DIR "$XDG_CACHE_HOME/cargo"
    set -Ux CARGO_CONFIG_DIR "$XDG_CONFIG_HOME/cargo"
    set -Ux CARGO_HOME "$XDG_DATA_HOME/cargo"
    set -Ux RUSTUP_HOME "$XDG_DATA_HOME/rustup"
    fish_add_path "$CARGO_HOME/bin"

    # Gitleaks
    set -Ux GITLEAKS_CONFIG "$XDG_CONFIG_HOME/gitleaks/config.toml"

    # Personal dirs

    # Cache zoxide init command to a file to cache
    zoxide init fish > "$XDG_CONFIG_HOME/fish/conf.d/zoxide_cached.fish"

    # Cache mise activate command to a file to cache
    mise activate fish > "$XDG_CONFIG_HOME/fish/conf.d/mise_cached.fish"
    mise complete -s fish > "$XDG_CONFIG_HOME/fish/completions/mise_cached.fish"

    # Cache 1Password completions
    op completion fish > "$XDG_CONFIG_HOME/fish/completions/op_cached.fish"

    # Cache asdf command
    # cat "$(brew --prefix asdf)/libexec/asdf.fish" > "$XDG_CONFIG_HOME/fish/conf.d/asdf-cached.fish"

    fish_update_completions

    fish_config theme save "Just a Touch"
end
