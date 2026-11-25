# Dotfiles

## Install

On a freshly wiped Mac (Apple Silicon):

`zsh -c "$(curl -fsSL https://raw.githubusercontent.com/brianvanburken/dotfiles/main/setup/install-macos.sh)"`

## Apply changes

From the repository root:

`sudo darwin-rebuild switch --flake .`
