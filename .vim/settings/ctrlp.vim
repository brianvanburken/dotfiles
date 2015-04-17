if exists("g:ctrlp_user_command")
  unlet g:ctrlp_user_command
endif

let g:ctrlp_use_caching = 0
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/](\.(git|hg|svn|bundle)|coverage|dist|tmp|log|bower_components|vendor|node_modules)$',
      \ 'file': '\v\.(swp|zip|DS_Store|jira-url|png|jpg|jpeg|svg|gif|eot|ttf|woff)$'
      \ }
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']

nnoremap <Leader>o :CtrlP<CR>

let g:ctrlp_buffer_func = {
    \ 'enter': 'DisableStatusLine',
    \ 'exit':  'EnableStatusLine',
    \ }

func! DisableStatusLine()
    set laststatus=0
endfunc

func! EnableStatusLine()
    set laststatus=2
endfunc
