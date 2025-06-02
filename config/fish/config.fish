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
    if test -f mise.toml; test -f .mise.toml; or test -f .tool-versions
        echo "Activating mise"
        mise activate fish | source
        set -g __mise_activated 1
    end
end
# Try when loading the shell
lazy_load_mise

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
abbr -a ls 'eza --color=auto'
abbr -a l 'eza --color=auto --group-directories-first  -lahg --no-user'
abbr -a t 'eza -T -L 3'
abbr -a mkdir mkdir -p
abbr -a ... 'cd ../../'

abbr -a kill_ds 'fd -I -H ".DS_Store" -tf -X rm -rf'
abbr -a backup 'rsync --exclude-from="$XDG_CONFIG_HOME/rsync/excludes.txt" -arv --progress'

abbr -a mine 'sudo chown -R $(whoami):admin'
