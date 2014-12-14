" Automatic removal of trailing whitespaces
autocmd FileType * autocmd BufWritePre <buffer> StripWhitespace

set nowrap                          " Set no line wrap
set expandtab                       " Use spaces not tabs
set tabstop=2                       " A tab is two space
set shiftwidth=2                    " An autoindent (with <<) is two space
set backspace=indent,eol,start      " Backspace through everything in insert mode
set listchars=tab:»·,trail:·,eol:¬  " Display extra whitespace
set list                            " Always display whitespace
filetype plugin indent on           " Filetype specific indent
