export EDITOR="vim"
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export HOMEBREW_NO_ANALYTICS=1 # Disable homebrew analytics

# If FZF is installed and The Silver Searcher I configure fzf to use ag as the
# default command. This makes it faster in searching and also makes use of the
# .gitignore AND .agignore!
export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.asdf/shims"
export PATH="$PATH:$HOME/.shell"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

if [[ "$(uname -s)" == "Darwin" ]]; then
    val=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
    if [[ $val == "Dark" ]]; then
        echo -ne "\033]50;SetProfile=Dark\a"
        export ITERM_PROFILE="Dark"
    else
        echo -ne "\033]50;SetProfile=Light\a"
        export ITERM_PROFILE="Light"
    fi
fi
