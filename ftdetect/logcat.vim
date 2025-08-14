autocmd BufNewFile,BufRead *.logcat set filetype=logcat
autocmd Syntax logcat call logcat#state#read()
