" set default 'runtimepath' (without ~/.vim folders)
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)

" what is the name of the directory containing this file?
let s:portable = expand('<sfile>:p:h')

" add the directory to 'runtimepath'
let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)

" no compatability
set nocompatible

" change the mapleader from \ to ,
let mapleader=","

" syntax highlighting
colorscheme wombat
syntax on

" powerline
set laststatus=2
let g:Powerline_symbols = 'fancy'

" search
set smartcase
set incsearch
map <silent> <leader>l :noh<CR>

" keep some distance from the edge of the screen while scrolling
set scrolloff=5

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

" pathogen
execute pathogen#infect()

" ctrlp buffer mode
nmap <silent> <leader>b :CtrlPBuffer<CR>

" nerdtree open
nmap <silent> <leader>n :NERDTreeToggle<CR>

" line numbers
set number

" no bells, please
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" no backups please (use a real version control)
set nobackup
set noswapfile

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

" quick paste
nmap <leader>v "+gP

" strip trailing whitespace on save
" autocmd BufWritePre * :%s/\s\+$//e

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
