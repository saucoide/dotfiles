set number
set hlsearch
set incsearch
set wildmenu

set ttimeout
set ttimeoutlen=100

set laststatus=2
set splitbelow splitright

set tabstop=4
set shiftwidth=4

"packadd! dracula
syntax enable
"colorscheme dracula

filetype plugin indent on

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }

if has('mouse')
  set mouse=a
endif

" CUSTOM COMMANDS

:command W w
:command Wq wq
:command Q q

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif
