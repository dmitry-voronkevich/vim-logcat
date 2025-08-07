" Hide/Unhide functionality
setlocal conceallevel=2
setlocal concealcursor=n

" Defining mappings
nnoremap <buffer> gt :LogcatHighlightTag<cr>
nnoremap <buffer> GT :LogcatUnHighlightTag<cr>
nnoremap <buffer> t :LogcatFindTag<cr>
nnoremap <buffer> T :LogcatReverseFindTag<cr>
