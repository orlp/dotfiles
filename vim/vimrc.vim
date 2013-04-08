" set default 'runtimepath' (without ~/.vim folders)
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)

" what is the name of the directory containing this file?
let s:portable = expand('<sfile>:p:h')

" add the directory to 'runtimepath'
let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)

" set this as my vimrc
let $MYVIMRC="~/vim/vimrc.vim"

" this is just mandatory
set nocompatible
set hidden

" change the mapleader from \ to ,
let mapleader=","

" syntax highlighting
colorscheme wombat
syntax on

" powerline
set laststatus=2
let g:Powerline_symbols = 'fancy'

" ctrlp buffer mode
nmap <silent> <leader>b :CtrlPBuffer<CR>

" nerdtree open
nmap <silent> <leader>n :NERDTreeToggle<CR>

" search
set ignorecase
set smartcase
set incsearch
set hlsearch 

" quick clear highlighting
map <silent> <leader>l :noh<CR>

" keep some distance from the edge of the screen while scrolling
set scrolloff=3

" tab settings
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set smarttab
set backspace=indent,eol,start

" enable filetype plugins
filetype plugin indent on

" line numbers
set number
            
" Make vim faster
set ttyfast
set lazyredraw 

" don't time out on mappings, do on key codes
set notimeout
set ttimeout
set timeoutlen=100

" no bells, please
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" no backups please (use a real version control)
set nobackup
set noswapfile

" automatically read files
set autoread

" save my poor shift key
nnoremap ; :

" use UTF-8
set encoding=utf-8

" I like wrapping
nnoremap j gj
nnoremap k gk

" who the hell uses Ex mode? remap to paragraph reformat
vmap Q gq
nmap Q gqap

" don't autocomplete these kind of files
set wildignore+=*.swp,*.zip,*.exe,*.pyc,*.o,*.pyo

" quick paste/yank from system clipboard
map <leader>p "+p
map <leader>y "+y









" cd to the directory containing the file in the buffer
nmap <silent> <leader>cd :lcd %:h<CR>

" easily edit vimrc
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" better cursor
set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

" skin gvim
if has("gui")
    " font
    set guifont=Consolas:h10

    " hide the toolbar
    set guioptions-=T

    " hide scrollbar
    set guioptions-=r
    set guioptions-=l
    set guioptions-=R
    set guioptions-=L

    " don't use these strange menu snips
    set guioptions-=t
end

" pathogen
execute pathogen#infect()
