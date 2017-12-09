fancy_echo() {
  local fmt="$1"; shift
  printf "\n$fmt\n" "$@"
}

fancy_echo "Before we start we need some basic details of you"
read -p "What is your full name? (e.g. Johny Appleseed): " full_name
read -p "What is your email address? (e.g. johny.appleseed@apple.com): " email_address

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Brew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  fancy_echo "Updating Brew ..."
  brew update
fi
brew bundle install

# TODO: recreate links for all dotfiles
# $HOME/.agignore
# $HOME/.bash_aliases
# $HOME/.bash_profile
# $HOME/.bashrc
# $HOME/.bundle
# $HOME/.ctags
# $HOME/.gemrc
# $HOME/.gitattributes
# $HOME/.gitconfig
# $HOME/.gitignore
# $HOME/.hammerspoon
# $HOME/.hushlogin
# $HOME/.profile
# $HOME/.rsync_exclude
# $HOME/.tool-versions
# $HOME/.vimrc
# $HOME/.zimrc
# $HOME/.zsh_functions
# $HOME/.zshrc

if [ -f ~/.ssh/id_rsa ]
then
  fancy_echo "Skipping SSH key generation, you already have one"
else
  fancy_echo "Generating SSH key"
  ssh-keygen -q -t rsa -b 4096 -C "$email_address" -N "" -f ~/.ssh/id_rsa
fi

fancy_echo "Creating folder ~/Developer"
mkdir -p ~/Developer

fancy_echo "Creating local .zshrc and .bashrc"
[[ ! -f $HOME/.zshrc.local ]] && touch $HOME/.zshrc.local
[[ ! -f $HOME/.bashrc.local ]] && touch $HOME/.bashrc.local

fancy_echo "Setting git configuration"
GCONF = <<EOT
GIT_AUTHOR_NAME="$full_name
GIT_AUTHOR_EMAIL="$email_address"
GIT_COMMITTER_NAME="\$GIT_AUTHOR_NAME"
GIT_COMMITTER_EMAIL="\$GIT_AUTHOR_EMAIL"
git config --global user.name \$GIT_AUTHOR_NAME
git config --global user.email \$GIT_AUTHOR_EMAIL
EOT
[[!grep -q GIT_AUTHOR_NAME "$HOME/.bashrc.local"]] && echo $GCONF > $HOME.bashrc.local
[[!grep -q GIT_AUTHOR_NAME "$HOME/.zshrc.local"]] && echo $GCONF > $HOME.zshrc.local

fancy_echo "Changing system Bash to ZSH using Zim"


[[!grep -q "/usr/local/bin/zsh" "/etc/shells"]] && sudo echo "/usr/local/bin/zsh" >> /etc/shells

if [[! -d "$HOME/.zim" ]]; then
  git clone --recursive git@github.com:zimfw/zimfw.git $HOME/.zim
  setopt EXTENDED_GLOB
  cp $HOME/.zim/templates/zlogin ~/.zlogin
  chsh -s /usr/local/bin/zsh
fi

fancy_echo "Installing latest NPM, Elm tools and other utilities."
npm install -g npm elm-live elm-format elm-test elm-oracle npm-check

fancy_echo "Installing vim plugins"
mkdir -p ~/.vim/
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

fancy_echo "Installing ASDF plugins"
asdf plugin-add ruby
asdf plugin-add node
asdf plugin-add elm
asdf plugin-add erlang
asdf plugin-add elixir
asdf install

fancy_echo "Done running script"
fancy_echo "Note that some of these changes require a logout/restart to take effect."
