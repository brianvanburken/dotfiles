export CC=gcc
export EDITOR='vim'
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export CLICOLOR=1
export TERM="xterm-256color"

# Improve Ruby GC
export RUBY_GC_HEAP_INIT_SLOTS=2000000
export RUBY_HEAP_SLOTS_INCREMENT=500000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=70000000
export RUBY_GC_HEAP_FREE_SLOTS=100000
