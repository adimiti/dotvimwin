function! FileSize() abort
    let l:bytes = getfsize(expand('%p'))
    if (l:bytes >= 1024)
        let l:kbytes = l:bytes / 1025
    endif
    if (exists('kbytes') && l:kbytes >= 1000)
        let l:mbytes = l:kbytes / 1000
    endif
 
    if l:bytes <= 0
        return '0'
    endif
  
    if (exists('mbytes'))
        return l:mbytes . 'MB '
    elseif (exists('kbytes'))
        return l:kbytes . 'KB '
    else
        return l:bytes . 'B '
    endif
endfunction

set statusline=
" file encoding
set statusline+=\ %{(&fenc!=''?&fenc:&enc)}
" current time, when buffer saved
set statusline+=\ %{strftime('%R',\ getftime(expand('%')))}
set statusline+=\ %{&fileformat}
set statusline+=\ %{FileSize()}

