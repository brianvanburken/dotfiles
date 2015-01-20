set termencoding=utf-8
set cursorline
set encoding=utf-8      " Set default encoding to UTF-8
set showmatch           " Show matching brackets/parenthesis
syntax enable indent on " Turn on syntax highlighting
set colorcolumn=80

if &term == 'xterm' || &term == 'screen'
  set t_Co=256
  set t_AB=^[[48;5;%dm
  set t_AF=^[[38;5;%dm
  let base16colorspace=256 " Access colors present in 256 colorspace
  set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
endif

set background=dark
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

colorscheme base16-ocean
