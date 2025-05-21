if not status is-interactive
  exit
end

# Lazy-load mise as I don't always need it to be active
# only on dirs that have mise files (.mise.toml/.tool-versions)
function lazy_load_mise --on-variable PWD
    # Exit early if already activated
    if set -q __mise_activated
        return
    end

    # Test for .mise.toml or .tool-versions
    if test -f .mise.toml; or test -f .tool-versions
        echo "Activating mise"
        mise activate fish | source
        set -g __mise_activated 1
    end
end
