" Automatic removal of trailing whitespaces
autocmd FileType * autocmd BufWritePre <buffer> StripWhitespace

set nowrap                          " Set no line wrap
set expandtab                       " Use spaces not tabs
set tabstop=2                       " A tab is two space
set softtabstop=2                   " Number of spaces in tab when editing
set shiftwidth=2                    " An autoindent (with <<) is two space
set listchars=tab:»·,trail:·,eol:¬  " Display extra whitespace
set list                            " Always display whitespace
