set termencoding=utf-8
set cursorline
set encoding=utf-8      " Set default encoding to UTF-8
set showmatch           " Show matching brackets/parenthesis
syntax enable indent on " Turn on syntax highlighting
set colorcolumn=80

set background=dark
colorscheme base16-ocean

if has('gui_running')
  " hide toolbar
  set guioptions-=T

  " hide the right hand vertical scrollbar
  set guioptions-=r

  " hide the left hand vertical scrollbar
  set guioptions-=l
  set guioptions-=L
  set guifont=Menlo\ for\ Powerline:h11
end
