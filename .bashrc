source $HOME/.profile
source $HOME/.bash_aliases
source $HOME/.asdf/asdf.sh

if [ -f $HOME/.shell_local ]
then
  source $HOME/.shell_local
fi
