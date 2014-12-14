set ruler           " Show the cursor position all the time
set numberwidth=2   " Line numbers max to two digits

" Relative linenumbers
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

autocmd FocusLost * :set number
autocmd InsertEnter * :set number
autocmd FocusGained * :set relativenumber
autocmd InsertLeave * :set relativenumber
