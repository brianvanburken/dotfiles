let g:syntastic_check_on_open = 1
let g:syntastic_aggregate_errors = 1

let g:syntastic_html_checkers=['']
let g:syntastic_ruby_checkers = ['mri', 'rubocop']

" Path to jshint if it not installed globally, then use local installation
if !executable("jshint")
  if executable("npm") && !executable('jshint')
    silent ! echo 'Installing jshint' && npm install -g jshint
  endif
  let g:syntastic_javascript_checkers = ['jshint']
endif

" Path to csslint if it not installed globally, then use local installation
if !executable("csslint")
  if executable("npm") && !executable('csslint')
    silent ! echo 'Installing csslint' && npm install -g csslint
  endif
endif
