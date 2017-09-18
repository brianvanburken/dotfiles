[[ -r $HOME/.zim/init.zsh     ]] && source $HOME/.zim/init.zsh
[[ -r $HOME/.profile          ]] && source $HOME/.profile
[[ -r $HOME/.bash_aliases     ]] && source $HOME/.bash_aliases
[[ -r $HOME/.zsh_functions    ]] && source $HOME/.zsh_functions
[[ -r $HOME/.shell_local      ]] && source $HOME/.shell_local
[[ -r $(brew --prefix)/opt/asdf/asdf.sh ]] && source $(brew --prefix)/opt/asdf/asdf.sh
[[ -f $(brew --prefix)/etc/profile.d/z.sh ]] && source $(brew --prefix)/etc/profile.d/z.sh
