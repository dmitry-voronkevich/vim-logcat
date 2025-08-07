" Command: LogcatHide, LogcatShow, LogcatHideToggle time|tag {{{
" LogcatHide time|tag
command -nargs=1 -complete=custom,LogcatCompleteCommandHide LogcatHide call LogcatCommandHide(<f-args>)
" LogcatShow time|tag
command -nargs=1 -complete=custom,LogcatCompleteCommandHide LogcatShow call LogcatCommandShow(<f-args>)
" LogcatHideToggle time|tag
command -nargs=1 -complete=custom,LogcatCompleteCommandHide LogcatHideToggle call LogcatCommandShowToggle(<f-args>)
" LogcatShowToggle time|tag
cabbrev LogcatShowToggle LogcatHideToggle


" Support functions for -- LogcatHide | LogcatShow | LogcatShowToggle {{{
function LogcatCompleteCommandHide(A,L,P)
  return "tag\ntime"
endfunction

function LogcatCommandHide(what)
  if a:what == "time"
    let b:logcat_visibility_time=0
    call LogcatDefineHighlightTime("conceal")
  endif
endfunction

function LogcatCommandShow(what)
  if a:what == "time"
    let b:logcat_visibility_time=1
    call LogcatDefineHighlightTime("")
  endif
endfunction

function LogcatCommandShowToggle(what)
  if a:what == "time"
    if b:logcat_visibility_time == 0
      call LogcatCommandShow(a:what)
    else
      call LogcatCommandHide(a:what)
    endif
  endif
endfunction

let b:logcat_visibility_time=1

" end support for LogcatHide }}}

" end of command LogcatHide, LogcatShow, LogcatHideToggle  }}}

" Command: LogcatHighlightTag name {{{
command -nargs=? LogcatHighlightTag call LogcatHighlightTag(<f-args>)
" Support functions for LogcatHighlightTag {{{
function LogcatHighlightTag(...)
  if a:0 == 0
    " No tag supplied, getting tag in the line under cursor
    let tag=LogcatGetTagInCurrentLine()
  else
    let tag=a:1
  endif
  call LogcatDefineHighlightTag(tag)
endfunction

function LogcatGetTagInCurrentLine()
  let line=getline('.')
  let tag=matchstr(line, '\v\d+\s+[VDIWEF]\s+\zs[^:]+')
  return tag
endfunction
" end of support functions for LogcatHighlightTag }}}
" end of command LogcatHighlightTag }}}

" Command: LogcatUnHighlightTag name {{{
command -nargs=? LogcatUnHighlightTag call LogcatUnHighlightTag(<f-args>)

function LogcatUnHighlightTag(...)
  if a:0 == 0
    let tag=LogcatGetTagInCurrentLine()
  else
    let tag=a:1
  endif
  call LogcatUnDefineHighlightTag(tag)
endfunction
" end of command LogcatUnHighlightTag }}}

" Command: LogcatFindTag name {{{
command -nargs=? LogcatFindTag call LogcatFindTag('/', <f-args>)
command -nargs=? LogcatReverseFindTag call LogcatFindTag('?', <f-args>)
" Support function for LogcatFindTag {{{
function LogcatFindTag(direction, ...)
  if a:0 == 0
    let tag=LogcatGetTagInCurrentLine()
  else
    let tag=a:1
  endif
  execute a:direction . '\v\d+\s+[VDIWEF]\s+' . tag . '\s*\zs:'
endfunction
" end of support functions for LogcatFindTag
" end of command LogcatFindTag }}}

" vim: foldmethod=marker
