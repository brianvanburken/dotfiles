[[ -r $HOME/.zim/init.zsh     ]] && source $HOME/.zim/init.zsh
[[ -r $HOME/.profile          ]] && source $HOME/.profile
[[ -r $HOME/.bash_aliases     ]] && source $HOME/.bash_aliases
[[ -r $HOME/.asdf/asdf.sh     ]] && source $HOME/.asdf/asdf.sh
[[ -r $HOME/.zsh_functions    ]] && source $HOME/.zsh_functions
[[ -r $HOME/.shell_local      ]] && source $HOME/.shell_local
[[ -f $(brew --prefix)/etc/profile.d/z.sh ]] && source $(brew --prefix)/etc/profile.d/z.sh
