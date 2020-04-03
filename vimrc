"" General
set number      " Show line numbers
se relativenumber
set linebreak   " Break lines at word (requires Wrap lines)
set showbreak=+++   " Wrap-broken line prefix
set textwidth=120   " Line wrap (number of cols)
set showmatch   " Highlight matching brace
set visualbell  " Use visual bell (no beeping)
 
set hlsearch    " Highlight all search results
set smartcase   " Enable smart-case search
set ignorecase  " Always case-insensitive
set incsearch   " Searches for strings incrementally
 
set autoindent  " Auto-indent new lines
set expandtab   " Use spaces instead of tabs
set shiftwidth=4    " Number of auto-indent spaces
set smartindent " Enable smart-indent
set smarttab    " Enable smart-tabs
set softtabstop=4   " Number of spaces per Tab
 
"" Advanced
set ruler   " Show row and column ruler information
set undodir=~/.vim/.undo//
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//

set undolevels=1000 " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour
 
 
nnoremap <Leader>b :set keymap=bulgarian-phonetic setlocal spell spelllang=bg
nnoremap <Leader>n :set keymap= setlocal spelllang=en spell!

set showcmd

""""
" used in S-F5
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)

" ARROWS
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
colorscheme torte
vnoremap <C-_> "-y:echo 'text' @- 'has length' strlen(@-)<CR>
nnoremap <C-_> :echo 'word' expand('<cword>') 'has length' strlen(substitute(expand('<cword>'), '.', 'x', 'g'))<CR>

nnoremap <silent> <F2> :up <cr>
nnoremap <silent> <F4> ggVG"*y
vnoremap <silent> <F4> "*y
nnoremap <silent> <Leader>s :se hlsearch!<CR>
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

autocmd FileType python nnoremap  <F5> :up <bar> !python % <cr>
autocmd FileType python nnoremap  <S-F5> :up <bar> Shell python % <cr>
autocmd FileType python nnoremap  <C-F5> :up <bar> set splitright <bar> vnew <bar> 0r!python #<cr>
" autocmd FileType c let $PATH .= ';C:\mingw\bin' | nnoremap  <F5> :up <bar> !gcc -c % <cr> | nnoremap  <F9> :up <bar> !gcc % <cr>
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


se tabstop=4
nnoremap <C-w>O :only!<CR>
command! ReplaceWithClipboard %d | put +
" set noundofile
"set modelines=1
set modeline
autocmd FileType gitcommit setlocal spell

se laststatus=2
" quit help with q 
autocmd FileType help nnoremap q :q<cr>

function! GotoJump()
  jumps
  let j = input("Please select your jump: ")
  if j != ''
    let pattern = '\v\c^\+'
    if j =~ pattern
      let j = substitute(j, pattern, '', 'g')
      execute "normal " . j . "\<c-i>"
    else
      execute "normal " . j . "\<c-o>"
    endif
  endif
endfunction
