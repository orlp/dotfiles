" remove legacy
set nocompatible

" set default 'runtimepath' (without ~/.vim folders)
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)

" what is the name of the directory containing this file?
let s:portable = expand('<sfile>:p:h')

" add the directory to 'runtimepath'
let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)

" set this as my vimrc and similar file locations
let $MYVIMRC='~/vim/vimrc.vim'
set viminfo+=n~/vim/.viminfo
let g:unite_data_directory=expand('~/vim/.cache')

" pathogen
execute pathogen#infect()

" this is just mandatory
set hidden

" change the mapleader from \ to ,
let mapleader=" "

" status line
set laststatus=2
set ruler
set showcmd

" NERDTree
let g:nerdtree_tabs_open_on_gui_startup = 0
let g:NERDTreeDirArrows=1
let g:NERDChristmasTree=0
let g:NERDTreeIgnore=["\.pyc$", "\.o$"]
let g:NERDTreeBookmarksFile = expand('~/vim/.NERDTreeBookmarks')
nmap <silent> <leader>n :NERDTreeTabsToggle<CR>

" unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
nmap <silent> <C-p> :Unite -start-insert file_rec<CR>

" search
set ignorecase
set smartcase
set incsearch
set hlsearch

" autocomplete
set completeopt+=longest

" <leader> commands
" quick clear highlighting
map <silent> <leader>l :noh<CR>

" open current file in explorer
if has("win32")
    nmap <silent> <leader>ee :silent execute "!start explorer /select," . shellescape(expand("%:p"))<CR>
endif

" quick paste/yank from system clipboard
map <leader>p "+p
map <leader>P "+P
map <leader>y "+y

" quick swap implementation/header
map <leader>a :A<CR>

" cd to the directory containing the file in the buffer
nmap <silent> <leader>cd :lcd %:h<CR>

" easily edit vimrc and automatically reload
nmap <silent> <leader>ev :e $MYVIMRC<CR>

" easier indenting of code
vnoremap < <gv
vnoremap > >gv

" keep some distance from the edge of the screen while scrolling
set scrolloff=5

" indent settings
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
filetype plugin indent on
set smarttab
set backspace=indent,eol,start

" override default indent to ignore blank lines
set indentexpr=GetIndent(v:lnum)
function! GetIndent(lnum)
   return indent(prevnonblank(a:lnum - 1))
endfunction

" line numbers
set number
set cursorline

" make vim faster
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

" fix backspace
set backspace=2

" use UTF-8
set encoding=utf-8

" wrapping
set linebreak
set textwidth=120
nnoremap j gj
nnoremap k gk

" who the hell uses Ex mode? remap to paragraph reformat
vmap Q gq
nmap Q gqap

" don't autocomplete these kind of files
set wildignore+=*.swp,*.zip,*.exe,*.pyc,*.o,*.pyo

augroup reload_vimrc
    autocmd!
    autocmd BufWritePost ~/vim/vimrc.vim NERDTreeToggle|source ~/vim/vimrc.vim|NERDTreeToggle
augroup END

" search for visual selected text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" quick replace occurences
let g:should_inject_replace_occurences = 0
function! MoveToNext()
    if g:should_inject_replace_occurences
        call feedkeys("n")
        call repeat#set("\<Plug>ReplaceOccurences")
    endif

    let g:should_inject_replace_occurences = 0
endfunction

augroup auto_move_to_next
    autocmd! InsertLeave * :call MoveToNext()
augroup END

nmap <silent> <Plug>ReplaceOccurences :call ReplaceOccurence()<CR>
nmap <silent> co :let @/ = '\<'.expand('<cword>').'\>'<CR>:set hlsearch<CR>:let g:should_inject_replace_occurences=1<CR>cgn

function! ReplaceOccurence()
    " we can't use <cword> here because it is too forgiving on what exactly is considered 'under the cursor'
    let l:winview = winsaveview()
    let l:save_reg = getreg('"')
    let l:save_regmode = getregtype('"')
    normal! yiw
    let l:text = @@
    call setreg('"', l:save_reg, l:save_regmode)
    call winrestview(winview)

    if match(l:text, @/) != -1
        exe "normal! cgn\<c-a>\<esc>"
    endif
endfunction

" better cursor
set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

" skin gvim
if has("gui")
    " font
    set guifont=Consolas:h11

    " hide the menu bar
    set guioptions-=m

    " hide the toolbar
    set guioptions-=T

    " hide scrollbar
    set guioptions-=r
    set guioptions-=l
    set guioptions-=R
    set guioptions-=L

    " don't use these strange menu snips
    set guioptions-=t

    " make gvim remember pos
    let g:screen_size_restore_pos = 1
    source ~/vim/winsize_persistent.vim
end

" syntax highlighting
syntax on
set background=light
colorscheme solarized
