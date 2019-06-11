[[ -r $HOME/.profile      ]] && source $HOME/.profile
[[ -r $HOME/.aliases      ]] && source $HOME/.aliases
[[ -r $HOME/.asdf/asdf.sh ]] && source $HOME/.asdf/asdf.sh

eval "$(direnv hook bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
