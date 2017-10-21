[[ -r $HOME/.zim/init.zsh     ]] && source $HOME/.zim/init.zsh
[[ -r $HOME/.profile          ]] && source $HOME/.profile
[[ -r $HOME/.bash_aliases     ]] && source $HOME/.bash_aliases
[[ -r $HOME/.zsh_functions    ]] && source $HOME/.zsh_functions
[[ -r $HOME/.shell_local      ]] && source $HOME/.shell_local
[[ -r $(brew --prefix)/opt/asdf/asdf.sh ]] && source $(brew --prefix)/opt/asdf/asdf.sh
[[ -f $(brew --prefix)/etc/profile.d/z.sh ]] && source $(brew --prefix)/etc/profile.d/z.sh

if typeset -f fzf > /dev/null && typeset -f ag > /dev/null; then
  export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='
  --color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
  --color info:108,prompt:109,spinner:108,pointer:168,marker:168
  '
fi
