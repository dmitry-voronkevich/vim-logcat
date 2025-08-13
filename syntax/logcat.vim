if exists("b:current_syntax")
  finish
endif

let s:LogcatCustomTagNumber=0
let s:LogcatCustomTagsHighlights=['Type', 'Include', 'String', 'Identifier', 'Keyword', 'PreProc', 'Comment', 'Todo', 'Special', 'Statement', 'Constant']
let s:LogcatCustomTagSynGroups={}
let s:LogcatHighlightsMap = {}

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
  let s:LogcatCustomTagSynGroups[a:tagname]=s:LogcatCustomTagNumber
endfunction

function LogcatUnDefineHighlightTag(tagname)
  if has_key(s:LogcatCustomTagSynGroups, a:tagname)
    let num = s:LogcatCustomTagSynGroups[a:tagname]
    unlet s:LogcatCustomTagSynGroups[a:tagname]
    execute 'syntax clear LogcatCustomTag' . num
  endif
endfunction

function LogcatDefineHighlight(phrase)
  for i in range(1, 100)
    if !has_key(s:LogcatHighlightsMap, i)
      let num = i
      break
    endif
  endfor
  let s:LogcatHighlightsMap[num] = a:phrase
  execute 'syntax match LogcatHighlight' . num . ' /\v' . a:phrase . '/ contained containedin=LogcatMessage'
  let highlightName = s:LogcatCustomTagsHighlights[num % len(s:LogcatCustomTagsHighlights)]
  execute 'highlight link LogcatHighlight' . num . ' ' . highlightName
  return num
endfunction

function LogcatListHighlights()
  for key in keys(s:LogcatHighlightsMap)
    echo key . " -> " . s:LogcatHighlightsMap[key]
  endfor
endfunction

function LogcatGetHighlightById(id)
  if has_key(s:LogcatHighlightsMap, a:id)
    return s:LogcatHighlightsMap[a:id]
  else
    return ''
  endif
endfunction

call LogcatDefineHighlightTime("")

syntax match LogcatPid /\v\d+/ nextgroup=LogcatTid skipwhite contained
syntax match LogcatTid /\v\d+/ nextgroup=LogcatLevel skipwhite contained
syntax match LogcatLevel /\v[VDIWEF]/ nextgroup=LogcatTag skipwhite contained
syntax region LogcatTag start=' ' end=':' nextgroup=LogcatMessage skipwhite contained
syntax region LogcatMessage start=' ' end='$' contained

syntax match JavaException /\v \zs(\w+\.)+\w+(Error|Exception):/ containedin=LogcatMessage contained
syntax match JavaStackTrace /\v\t\zsat ([a-zA-Z_$0-9]+\.)+[a-zA-Z_<>$0-9]+\ze\(\w+.\w+:\d+\)/ containedin=LogcatMessage nextgroup=JavaFileReference contained
syntax region JavaFileReference start='(' end=')' contained
syntax match JavaFileName /\v\w+\.\w+/ containedin=JavaFileReference nextgroup=JavaFileLine contained
syntax match JavaFileLine /\v:\zs\d+/ containedin=JavaFileReference contained

function LogcatLinkHighlights()
  highlight link LogcatMessage Comment
  highlight link JavaException Error
  highlight link JavaStackTrace Error
  highlight link JavaFileReference Delimiter
  highlight link JavaFileName Include
  highlight link JavaFileLine Number
  for key in keys(s:LogcatHighlightsMap)
    execute 'highlight link LogcatHighlight' . key . ' ' . s:LogcatCustomTagsHighlights[key % len(s:LogcatCustomTagsHighlights)]
  endfor
  for key in keys(s:LogcatCustomTagSynGroups)
    execute 'highlight link LogcatCustomTag' .  s:LogcatCustomTagSynGroups[key] . ' ' . s:LogcatCustomTagsHighlights[key % len(s:LogcatCustomTagsHighlights)]
  endfor
endfunction

augroup logcat_highlights
  autocmd!

  autocmd ColorScheme * call LogcatLinkHighlights()
augroup END
call LogcatLinkHighlights()

let b:current_syntax="logcat"
