if not status is-interactive
  exit
end

function __load_mise_on_first_command --on-event fish_preexec
    functions -e __load_mise_on_first_command
    load_mise
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
abbr -a gsm 'git switch main 2>/dev/null || git switch master'
abbr -a gws git status

# Miscellaneous
abbr -a l 'eza --group-directories-first -lahg --no-user'
abbr -a t 'eza -T -L 3'
abbr -a mkdir mkdir -p
abbr -a ... 'cd ../../'

abbr -a mine 'sudo chown -R $(whoami):admin'
