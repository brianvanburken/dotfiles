# Shortkeys to make live easier

# NPM
abbr -a n npm
abbr -a n npm
abbr -a na npm audit
abbr -a nb npm run build
abbr -a ncc npm cache clear --force
abbr -a ni npm install
abbr -a nic npm ci
abbr -a nid npm install --save-dev
abbr -a nig npm install --global
abbr -a nis npm install --save
abbr -a no npm outdated
abbr -a nog npm outdated -g --depth=0
abbr -a nr npm run
abbr -a ns npm run start
abbr -a nt npm run test
abbr -a nx npx

# Yarn
abbr -a y yarn
abbr -a ya yarn audit
abbr -a yb yarn build
abbr -a ycc yarn cache clean
abbr -a yi yarn install
abbr -a yic yarn install --frozen-lockfile
abbr -a yid yarn add --dev
abbr -a yig yarn global
abbr -a yis yarn add
abbr -a yo yarn outdated
abbr -a yr yarn run
abbr -a ys yarn run start
abbr -a yt yarn test

# Cargo
abbr -a c cargo
abbr -a ca cargo audit
abbr -a cb cargo build --release
abbr -a cc cargo clean
abbr -a ci cargo install
abbr -a cis cargo add
abbr -a cr cargo run
abbr -a ct cargo test

# Mix
abbr -a m mix
abbr -a mt mix test

# NeoVim/Vim/VSCode
abbr -a code nvim
abbr -a v nvim 
abbr -a vi nvim
abbr -a vim nvim
abbr -a vscode nvim
abbr -a e nvim

# Tmux
abbr -a tm tmux
abbr -a tma tmux attach
abbr -a tmk tmux kill-session
abbr -a tml tmux ls

# Git
abbr -a g git
abbr -a ga git add
abbr -a gam git commit --amend
abbr -a gamn git commit --amend --no-edit
abbr -a gap git add --patch
abbr -a gb git branch
abbr -a gcm git commit -m
abbr -a gl git log
abbr -a gp git push
abbr -a gpf git push --force-with-lease
abbr -a gpl git pull --rebase
abbr -a gr git restore
abbr -a gs git switch
abbr -a gsc git switch -c
abbr -a gsd git switch develop
abbr -a gws git status

function fix; git diff --name-only | uniq | xargs -o $EDITOR $argv; end
function gsm; git switch main 2>/dev/null | git switch master $argv; end
function gbr; git branch --merged | rg -v "master|main|^\*" | xargs git branch -D $argv; end
function gbra; git branch | rg -v "master|main|^\*" | xargs git branch -D $argv; end

# Miscellaneous
abbr -a p pwd
abbr -a l ls -lahgG --color=auto
abbr -a t tree -L 3 
function mine; sudo chown -R $(whoami):admin $argv; end


abbr -a backup rsync --exclude-from="$XDG_CONFIG_HOME/rsync/excludes.txt" -avP