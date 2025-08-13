" Hide/Unhide functionality
setlocal conceallevel=2
setlocal concealcursor=n

" highlight tag
nnoremap <buffer> <leader>t :LogcatHighlightTag<cr>
nnoremap <buffer> <leader>T :LogcatUnHighlightTag<cr>
" find custom highlighted text
nnoremap <buffer> <leader>h1 :LogcatFindHighlight 1<cr>
nnoremap <buffer> <leader>h2 :LogcatFindHighlight 2<cr>
nnoremap <buffer> <leader>h3 :LogcatFindHighlight 3<cr>
nnoremap <buffer> <leader>h4 :LogcatFindHighlight 4<cr>
nnoremap <buffer> <leader>h5 :LogcatFindHighlight 5<cr>
nnoremap <buffer> <leader>h6 :LogcatFindHighlight 6<cr>
nnoremap <buffer> <leader>h7 :LogcatFindHighlight 7<cr>
nnoremap <buffer> <leader>h8 :LogcatFindHighlight 8<cr>
nnoremap <buffer> <leader>h9 :LogcatFindHighlight 9<cr>

nnoremap <buffer> <leader>H1 :LogcatReverseFindHighlight 1<cr>
nnoremap <buffer> <leader>H2 :LogcatReverseFindHighlight 2<cr>
nnoremap <buffer> <leader>H3 :LogcatReverseFindHighlight 3<cr>
nnoremap <buffer> <leader>H4 :LogcatReverseFindHighlight 4<cr>
nnoremap <buffer> <leader>H5 :LogcatReverseFindHighlight 5<cr>
nnoremap <buffer> <leader>H6 :LogcatReverseFindHighlight 6<cr>
nnoremap <buffer> <leader>H7 :LogcatReverseFindHighlight 7<cr>
nnoremap <buffer> <leader>H8 :LogcatReverseFindHighlight 8<cr>
nnoremap <buffer> <leader>H9 :LogcatReverseFindHighlight 9<cr>

