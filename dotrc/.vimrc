set nocompatible
filetype plugin indent on
syntax enable
if !has('gui_running')
    set t_Co=256
endif
set background=dark
colorscheme solarized
"colorscheme gruvbox
set autochdir
set cursorline
set autoindent
set autoread
set autowrite
set backspace=2 "fixing weird backspace problem
set cindent
set clipboard+=unnamed "yanks go to clipboard
"set colorcolumn=80
set completeopt=menu,longest,preview
set encoding=utf-8
set foldmethod=marker
set formatoptions=tcrql
set grepprg=ack\ -k
set history=1000
set hlsearch
set ignorecase
set smartcase
set incsearch
set laststatus=2
set lazyredraw
set linebreak "split words at last column, dont show partial words
"set listchars=tab:>>,trail:|
execute 'set listchars+=tab:\ ' . nr2char(187)
execute 'set listchars+=eol:' . nr2char(183)
"set list
set mouse=a
set nobackup
set noerrorbells
set nohidden
set nostartofline
set number
set pastetoggle=<F12>
"set path=.,/Android/bionic/libc/include/**,/linux/include/** "to work with ]I and gf
set ruler
set scrolloff=5
set showcmd
set showmatch
set showmode
set smartindent
set smarttab
set title
set ttyfast
set wildmenu
set wildmode=list:longest,full
set nofoldenable

function! KernelMode()
    set noexpandtab
    set shiftwidth=8
    set tabstop=8
    set softtabstop=8
endfunction
function! AndroidMode()
    set expandtab
    set shiftwidth=4
    set tabstop=4
    set softtabstop=4
endfunction
" Kernel mode as default
call KernelMode()
"call AndroidMode()
" My keymappings
nmap <F5> :diffu <CR>
nnoremap ; :
nnoremap <silent><C-\>m :marks<CR>
nmap <Home> ^
imap <Home> <ESC>I
" Global related
nmap <C-]> :GtagsCursor<CR>
nmap <C-\> :Gtags -r <C-R><C-W><CR>
let Gtags_No_Auto_Jump = 1
nmap <F10> :ccl<CR>
function! MyGlobalFindFile()
    call inputsave()
    let fname = input('File name:')
    call inputrestore()
    execute 'Gtags -Pi '.fname
endfunction
nmap <F9> :call MyGlobalFindFile()<CR>

" GUI options
if has('gui_running')
    set guioptions-=T  " no toolbar
    set guioptions-=m  " no menubar
    set guioptions-=r  " no right scroll
    set guioptions-=L  " no left scroll
    if has('win32')
        set guifont=Fira_Mono:h11:cANSI
    else
        set guifont=Fira\ Mono\ Medium\ 11
    endif
endif
