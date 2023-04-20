#! /bin/bash
pwd=$(pwd)
vim -Nu <(cat << EOF
call plug#begin()
syntax on
Plug '$pwd'
call plug#end()
EOF) "$*"
