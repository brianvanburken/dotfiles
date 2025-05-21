# Shortkeys to make live easier

# NPM
abbr -a ncc npm cache clear --force
abbr -a nci npm ci
abbr -a nig npm install --global

# NeoVim/Vim/VSCode
abbr -a vi nvim
abbr -a vim nvim
abbr -a vscode nvim
abbr -a code nvim
abbr -a e nvim

# Git
abbr -a g git
abbr -a ga git add
abbr -a gam git commit --amend
abbr -a gap git add --patch
abbr -a gbr 'git branch --merged | rg -v "master|main|^\*" | xargs git branch -D'
abbr -a gbra 'git branch | rg -v "master|main|^\*" | xargs git branch -D'
abbr -a gcm git commit -m
abbr -a gl git log
abbr -a gp git push
abbr -a gpf git push --force-with-lease
abbr -a gpl git pull --rebase
abbr -a gs git switch
abbr -a gsc git switch -c
abbr -a gsm 'git switch main 2>/dev/null | git switch master'
abbr -a gws git status

abbr -a fix 'git diff --name-only | uniq | xargs -o $EDITOR'

# Miscellaneous
abbr -a ls 'eza --color=auto'
abbr -a l 'eza --color=auto --group-directories-first  -lahg --no-user'
abbr -a t 'eza -T -L 3'
abbr -a mkdir mkdir -p
abbr -a asdf mise
abbr -a rtx mise

abbr -a kill_ds 'fd -I -H ".DS_Store" -tf -X rm -rf'
abbr -a kill_modules 'fd "node_modules" -td -X rm -rf'
abbr -a backup 'rsync --exclude-from="$XDG_CONFIG_HOME/rsync/excludes.txt" -arv --progress'

abbr -a mine 'sudo chown -R $(whoami):admin'
