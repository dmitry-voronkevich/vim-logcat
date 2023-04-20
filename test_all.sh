#!  /bin/bash
pwd=$(pwd)
vim -Nu <(cat << EOF
filetype off
call plug#begin()
Plug 'junegunn/vader.vim'
Plug 'preservim/vim-markdown'
Plug '$pwd'
call plug#end()
filetype plugin indent on
syntax enable
EOF) +Vader*
