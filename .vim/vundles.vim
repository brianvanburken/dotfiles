" Delegate plugin management to Vundle
" disable filetypes (required)
filetype off

set rtp+=~/.vim/bundle/vundle/

call vundle#begin()

" Languages
Plugin 'othree/html5.vim'
Plugin 'hail2u/vim-css3-syntax'

Plugin 'slim-template/vim-slim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'

Plugin 'dsawardekar/ember.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'kchmck/vim-coffee-script'
Plugin 'moll/vim-node'

" Completion
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'ervandew/supertab'
Plugin 'Townk/vim-autoclose'

" Code Display
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plugin 'ap/vim-css-color'
Plugin 'kien/rainbow_parentheses.vim'

" Intergrations
Plugin 'scrooloose/syntastic'
Plugin 'airblade/vim-gitgutter'
Plugin 'ntpeters/vim-better-whitespace'

" Interface
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'

" Commands
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'

" Other
Bundle 'gmarik/vundle'

call vundle#end()


" Re-enable filtypes (required)
filetype plugin indent on
