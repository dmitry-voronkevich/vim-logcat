function! s:MatchBlock()
  let line=getline('.')
  if stridx(line, '<--') >= 0
    let dir='?'
    let match='-->' . line[stridx(line, '<--')+3:]
  elseif stridx(line, "-->") >= 0
    let dir='/'
    let match='<--' . line[stridx(line, '-->')+3:]
  else
    let dir='/'
    let match='<--\|-->'
  endif
  execute 'silent normal! ' . dir . match . "\r"
endfunction

noremap <script> <buffer> <silent> % :call <SID>MatchBlock()<cr>
noremap <script> <buffer> <silent> [[ <nop>
noremap <script> <buffer> <silent> ]] <nop>
noremap <script> <buffer> <silent> [] <nop>
noremap <script> <buffer> <silent> ][ <nop>
