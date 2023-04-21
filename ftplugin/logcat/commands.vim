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

" vim: foldmethod=marker
