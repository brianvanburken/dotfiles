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
    if test -f mise.toml; or test -f .mise.toml; or test -f .tool-versions
        echo "Activating mise"
        mise activate fish | source
        set -g __mise_activated 1
    end
end

# Try when loading the shell
lazy_load_mise

# Changes theme based on dark/light mode
## enable unsolicited
printf '\e[?2031h'

## bind dark/light DSRs
bind \e\[?997\;1n on_theme_dark
bind \e\[?997\;2n on_theme_light

function on_theme_dark
    yes | fish_config theme save "Mono Smoke"
end

function on_theme_light
    yes | fish_config theme save "Mono Lace"
end

function init_theme --on-event fish_prompt
    functions -e init_theme  # unregister ourselves so it only runs once
    # `defaults read -g AppleInterfaceStyle` returns “Dark” in dark mode,
    # errors out in light mode
    if defaults read -g AppleInterfaceStyle 2>/dev/null | rg -q '^Dark$'
      on_theme_dark
    else
      on_theme_light
    end
end

# Shortkeys to make live easier

# NeoVim/Vim/VSCode
abbr -a e nvim

# Git
abbr -a g git
abbr -a ga git add
abbr -a gam git commit --amend
abbr -a gap git add --patch
abbr -a gcm git commit -m
abbr -a gl git log
abbr -a gp git push
abbr -a gpf git push --force-with-lease
abbr -a gpl git pull --rebase
abbr -a gs git switch
abbr -a gsc git switch -c
abbr -a gsm 'git switch main 2>/dev/null | git switch master'
abbr -a gws git status

# Miscellaneous
abbr -a l 'eza --group-directories-first -lahg --no-user'
abbr -a t 'eza -T -L 3'
abbr -a mkdir mkdir -p
abbr -a ... 'cd ../../'

abbr -a kill_ds 'fd -I -H ".DS_Store" -tf -X rm -rf'
abbr -a backup 'rsync --exclude-from="$XDG_CONFIG_HOME/rsync/excludes.txt" -arv --progress'

abbr -a mine 'sudo chown -R $(whoami):admin'
