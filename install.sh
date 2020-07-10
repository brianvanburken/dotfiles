fancy_echo() {
  local fmt="$1"; shift
  printf "\n$fmt\n" "$@"
}

# Install homebrew if not exists
which -s brew
if [[ $? != 0 ]] ; then
	fancy_echo "Installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	brew doctor
	brew update
	fancy_echo "Homebrew is installed"
else
	fancy_echo "Homebrew already installed"
fi

fancy_echo "Installing Homebrew packages"
brew bundle

fancy_echo "Creating local directories"
mkdir -p ~/Developer/
mkdir -p ~/.shell/
mkdir -p ~/.config/

fancy_echo "Creating local files"
touch ~/.gitconfig.local
touch ~/.hushlogin

DOT_DIR=$(pwd)

fancy_echo "Linking dotfiles in $HOME to $DOT_DIR"
files=(
"agignore"
"aliases"
"asdfrc"
"bundle"
"config/nvim"
"default-gems"
"default-npm-packages"
"default-python-packages"
"editorconfig"
"gemrc"
"gitattributes"
"gitconfig"
"gitignore"
"ideavimrc"
"tmux.conf"
"tool-versions"
"zsh_functions"
"zshrc"
)

for x in "${files[@]}"; do
	fancy_echo "Linking $x"
	rm -rf $HOME/.$x
	ln -s $DOT_DIR/$x $HOME/.$x
done

fancy_echo "Adding asdf plugins"
asdf plugin-add ruby
asdf plugin-add nodejs
asdf plugin-add elm
asdf plugin-add erlang
asdf plugin-add elixir
asdf plugin-add python
asdf plugin-add haskell
asdf plugin-add java
asdf plugin-add kotlin

fancy_echo "Installing asdf versions"
cd ~
asdf install
cd -

fancy_echo "Done running script"
