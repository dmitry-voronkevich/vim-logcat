if exists("b:current_syntax")
  finish
endif

let s:LogcatCustomTagNumber=0
let s:LogcatCustomTagsHighlights=['Type', 'Include', 'String', 'Identifier', 'Keyword', 'PreProc', 'Comment', 'Todo', 'Special', 'Statement', 'Constant']
let s:LogcatCustomTagSynGroups={}

" Defines a syntax match groups for Date and Time
" Can redefine existing one with additonal options
" Useful options: conceal - to hide data/time entirely
" This function is called multiple times from a command or a shortcut to
" show/hide Date/Time
function LogcatDefineHighlightTime(options)
  " options can be empty or conceal
  " conceal will hide date and time
  " empty will unhide it
  execute 'syntax match LogcatDate /\v^\d{1,2}-\d{1,2}/ nextgroup=LogcatTime skipwhite ' . a:options
  execute 'syntax match LogcatTime /\v\d{1,2}:\d{1,2}:\d{1,2}\.\d{3}/ contained skipwhite nextgroup=LogcatPid ' . a:options
endfunction

" Defines a syntax group to highlight a specific Tag
" Called from a command or a shortcut to highlight specific tag under cursor
" (all instances of that tag will be highlighted)
function LogcatDefineHighlightTag(tagname)
  if has_key(s:LogcatCustomTagSynGroups, a:tagname)
    return
  endif
  let s:LogcatCustomTagNumber+=1
  let highlightName=s:LogcatCustomTagsHighlights[s:LogcatCustomTagNumber % len(s:LogcatCustomTagsHighlights)]
  " Trick here is to be includedin LogcatTag which is a region waiting for
  " specific tags to be included in
  execute 'syntax match LogcatCustomTag' . s:LogcatCustomTagNumber . ' /\v' . a:tagname . '\ze\s*:/ containedin=LogcatTag'
  " Linking match ID with a highlight ID to enable colour
  execute 'highlight link LogcatCustomTag' . s:LogcatCustomTagNumber . ' ' . highlightName 
  let s:LogcatCustomTagSynGroups[a:tagname]='LogcatCustomTag' . s:LogcatCustomTagNumber
endfunction

function LogcatUnDefineHighlightTag(tagname)
  if has_key(s:LogcatCustomTagSynGroups, a:tagname)
    let syntaxGroup = s:LogcatCustomTagSynGroups[a:tagname]
    unlet s:LogcatCustomTagSynGroups[a:tagname]
    execute 'syntax clear ' . syntaxGroup
  endif
endfunction

call LogcatDefineHighlightTime("")

syntax match LogcatPid /\v\d+/ nextgroup=LogcatTid skipwhite contained
syntax match LogcatTid /\v\d+/ nextgroup=LogcatLevel skipwhite contained
syntax match LogcatLevel /\v[VDIWEF]/ nextgroup=LogcatTag skipwhite contained
syntax region LogcatTag start=' ' end=':' nextgroup=LogcatMessage skipwhite contained
syntax match LogcatMessage /\v\s.*/ contained

highlight link LogcatMessage Comment
let b:current_syntax="logcat"
