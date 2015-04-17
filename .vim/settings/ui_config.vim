set relativenumber  " Show the cursor position all the time
set number          " Show line numers
set numberwidth=2   " Line numbers max to two digits
set showcmd         " show command in bottom bar
set cursorline      " highlight current line
filetype indent on  " load filetype-specific indent files
set lazyredraw          " redraw only when we need to.
" Vim loves to redraw the screen during things it probably doesn't need to—like
" in the middle of macros. This tells Vim not to bother redrawing during these
" scenarios, leading to faster macros.
set showmatch        " highlight matching [{()}]
set laststatus=2     " Always show the statusbar

autocmd FocusLost * :set number
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

set clipboard=unnamed " Share Clipboard with OS

set so=7 " Set 7 lines to the cursor - when moving vertically using j/
