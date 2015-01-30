" Markdown
autocmd! BufRead *.mkd set ai formatoptions=tcroqn2 comments=n:> ft=markdown
autocmd! BufRead *.md set ai formatoptions=tcroqn2 comments=n:> ft=markdown
autocmd! BufRead *.mdown set ai formatoptions=tcroqn2 comments=n:> ft=markdown
autocmd! BufRead *.markdown set ai formatoptions=tcroqn2 comments=n:> ft=markdown
autocmd BufRead,BufNewFile *.es6 setfiletype javascript

" CSS3
au BufRead,BufNewFile *.scss set filetype=scss
au BufRead,BufNewFile *.css set ft=css syntax=css

" HTML5
au BufRead,BufNewFile *.html set ft=html syntax=html
au BufRead,BufNewFile *.hbs set ft=html syntax=html
au BufRead,BufNewFile *.mustache set ft=html syntax=html
au BufRead,BufNewFile *.haml set ft=haml

au BufRead,BufNewFile *.js set ft=javascript syntax=javascript
au BufRead,BufNewfile *.rb set ft=ruby syntax=ruby
