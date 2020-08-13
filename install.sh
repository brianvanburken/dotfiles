fancy_echo() {
  local fmt="$1"; shift
  printf "\n$fmt\n" "$@"
}

DOT_DIR=$HOME/Developer/personal/dotfiles
PLUG_DIR=$XDG_DATA_HOME:=$HOME/.local/share

fancy_echo "Creating local directories"
mkdir -p $HOME/Developer/personal
mkdir -p $HOME/.shell/
mkdir -p $HOME/.config/
mkdir -p $HOME/.cache/
mkdir -p $HOME/.local/share/

fancy_echo "Creating local files"
touch $HOME/.gitconfig.local
touch $HOME/.hushlogin

if [ ! -d $DOT_DIR ]; then
    fancy_echo "Cloning dotfiles"
    git clone https://github.com/brianvanburken/dotfiles.git $DOT_DIR
    cd $DOT_DIR
    git remote remove origin
    git remote add origin git@github.com:brianvanburken/dotfiles.git
else
    fancy_echo "Dotfiles already present"
    cd $DOT_DIR
fi

which -s brew
if [[ $? != 0 ]] ; then
	fancy_echo "Installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew doctor
	fancy_echo "Homebrew is installed"
    fancy_echo "Installing Homebrew packages"
    brew bundle
else
	fancy_echo "Homebrew already installed"
    brew update
fi

if [ ! -d $PLUG_DIR ]; then
    fancy_echo "Installing vim plugins"
    NVIM_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/nvim
    curl -fLo $NVIM_DIR/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim +PlugInstall +qall
fi

fancy_echo "Linking dotfiles in $HOME to $DOT_DIR"
files=(
"config/ag/ignore"
"config/asdf"
"config/git"
"config/nvim"
"config/zsh"
"default-npm-packages"
"default-python-packages"
"editorconfig"
"hushlogin"
"ideavimrc"
"zshenv"
)

for x in "${files[@]}"; do
	fancy_echo "Linking $x"
	rm -rf $HOME/.$x
	ln -s $DOT_DIR/$x $HOME/.$x
done

rm $HOME/.agignore
ln -s $DOT_DIR/config/ag/ignore $HOME/.agignore

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


echo "Install MiniConda"
MINICONDA_PATH="$XDG_DATA_HOME/miniconda"

if [ ! -d "$MINICONDA_PATH" ]; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
    chmod +x ./Miniconda3-latest-MacOSX-x86_64.sh
    ./Miniconda3-latest-MacOSX-x86_64.sh -b -p "$MINICONDA_PATH"
    rm ./Miniconda3-latest-MacOSX-x86_64.sh
fi

# now we activate miniconda
export PATH="$MINICONDA_PATH/bin:$PATH"

# and install pip in base conda env
conda install pip -y

fancy_echo "Done running script"
