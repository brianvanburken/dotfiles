# This script is based on the script from Fabriquartz:
# https://github.com/Fabriquartz/laptop-install/blob/master/install.sh
fancy_echo() {
  local fmt="$1"; shift
  printf "\n$fmt\n" "$@"
}

fancy_echo "This script will setup your laptop"

# Get name and email
fancy_echo "Before we start we need some basic details of you"
read -p "What is your full name? (e.g. Johny Appleseed): " full_name
read -p "What is your email address? (e.g. johny.appleseed@fabriquartz.com): " email_address

fancy_echo "Hello $full_name <$email_address>"

fancy_echo "Install all AppStore Apps at first!"
fancy_echo "Press any key to start the installation process, press <CTRL + C> to cancel"
read

fancy_echo "We need your sudo password to do a few things"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


if ! command -v brew >/dev/null; then
  fancy_echo "Installing Brew"
  curl -fsS \
    'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
else
  fancy_echo "Updating Brew ..."
  brew update >> out.log
fi

fancy_echo "Installing Brew formulas!"

brew_install() {
  if brew list -1 | grep -Fqx "$1"; then
    if ! brew outdated --quiet "$1" >/dev/null; then
      printf "Upgrading %s ... \n" "$1"
      brew upgrade "$@" >> out.log 2>&1
    else
      printf "Already installed %s\n" "$1"
    fi
  else
    printf "Installing %s ...\n" "$1"
    brew install "$@" >> out.log 2>&1
  fi
}

brew_cask_install() {
  if brew cask list -1 | grep -Fqx "$1"; then
    printf "Already installed %s\n" "$1"
  else
    printf "Installing %s ...\n" "$1"
    brew cask install "$@" >> out.log 2>&1
  fi
}

brew_install 'git'
brew_install 'git-flow'
brew_install 'vim'
brew_install 'the_silver_searcher'
brew_install 'watchman'
brew_install 'node'
brew_install 'erlang'
brew_install 'elixir'
brew_install 'postgresql'
brew_install 'rabbitmq'
brew_install 'mongodb'
brew_install 'redis'
brew_install 'ctags'
brew_install 'rbenv'
brew_install 'ruby-build'
brew_install 'heroku-toolbelt'

brew_install 'openssl'
brew unlink openssl       >> out.log 2>&1
brew link openssl --force >> out.log 2>&1

fancy_echo "Updating misc Brew packages (if any)"
brew upgrade >> out.log 2>&1

fancy_echo "Cleaning up all the Brew spills"
brew cleanup >> out.log 2>&1
brew cask cleanup >> out.log 2>&1

fancy_echo "Symlinking dotfiles."
files=(.agignore .bash_aliases .bash_profile .bashrc .bundle .csscomb.json
        .gemrc .gitconfig .gitignore_global .hushlogin .powconfig .profile
        .slate .tmux.conf .vim .vimrc .zshrc)
dir="$PWD/"

for i in ${files[@]}; do
  sudo rm -rf ~/${i} && ln -s ${dir}${i} ~/${i}
done
fancy_echo "Done symlinking dotfiles."

npm_install() {
  printf "Installing %s ...\n" "$1"
  npm install -g "$@" >> out.log 2>&1
}

fancy_echo "Installing NPM packages"
npm_install 'npm'
npm_install 'bower'
npm_install 'phantomjs'
npm_install 'gulp'
npm_install 'npm-check-updates'

fancy_echo "Creating folder ~/Developer"
mkdir -p ~/Developer


if [ -f ~/.ssh/id_rsa ]
then
  fancy_echo "Skipping SSH key generation, you already have one"
else
  fancy_echo "Generating SSH key"
  ssh-keygen -q -t rsa -b 4096 -C "$email_address" -N "" -f ~/.ssh/id_rsa
fi

cat ~/.ssh/id_rsa.pub | pbcopy
fancy_echo "\nCopyied public key to clipboard, please add it to your Github account."

fancy_echo "Configuring name and email in .gitconfig"
git config --global user.name "$full_name"
git config --global user.email "$email_address"

fancy_echo "Installing vim plugins"
vim +PlugInstall +qall

fancy_echo "Changing system Bash to ZSH with oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

fancy_echo "Reloading shell"
exec $SHELL -l
