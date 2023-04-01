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

noremap <F1> <Esc>
noremap! <F1> <Esc>

"
" Fonts
"set guifont=DejaVu_Sans_Mono:h11
set guifont=DejaVu\ Sans\ Mono\ 14
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

inoremap <silent> <F2> <ESC>:up <cr>
nnoremap <silent> <F2> :up <cr>
nnoremap <silent> <F4> :%y + <CR>
vnoremap <silent> <F4> "+y
nnoremap <silent> <Leader>s :se hlsearch!<CR>
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

noremap <F11> :!ctags -a -R --kinds-c=dept $(sdl2-config --prefix)/include <CR>

autocmd FileType python nnoremap  <F5> :up <bar> !python % <cr>
autocmd FileType python nnoremap  <S-F5> :up <bar> Shell python % <cr>
autocmd FileType python nnoremap  <C-F5> :up <bar> set splitright <bar> vnew <bar> 0r!python #<cr>
"autocmd FileType c let $PATH .= ';C:\mingw\bin' | nnoremap  <F5> :up <bar> !gcc -c % <cr> | nnoremap  <F9> :up <bar> !gcc % <cr>
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
autocmd FileType gitcommit setlocal spell


se tabstop=4 shiftwidth=4
nnoremap <C-w>O :only!<CR>
"command! ReplaceWithClipboard %d | put +
nnoremap <Leader>b :set keymap=bulgarian-phonetic <BAR> setlocal spell spelllang=bg,en<CR>
nnoremap <Leader>n :set keymap= <BAR> setlocal spelllang=en spell! <CR>

set showcmd
" store backup, undo, and swap files in temp directory
set directory=$HOME/.vim/temp//
set backupdir=$HOME/.vim/temp//
set undodir=$HOME/.vim/temp//

se modeline
set statusline=%<%f\ %h%m%r\ %y%=%{v:register}\ %-14.(%l,%c%V%)\ %P
set laststatus=2
set belloff=all

nnoremap <F5> :up <BAR>make run<CR>
nnoremap <F6> :up <BAR>!g++ -g -O0 % `sdl2-config --libs --cflags` -lSDL2_ttf && ./a.out<CR>
nnoremap <S-F6> :up <BAR>!g++ -g -O0 % -lpthread  && ./a.out<CR>
nnoremap <F7> :up <BAR>!g++ --syntax-only % `sdl2-config --cflags`<cr>
