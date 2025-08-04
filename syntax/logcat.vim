if exists("b:current_syntax")
  finish
endif

let s:LogcatRegexDate='\d{1,2}-\d{1,2}'
let s:LogcatRegexTime='v\d{1,2}:\d{1,2}:\d{1,2}\.\d{3}'
let s:LogcatRegexPid='\d+'
let s:LogcatRegexTid='\d+'
let s:LogcatRegexLevel='[DWEFI]'
let s:LogcatRegexTag='.{-}:'
let s:LogcatRegexText='.*$'

function LogcatDefineHighlightTime(options)
  " options can be empty or conceal
  " conceal will hide date and time
  " empty will unhide it
  execute 'syntax match LogcatDate /\v^\d{1,2}-\d{1,2}/ nextgroup=LogcatTime skipwhite' . a:options
  execute 'syntax match LogcatTime /\v\d{1,2}:\d{1,2}:\d{1,2}\.\d{3}/ contained skipwhite nextgroup=LogcatPid' . a:options
endfunction

function LogcatDefineHighlightTag(tagname, syntaxGroup)
  echo 'syntax match ' . a:syntaxGroup . ' /\v^' . s:LogcatRegexDate . '\s+' . s:LogcatRegexTime . '\s+' . s:LogcatRegexPid . '\s+' . s:LogcatRegexTid . '\s+' . s:LogcatRegexLevel . '\s+' . '\zs'. a:tagname . '\ze\s+:\s+' . s:LogcatRegexText . '/'
endfunction

call LogcatDefineHighlightTime("")

syntax match LogcatPidAndTag /\v\d+-\d+\/\S+/ contains=LogcatPid
syntax match LogcatPid /\v\d+/ nextgroup=LogcatTid skipwhite contained
syntax match LogcatTid /\v\d+/ nextgroup=LogcatLevel skipwhite contained
syntax match LogcatLevel /\v[DIWEF]/ nextgroup=@LogcatTags skipwhite contained
syntax match LogcatTag /\v.{-}\ze:/ nextgroup=LogcatSeparator skipwhite contained
syntax match LogcatSeparator /:/ nextgroup=LogcatMessage contained
syntax match LogcatMessage /\v\s.*/ contained

syntax cluster LogcatTags contains=LogcatCustomTag1,LogcatTag


syntax match LogcatCustomTag1 /\vzloy\s{-}\ze:/ nextgroup=LogcatSeparator skipwhite contained 
syntax cluster LogcatCustomTags contains=LogcatTag1

highlight link LogcatMessage Comment
highlight link LogcatTag1 Identifier
let b:current_syntax="logcat"
