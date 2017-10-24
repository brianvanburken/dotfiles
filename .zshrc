[[ -r $HOME/.zim/init.zsh     ]] && source $HOME/.zim/init.zsh
[[ -r $HOME/.profile          ]] && source $HOME/.profile
[[ -r $HOME/.bash_aliases     ]] && source $HOME/.bash_aliases
[[ -r $HOME/.zsh_functions    ]] && source $HOME/.zsh_functions
[[ -r $HOME/.shell_local      ]] && source $HOME/.shell_local
[[ -r $(brew --prefix)/opt/asdf/asdf.sh ]] && source $(brew --prefix)/opt/asdf/asdf.sh
[[ -f $(brew --prefix)/etc/profile.d/z.sh ]] && source $(brew --prefix)/etc/profile.d/z.sh

# If FZF is installed and The Silver Searcher I configure fzf to use ag as the
# default command. This makes it faster in searching and also makes use of the
# .gitignore AND .agignore!
export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
