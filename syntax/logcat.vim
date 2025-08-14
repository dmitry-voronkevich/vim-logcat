if exists("b:current_syntax")
  finish
endif

let s:LogcatCustomTagNumber=0
let s:LogcatCustomTagsHighlights=['Type', 'Include', 'String', 'Identifier', 'Keyword', 'PreProc', 'Comment', 'Todo', 'Special', 'Statement', 'Constant']

function s:highlight_group(id)
  return s:LogcatCustomTagsHighlights[a:id % len(s:LogcatCustomTagsHighlights)]
endfunction

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
  let id = s:LogcatCustomTagNumber + 1
  if logcat#mapping#tagsAdd(a:tagname, id) == id
    let s:LogcatCustomTagNumber = id
    let highlightName = s:highlight_group(id)
    " Trick here is to be includedin LogcatTag which is a region waiting for
    " specific tags to be included in
    let syntaxGroup = 'LogcatCustomTag' . id
    execute 'syntax match ' . syntaxGroup . ' /\v' . a:tagname . '\ze\s*:/ containedin=LogcatTag'
    " Linking match ID with a highlight ID to enable colour
    execute 'highlight link ' syntaxGroup . ' ' . highlightName 

  endif
endfunction

function LogcatUnDefineHighlightTag(tagname)
  let id = logcat#mapping#tagsRemove(a:tagname)
  if id == 0
    echoerr "Can't un-define tag, it is unknown. Maybe it was not defined in the first place"
    return
  endif
  execute 'syntax clear LogcatCustomTag' . id
endfunction

function LogcatDefineHighlightById(id, phrase)
  execute 'syntax match LogcatHighlight' . a:id . ' /\v' . a:phrase . '/ contained containedin=LogcatMessage'
  let highlightName = s:highlight_group(a:id)
  execute 'highlight link LogcatHighlight' . a:id . ' ' . highlightName
endfunction

function LogcatDefineHighlight(phrase)
  let id = logcat#mapping#phrasesAdd(a:phrase)
  if id == 0
    echoerr 'Failed to add new highlight, run out of ids (max it 100)'
    return
  endif
  call LogcatDefineHighlightById(id, a:phrase)
  return id 
endfunction

function LogcatListHighlights()
  for [key, value] in logcat#mapping#phrases()
    echo key . " -> " . value
  endfor
endfunction

function LogcatUnDefineHighlight(id)
  let phrase = logcat#mapping#phrasesRemove(a:id)
  echo phrase
  if len(phrase) == 0
    echoerr "Unknown ID"
    return
  endif
  execute 'syntax clear LogcatHighlight' . a:id
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

syntax region LogcatConcealed start='--' end='$' conceal

function LogcatLinkHighlights()
  highlight link LogcatMessage Comment
  highlight link JavaException Error
  highlight link JavaStackTrace Error
  highlight link JavaFileReference Delimiter
  highlight link JavaFileName Include
  highlight link JavaFileLine Number
  for [id, phrase] in logcat#mapping#phrases()
    execute 'highlight link LogcatHighlight' . id . ' ' . s:highlight_group(id)
  endfor
  for [tag, id] in logcat#mapping#tags()
    execute 'highlight link LogcatCustomTag' .  id . ' ' . s:highlight_group(id)
  endfor
endfunction

augroup logcat_highlights
  autocmd!

  autocmd ColorScheme * call LogcatLinkHighlights()
augroup END
call LogcatLinkHighlights()

let b:current_syntax="logcat"
