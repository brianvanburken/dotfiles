if exists("g:ctrl_user_command")
  unlet g:ctrlp_user_command
endif

let g:ctrlp_use_caching = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn|bundle)|coverage|dist|tmp|log|bower_components|vendor|node_modules)$',
  \ 'file': '\v\.(swp|zip|DS_Store|jira-url|png|jpg|jpeg|svg|gif|eot|ttf|woff)$'
  \ }
