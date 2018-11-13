[[ -r $HOME/.zim/init.zsh  ]] && source $HOME/.zim/init.zsh
[[ -r $HOME/.profile       ]] && source $HOME/.profile
[[ -r $HOME/.aliases       ]] && source $HOME/.aliases
[[ -r $HOME/.asdf/asdf.sh  ]] && source $HOME/.asdf/asdf.sh
[[ -r $HOME/.zsh_functions ]] && source $HOME/.zsh_functions

source $(brew --prefix)/etc/profile.d/z.sh

eval "$(direnv hook zsh)"
