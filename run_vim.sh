#! /bin/bash
pwd=$(pwd)
vim -Nu <(cat << EOF
call plug#begin()
syntax on
Plug '$pwd'
call plug#end()
set statusline=%<%f\ %h%m%r%=%\{synIDattr(synID(line('.'),col('.'),1),'name')}
set laststatus=2
EOF) "$*"
