# Universal variables baked into a read-only fish_variables by nix/home/fish.nix.
# Usage: fish fish-variables.fish <home directory>
# EDITOR, VISUAL, XDG_CONFIG_DIRS, XDG_DATA_DIRS
# and, on brainbook, CLAUDE_CONFIG_DIR come from nix-darwin instead.
set -l home $argv[1]

# Block ads and other analytics
set -Ux ADBLOCK true
set -Ux DISABLE_OPENCOLLECTIVE true
set -Ux DO_NOT_TRACK true # https://consoledonottrack.com/
set -Ux GH_TELEMETRY false # Github CLI

# Locale
set -Ux LANG en_US.UTF-8
set -Ux LC_CTYPE en_US.UTF-8

# Homebrew
set -Ux HOMEBREW_NO_ANALYTICS 1
set -Ux HOMEBREW_NO_AUTO_UPDATE 1
set -Ux HOMEBREW_NO_EMOJI 1
set -Ux HOMEBREW_NO_ENV_HINTS 1
set -Ux HOMEBREW_PREFIX /opt/homebrew
set -Ux HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"

# https://0x46.net/thoughts/2019/02/01/dotfile-madness/
set -Ux XDG_CONFIG_HOME "$home/.config"
set -Ux XDG_CACHE_HOME "$home/.cache"
set -Ux XDG_DATA_HOME "$home/.local/share"
set -Ux XDG_STATE_HOME "$home/.local/state"

# Set XDG for tools
# Less
set -Ux LESSHISTFILE "$XDG_CACHE_HOME/less/history"
set -Ux LESSKEY "$XDG_CONFIG_HOME/less/keys"

set -Ux RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/config"

# Node.js
set -Ux BABEL_CACHE_PATH "$XDG_CACHE_HOME/babel.json"
set -Ux NODE_REPL_HISTORY "$XDG_CACHE_HOME/node/repl_history"
set -Ux NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set -Ux NPM_CONFIG_FUND false

# Elm
set -Ux ELM_HOME "$XDG_CACHE_HOME/elm"

# Rust
set -Ux CARGO_HOME "$XDG_DATA_HOME/cargo"

# Docker
set -Ux DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"

# Gradle
set -Ux GRADLE_USER_HOME "$XDG_DATA_HOME/gradle"

# Shared agent skills, linked by terminal-browser
set -Ux AGENT_SKILLS_HOME "$XDG_CONFIG_HOME/agents/skills"

# Gitleaks
set -Ux GITLEAKS_CONFIG "$XDG_CONFIG_HOME/gitleaks/config.toml"

# fish_add_path skips directories that don't exist at build time
set -U fish_user_paths "$HOMEBREW_PREFIX/sbin" "$HOMEBREW_PREFIX/bin"

# Fish
set -U fish_greeting
echo y | fish_config theme save ayu --color-theme=dark >/dev/null
