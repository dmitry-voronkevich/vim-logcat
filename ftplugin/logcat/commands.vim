let s:LogcatTimeRegex = '\d\d-\d\d \d\d:\d\d:\d\d\.\d\d\d'
let s:LogcatLevelRegex = '[VDIWEF]'

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
  let tag=matchstr(line, '\v\d+\s+'.s:LogcatLevelRegex.'\s+\zs[^:]+')
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
  let @/ = '\v\d+\s+' . s:LogcatLevelRegex . '\s+\zs' . tag . '\s*:'
  execute 'normal ' . a:direction . "\<cr>" 
endfunction
" end of support functions for LogcatFindTag }}}
" end of command LogcatFindTag }}}


" Command: LogcatFindPid name {{{
command -nargs=? LogcatFindPid call LogcatFindPid('/', <f-args>)
command -nargs=? LogcatReverseFindPid call LogcatFindPid('?', <f-args>)


function LogcatFindPid(direction, ...)
  if a:0 == 0
    let pid=LogcatGetPidInCurrentLine()
  else
    let pid=a:1
  endif
  let @/ = '\v^' . s:LogcatTimeRegex . ' \zs'.pid.'\ze \d+'
  execute 'normal ' . a:direction . "\<cr>" 
endfunction

function LogcatGetPidInCurrentLine()
  let line=getline('.')
  let pid=matchstr(line, '\v^'.s:LogcatTimeRegex.' \zs\d+')
  return pid
endfunction
" }}}

" Command: LogcatFindTid name {{{
command -nargs=? LogcatFindTid call LogcatFindTid('/', <f-args>)
command -nargs=? LogcatReverseFindTid call LogcatFindTid('?', <f-args>)

function LogcatFindTid(direction, ...)
  if a:0 == 0
    let tid=LogcatGetTidInCurrentLine()
  else
    let tid=a:1
  endif
  let @/ = '\v^' . s:LogcatTimeRegex . ' \d+ \zs' . tid . '\ze '
  execute 'normal ' . a:direction . "\<cr>"
endfunction

function LogcatGetTidInCurrentLine()
  let line=getline('.')
  let tid=matchstr(line, '\v^'.s:LogcatTimeRegex.' \d+ \zs\d+')
  return tid
endfunction
" }}}

" Command: LogcatHighlight phrase {{{
command -nargs=1 LogcatHighlight call LogcatHighlight(<f-args>)
command -nargs=0 LogcatLsHighlights call LogcatListHighlights()
command -nargs=1 LogcatFindHighlight call LogcatFindHighlight('/', <f-args>)
command -nargs=1 LogcatReverseFindHighlight call LogcatFindHighlight('/', <f-args>)


function LogcatHighlight(phrase)
  let id = LogcatDefineHighlight(a:phrase)
  echo id . ' -> ' . a:phrase
endfunction

function LogcatFindHighlight(direction, id)
  let phrase = LogcatGetHighlightById(a:id)
  if len(phrase) == 0
    echoerr 'Unknown highlight id ' . a:id . '. Use LogcatLsHighlights'
  else
    let regex = '\v' . s:LogcatTimeRegex . '(\s+\d+){2}\s+' . s:LogcatLevelRegex . '\s+[^:]*:.*\zs' . phrase
    let @/ = regex
    execute "normal " . a:direction . "\<cr>"
  endif
endfunction

" }}}

" vim: foldmethod=marker

