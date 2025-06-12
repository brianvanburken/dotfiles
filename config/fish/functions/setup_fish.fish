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

    set -Ux RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/config"

    # Mise
    set -Ux MISE_FISH_AUTO_ACTIVATE 0

    # Node.js
    set -Ux BABEL_CACHE_PATH "$XDG_CACHE_HOME/babel.json"
    set -Ux NODE_REPL_HISTORY "$XDG_CACHE_HOME/node/repl_history"
    set -Ux NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
    set -Ux NPM_CONFIG_FUND false
    set -Ux NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"

    # Elm
    set -Ux ELM_HOME "$XDG_CACHE_HOME/elm"

    # Elixir/Erlang
    set -Ux MIX_XDG true
    mdkir -p "$XDG_CONFIG_HOME/erlang"
    touch "$XDG_CONFIG_HOME/erlang/.erlang.cookie"

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

    # Caching setting up tools
    set -l init_file "$XDG_CONFIG_HOME/fish/conf.d/inits_cached.fish"
    set -l comp_file "$XDG_CONFIG_HOME/fish/completions/completions_cached.fish"
    mkdir -p (dirname $init_file) (dirname $comp_file)

    # Overwrite inits
    zoxide init fish --no-cmd > $init_file
    mise activate fish --no-hook-env >> $init_file

    # Overwrite completions
    mise complete -s fish > $comp_file
    op completion fish >> $comp_file

    # Rebuild fish’s completion db
    fish_update_completions
end
