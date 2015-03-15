if !executable("csscomb")
  if executable("npm") && !executable('csscomb')
    silent ! echo 'Installing csscomb' && npm install -g csscomb
  endif
endif

set autoread " Automatically reload files
autocmd BufWritePost *.css,*.scss silent exec '!csscomb %' | redraw
