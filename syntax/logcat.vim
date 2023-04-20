syntax match LogcatDate /\v^\d{1,2}-\d{1,2}/
syntax match LogcatTime /\v\d{1,2}:\d{1,2}:\d{1,2}\.\d{3}/
syntax match LogcatPidAndTag /\v\d+-\d+\/\S+/ contains=LogcatPid
syntax match LogcatPid /\d+/ 

highlight link LogcatDate Constant
highlight link LogcatTime Statement

highlight link LogcatPid Label

" highlight link LogcatPidAndTag Label
