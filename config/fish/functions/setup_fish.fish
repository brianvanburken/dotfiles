function setup_fish -d "Setup local files for Fish"
    # Universal variables come from nix/home/fish-variables.fish

    mkdir -p "$XDG_CONFIG_HOME/erlang"
    touch "$XDG_CONFIG_HOME/erlang/.erlang.cookie"

    # Caching setting up tools
    set -l comp_file "$XDG_CONFIG_HOME/fish/completions/completions_cached.fish"
    mkdir -p (dirname $comp_file)

    # Overwrite completions
    mise complete -s fish > $comp_file

    # Rebuild fish’s completion db
    fish_update_completions
end
