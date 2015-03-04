if exists("g:ctrlp_user_command")
  unlet g:ctrlp_user_command
endif

if executable('ag') " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -i -l --nogroup --nocolor --column -g ""'
  let g:ctrlp_use_caching = 0
else " Fall back to using git ls-files if Ag is not available
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](\.(git|hg|svn|bundle)|coverage|dist|tmp|log|bower_components|vendor|node_modules)$',
    \ 'file': '\v\.(swp|zip|DS_Store|jira-url|png|jpg|jpeg|svg|gif|eot|ttf|woff)$'
    \ }
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']
endif
