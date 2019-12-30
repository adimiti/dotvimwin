source $VIMRUNTIME/vimrc_example.vim

"set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" MY defs
" ARROWS
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
"
" Fonts
set guifont=DejaVu_Sans_Mono:h11
function! s:ExecuteInShell(command)
	let command = join(map(split(a:command), 'expand(v:val)'))
	let winnr = bufwinnr('^' . command . '$')
	silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
	setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
	echo 'Execute ' . command . '...'
	silent! execute 'silent %!'. command
	silent! execute 'resize ' . line('$')
	silent! redraw
	silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
	silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
	echo 'Shell command ' . command . ' executed.'
endfunction

command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
se nu rnu
colorscheme torte
vnoremap <C-_> "-y:echo 'text' @- 'has length' strlen(@-)<CR>
nnoremap <C-_> :echo 'word' expand('<cword>') 'has length' strlen(substitute(expand('<cword>'), '.', 'x', 'g'))<CR>

nnoremap <silent> <F2> :up <cr>
nnoremap <silent> <F4> ggVG"*y
vnoremap <silent> <F4> "*y
nnoremap <silent> <Leader>s :se hlsearch!<CR>
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

"autocmd FileType python nnoremap  <F5> :up <bar> !C:\ProgramData\Anaconda2\python.exe % <cr>
"autocmd FileType python nnoremap  <S-F5> :up <bar> Shell C:\ProgramData\Anaconda2\python.exe % <cr>
"autocmd FileType python nnoremap  <C-F5> :up <bar> set splitright <bar> vnew <bar> 0r!C:\ProgramData\Anaconda2\python.exe #<cr>
autocmd FileType python nnoremap  <F5> :up <bar> !C:\Python27\python.exe % <cr>
autocmd FileType python nnoremap  <S-F5> :up <bar> Shell C:\Python27\python.exe % <cr>
autocmd FileType python nnoremap  <C-F5> :up <bar> set splitright <bar> vnew <bar> 0r!C:\Python27\python.exe #<cr>
autocmd FileType c let $PATH .= ';C:\mingw\bin' | nnoremap  <F5> :up <bar> !gcc -c % <cr> | nnoremap  <F9> :up <bar> !gcc -static-libgcc -static % <cr>
" IntelHex
nnoremap <silent> <Leader>h :call IHexChecksum()<CR>
function IHexChecksum()
    let l:data = getline(".")
    let l:dlen = strlen(data)

    if (empty(matchstr(l:data, "^:\\(\\x\\x\\)\\{5,}$")))
        echoerr("Input is not a valid Intel HEX line!")
        return
    endif

    let l:byte = 0
    for l:bytepos in range(1, l:dlen-4, 2)
        let l:byte += str2nr(strpart(l:data, l:bytepos, 2), 16)
    endfor

    let l:byte = (256-(l:byte%256))%256
    call setline(".", strpart(l:data, 0, l:dlen-2).printf("%02x", l:byte))
endfunction

" PLANTUML
if did_filetype()
  finish
endif

autocmd BufRead,BufNewFile * :if getline(1) =~ '^.*startuml.*$'| setfiletype plantuml | set filetype=plantuml | endif
autocmd BufRead,BufNewFile *.pu,*.uml,*.plantuml,*.puml setfiletype plantuml | set filetype=plantuml


se csprg=c:\Tools\bin\cscope.exe
se tabstop=4 shiftwidth=4
nnoremap <C-w>O :only!<CR>
"set backupdir=/c/Temp/
"set backupdir=$Temp
command! ReplaceWithClipboard %d | put +
" cscope to quick-fix
" set cscopequickfix=s-,c-,d-,i-,t-,e-,a-
" quckfix list and C-W=
"autocmd! BufWinEnter *Quickfix* setlocal nowinfixheight 
" autocmd Filetype gitcommit spell spelllang=en_us textwidth=72
autocmd FileType gitcommit setlocal spell

