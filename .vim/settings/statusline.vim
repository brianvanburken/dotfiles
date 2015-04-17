" Mode Indication
" Returns mode and sets color based on mode
function! SetStatusLineColor()
  if mode() == 'i' " Insert
    hi statusline ctermfg=green
    return "INSERT"
  elseif mode() == 'R' " Replace
    hi statusline ctermfg=red
    return "REPLACE"
  elseif mode() == 'v' " Visual
    hi statusline ctermfg=yellow
    return "VISUAL"
  elseif mode() == 'V' " Visual [line]
    hi statusline ctermfg=yellow
    return "VISUAL LINE"
  elseif mode() == '^V' " Visual [block]
    hi statusline ctermfg=yellow
    return "VISUAL BLOCK"
  endif
  hi statusline ctermfg=darkgray
  return 'NORMAL'
endfunction

set laststatus=2 "always enable status line

set statusline=[%{SetStatusLineColor()}]
set statusline+=\       "seperator
set statusline+=%t       "tail of the filename
set statusline+=\       "seperator
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag

set statusline+=%=      "left/right separator
set statusline+=%h      "help file flag
set statusline+=\       "seperator
set statusline+=[%{strlen(&fenc)?&fenc:'none'}] "file encoding
set statusline+=\       "seperator
" set statusline+=%y      "filetype
" set statusline+=\       "seperator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
