" Tags mapping {{{
let s:tags_mapping = {} " tag->id
" Adds a tag to a mapping or returns false if tag already exists
function logcat#mapping#tagsAdd(tag, value)
  if has_key(s:tags_mapping, a:tag)
    return 0
  endif
  let s:tags_mapping[a:tag] = a:value
  call logcat#state#write(0)
  return a:value
endfunction

" Removes tag from mapping and returns value previously associated or false
function logcat#mapping#tagsRemove(tag)
  if has_key(s:tags_mapping, a:tag)
    let res = remove(s:tags_mapping, a:tag)
    call logcat#state#write(0)
    return res
  else
    return 0
  endif
endfunction

" iterate over items like for [tag, id] in logcat#mapping#tagsItems()
function logcat#mapping#tags()
  return items(s:tags_mapping)
endfunction
" }}}

" Phrases mapping {{{
let s:phrases_mapping = {} " id->phrase

function logcat#mapping#phrasesAdd(phrase)
  for i in range(1, 100)
    if !has_key(s:phrases_mapping, i)
      let id = i
      break
    endif
  endfor
  if !exists('id')
    return 0
  endif
  let s:phrases_mapping[id] = a:phrase
  call logcat#state#write(0)
  return id
endfunction

function logcat#mapping#phrasesManualAdd(id, phrase)
  let s:phrases_mapping[a:id] = a:phrase
  call logcat#state#write(0)
endfunction

function logcat#mapping#phrases()
  return items(s:phrases_mapping)
endfunction

function logcat#mapping#phrasesGet(id)
  if !has_key(s:phrases_mapping, a:id)
    return ''
  endif
  return s:phrases_mapping[a:id]
endfunction

function logcat#mapping#phrasesRemove(id)
  if !has_key(s:phrases_mapping, a:id)
    return ""
  endif
  let res = remove(s:phrases_mapping, a:id)
  call logcat#state#write(0)
  return res
endfunction
" }}}

