source ~/.profile
source ~/.bashrc
source ~/.bash_aliases

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
