if exists("b:current_syntax")
  finish
endif

function LogcatDefineHighlightTime(options)
  execute 'syntax match LogcatDate /\v^\d{1,2}-\d{1,2}/ ' . a:options
  execute 'syntax match LogcatTime /\v\d{1,2}:\d{1,2}:\d{1,2}\.\d{3}/ ' . a:options
endfunction

call LogcatDefineHighlightTime("")
syntax match LogcatPidAndTag /\v\d+-\d+\/\S+/ contains=LogcatPid
syntax match LogcatPid /\d+/ 

highlight link LogcatDate Constant
highlight link LogcatTime Statement

highlight link LogcatPid Label

" highlight link LogcatPidAndTag Label

let b:current_syntax="logcat"
