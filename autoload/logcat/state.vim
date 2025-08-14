let s:reading = 0

function logcat#state#read()
  let s:reading = 1
  let line=getline(1)
  if line =~ '^--vim-logcat;'
    " Parse hl map
    let hl_part = matchstr(line, 'hl:\zs[^;]*')
    for m in split(hl_part, ',')
      if m =~ '->'
        let [id, phrase] = split(m, '->')
        call logcat#mapping#phrasesManualAdd(id, phrase)
        call LogcatDefineHighlightById(id, phrase)
      endif
    endfor

    " Parse hl-tags
    let tags_part = matchstr(line, 'hl-tags:\zs.*')
    for tag in split(tags_part, ',')
      if len(tag) > 0
        call LogcatDefineHighlightTag(tag)
      endif
    endfor
  endif
  let s:reading = 0
endfunction

function logcat#state#write(create_if_not_available)
  if s:reading
    return
  endif
  let state_exists = getline(1) =~ '\v^--vim-logcat;'
  if state_exists || a:create_if_not_available
    let line = "--vim-logcat;hl:"
    for [id, phrase] in logcat#mapping#phrases()
      let line .= id . '->' . phrase . ','
    endfor
    let line .= ';hl-tags:'
    for [tag, id] in logcat#mapping#tags()
      let line .= tag . ","
    endfor
    let line .= ';'
    if state_exists
      execute 'normal ggS'.line
    else
      execute 'normal ggO'.line
    endif
    if !empty(expand('%')) && &buftype == ''
      :update
    endif
  endif
endfunction
