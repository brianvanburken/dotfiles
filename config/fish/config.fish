if not status is-interactive
  exit
end

# Lazy-load mise as I don't always need it to be active
# only on dirs that have mise files (.mise.toml/.tool-versions)
function lazy_load_mise --on-variable PWD
    # Test for .mise.toml or .tool-versions in current dir or one up
    if test -f mise.toml; or test -f .tool-versions;
      or test -f ../mise.toml; or test -f ../.tool-versions
          mise activate fish | source
          functions -e lazy_load_mise
    end
end

# Try when loading the shell
lazy_load_mise

# Lazy-load FZF key bindings on first prompt
# This defers the 200+ line FZF setup until after shell is interactive
function lazy_load_fzf --on-event fish_prompt
    if functions -q fzf_key_bindings
        fzf_key_bindings
        functions -e lazy_load_fzf
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

abbr -a backup 'rsync --exclude-from="$XDG_CONFIG_HOME/rsync/excludes.txt" -arv --progress'

abbr -a mine 'sudo chown -R $(whoami):admin'
