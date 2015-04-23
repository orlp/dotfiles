" remove legacy
set nocompatible

" --------------------------------------------------------------------------------------------------
" Directories and environment meta-setups
" --------------------------------------------------------------------------------------------------

" http://stackoverflow.com/questions/3377298/how-can-i-override-vim-and-vimrc-paths-but-no-others-in-vim
" set default 'runtimepath' (without ~/.vim folders)
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)

" what is the name of the directory containing this file?
let s:portable = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let $VIMHOME = s:portable

" add the directory to 'runtimepath'
let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)

" create portable directories
if isdirectory($VIMHOME . '/.backup') == 0
    call mkdir($VIMHOME . '/.backup')
endif

if isdirectory($VIMHOME . '/.cache') == 0
    call mkdir($VIMHOME . '/.cache')
endif

if isdirectory($VIMHOME . '/.swap') == 0
    call mkdir($VIMHOME . '/.swap')
endif

if isdirectory($VIMHOME . '/.undo') == 0
    call mkdir($VIMHOME . '/.undo')
endif

" set portable file locations
let $MYVIMRC = $VIMHOME . '/vimrc.vim'
let g:unite_data_directory = $VIMHOME . '/.cache'
let g:NERDTreeBookmarksFile = $VIMHOME . '/.NERDTreeBookmarks'

set viminfo+=n$VIMHOME/.viminfo

set backupdir=$VIMHOME/.backup/
set backup

set directory=$VIMHOME/.swap// " two slashes intentional, prevents collisions (:help dir)
set swapfile

if exists('+undofile')
    set undodir=$VIMHOME/.undo// " two slashes intentional, prevents collisions (:help dir)
    set undofile
endif

" ctags
set tags=./tags;/


" vim-plug
call plug#begin($VIMHOME . '/bundle')
Plug 'vim-scripts/a.vim'
Plug  'haya14busa/incsearch.vim'
Plug  'scrooloose/nerdtree'
Plug 'vim-scripts/OnSyntaxChange'
Plug       'wting/rust.vim'
Plug    'ervandew/supertab'
Plug  'majutsushi/tagbar'
Plug      'Shougo/unite.vim'
Plug       'bling/vim-bufferline'
Plug       'tpope/vim-commentary'
Plug    'junegunn/vim-easy-align'
Plug    'Lokaltog/vim-easymotion'
Plug       'tpope/vim-fugitive'
Plug       'jistr/vim-nerdtree-tabs'
Plug        'amdt/vim-niji'
Plug       'tpope/vim-repeat'
Plug       'tpope/vim-surround'
Plug        'gcmt/wildfire.vim'

Plug 'luochen1990/rainbow'
Plug 'guns/xterm-color-table.vim'

Plug 'kana/vim-textobj-user'
Plug 'glts/vim-textobj-comment'
call plug#end()

" --------------------------------------------------------------------------------------------------
"  Settings
" --------------------------------------------------------------------------------------------------

" this is just mandatory
set hidden
filetype plugin on

" wrapping
set linebreak
if v:version > 704 || v:version == 704 && has("patch338")
  set breakindent
endif
set textwidth=100
set formatoptions-=t
set formatoptions+=c

" enable wrapping in multiline comments
call OnSyntaxChange#Install('Comment', '^Comment$', 0, 'a')
autocmd User SyntaxCommentEnterA setlocal formatoptions+=t
autocmd User SyntaxCommentLeaveA setlocal formatoptions-=t

if exists('+colorcolumn')
    set colorcolumn=+1
else
    augroup highlight_long_lines
      autocmd BufEnter * highlight OverLength ctermbg=0 guibg=#d7d7af
      autocmd BufEnter * match OverLength /\%>100v.\+/
    augroup END
end


" status line
set laststatus=2
set showcmd

set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%f\                              " file name
set statusline+=%m%r%w                           " flags
set statusline+=%=                               " right align
set statusline+=%{strlen(&ft)?&ft:'none'}\ \|\   " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}\ \|\ " encoding
set statusline+=%{&fileformat}                   " file format
set statusline+=\ %5l/%L\ :\ %2v                 " line/column number

" syntax highlighting
set t_Co=16
syntax on
if has("gui_running")
    set background=light
else
    set background=dark " this is flipped on gui for some reason
endif
colorscheme solarized

" keep some distance from the edge of the screen while scrolling
set scrolloff=5

" allow the cursor to go everywhere in block mode
set virtualedit=block

" indent settings
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
filetype plugin indent on
set smarttab
set backspace=indent,eol,start

autocmd! FileType pyth setlocal shiftwidth=2 tabstop=2

" override default indent to ignore blank lines
" set indentexpr=GetIndent(v:lnum)
" function! GetIndent(lnum)
"    return indent(prevnonblank(a:lnum - 1))
" endfunction

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

" automatically read files
set autoread

" fix backspace
set backspace=2

" fix mouse
set mouse=a

" use UTF-8
set encoding=utf-8

" NERDTree
let g:nerdtree_tabs_open_on_gui_startup = 0
let g:NERDTreeDirArrows=1
let g:NERDChristmasTree=0
let g:NERDTreeIgnore=["\.pyc$", "\.o$"]

" Unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

" EasyMotion
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion

" Rainbow Parentheses
let g:rainbow_active = 1
let g:rainbow_conf = {
\   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\   'ctermfgs': ['88', '94','106', '97', '99', '38'],
\   'operators': '_,_',
\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\   'separately': {
\       '*': {},
\       'tex': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\       },
\       'lisp': {
\           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\       },
\       'vim': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\       },
\       'css': 0,
\   }
\}

" search
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan
set gdefault
let g:incsearch#magic = '\v'

" autocomplete
set completeopt+=longest

" autocomplete
set wildignore+=*.swp,*.pyc,*.o,*.pyo
set wildmode=longest,list

" keep clipboard contents on vim exit
if has('unix')
    autocmd VimLeave * call system('xclip -selection clipboard', getreg('+'))
endif

" file extensions
au BufRead,BufNewFile *.md set filetype=markdown
au BufRead,BufNewFile *.pyth set filetype=pyth

" comments in C and co using double slashes
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" skin gvim
if has("gui_running")
    " font
    if has('win32')
        set guifont=Consolas:h11
    else
        set guifont=Monaco\ 10
    endif

    " hide cruft
    set guioptions+=mtTbrlRL
    set guioptions-=mtTbrlRL

    " no dialogs please
    set guioptions+=c

    " better cursor
    set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

    " make gvim remember pos
    let g:screen_size_restore_pos = 1
    source $VIMHOME/winsize_persistent.vim
endif

" --------------------------------------------------------------------------------------------------
"  Mappings
" --------------------------------------------------------------------------------------------------

" no typos
if has("user_commands")
    command! -bang -nargs=? -complete=file E e<bang> <args>
    command! -bang -nargs=? -complete=file W w<bang> <args>
    command! -bang -nargs=? -complete=file Wq wq<bang> <args>
    command! -bang -nargs=? -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

" easier indenting of code
nnoremap > >>
nnoremap < <<
vnoremap < <gv
vnoremap > >gv
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv

" select until end of line using vv
vnoremap v $h

" substitute in selection
vnoremap s :s//g<Left><Left>

" split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" better j/k with long lines
nnoremap j gj
nnoremap k gk

" incsearch
map  / <Plug>(incsearch-forward)
map  ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" easyalign
map <leader>a <Plug>(EasyAlign)

" select closest text object
" nmap <ENTER> vib
map <ENTER> <Plug>(wildfire-fuel)
omap <ENTER> <Plug>(wildfire-fuel)
xmap <S-ENTER> <Plug>(wildfire-water)

" paragraph reformat
vmap Q gw
nmap Q gwap

" search for visual selected text
function! s:match_visual()
    let old = @@
    normal! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = old
endfunction

xnoremap <silent> * :<C-U>call <SID>match_visual()<CR>n
xnoremap <silent> # :<C-U>call <SID>match_visual()<Bar>let v:searchforward=0<CR>n

" change the mapleader from \ to space
let mapleader=" "

" quick clear highlighting
map <silent> <leader>l :nohlsearch<CR>

" open current file in explorer
if has('win32')
    nmap <silent> <leader>ee :silent execute "!start explorer /select," . shellescape(expand("%:p"))<CR>
endif

" quick copy/paste to/from system clipboard
map <leader>p "+p
map <leader>P "+P
map <leader>y "+y
map <leader>Y "+Y

" make yanking consistent with deleting
nnoremap Y y$

" quick swap implementation/header
map <leader>h :A<CR>

" cd to the directory containing the file in the buffer
nmap <silent> <leader>cd :lcd %:h<CR>

" easily edit vimrc and reload
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" close buffer
nmap <leader>x :bd<CR>

" Unite, NERDTree
nmap <silent> <C-p> :Unite -start-insert file_rec<CR>
nmap <silent> <leader>n :NERDTreeTabsToggle<CR>
nmap <silent> <leader>N :NERDTreeFind<CR>

" easymotion
map <Leader>m <Plug>(easymotion-prefix)
map <Leader><Leader> <Plug>(easymotion-s)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

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
vmap <silent> <Leader>r :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy:let @/ = substitute(
    \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR>:set hlsearch<CR>:let g:should_inject_replace_occurences=1<CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>cgn


function! s:post_cgn()
    augroup post_cgn
        autocmd!
        autocmd InsertLeave <buffer> 
            \ execute "autocmd! post_cgn" |
            \ silent! call repeat#set("\<Plug>(cgn-next)") |
            \ silent! call feedkeys("n")
    augroup END
endfunction

function! s:cgn_next()
    " Check if we are on top of an occurence.
    let winview = winsaveview()
    let [lcur, ccur] = getpos(".")[1:2] 
    let [lstart, cstart] = searchpos(@/, 'bcW')
    let [lend, cend] = searchpos(@/, 'ceW')
    call winrestview(winview)

    if lstart != 0 && lcur >= lstart && lcur <= lend
       \ && (lcur != lstart || ccur >= cstart) && (lcur != lend || ccur <= cend)
        call s:post_cgn()
        return ":\<C-U>let &hlsearch=&hlsearch\<cr>cgn\<C-A>\<Esc>"
    else
        return ":\<C-U>silent! call search(@/)"
    endif

endfunction

function! s:cgn_first()
    call s:post_cgn()
    return ":\<C-U>let &hlsearch=&hlsearch\<CR>cgn"
endfunction

nnoremap <expr> <Plug>(cgn-next) <SID>cgn_next()
xnoremap <expr> <Plug>(cgn-next) <SID>cgn_next()

nnoremap <expr> <Plug>(quick-replace)
    \ ':let @/ = ''\V\<'' . escape(expand(''<cword>''), ''\'') . ''\>''<CR>' . <SID>cgn_first()
xnoremap <expr> <Plug>(quick-replace) <SID>cgn_first()

" nmap <Plug>(quick-replace) :let @/ = '\V\<' . escape(expand('<cword>'), '\') . '\>'<Bar>
"     \ let &hlsearch=&hlsearch<Bar>
"     \ call repeat#set("\<Plug>(cgn-next)")<CR>cgn
" xmap <Plug>(quick-replace) :<C-U>call <SID>match_visual()<Bar>
"     \ let &hlsearch=&hlsearch<Bar>
"     \ call repeat#set("\<Plug>(cgn-next)")<CR>cgn

nmap <leader>r <Plug>(quick-replace)
xmap <leader>r <Plug>(quick-replace)

function! ReplaceOccurence()
    " check if we are on top of an occurence
    let l:winview = winsaveview()
    let l:save_reg = getreg('"')
    let l:save_regmode = getregtype('"')
    let [l:lnum_cur, l:col_cur] = getpos(".")[1:2] 
    normal! ygn
    let [l:lnum1, l:col1] = getpos("'[")[1:2]
    let [l:lnum2, l:col2] = getpos("']")[1:2]
    call setreg('"', l:save_reg, l:save_regmode)
    call winrestview(winview)
    
    " if we are on top of an occurence, replace it
    if l:lnum_cur >= l:lnum1 && l:lnum_cur <= l:lnum2 && l:col_cur >= l:col1 && l:col_cur <= l:col2
        exe "normal! cgn\<c-a>\<esc>"
    endif
    
    call feedkeys("n")
    call repeat#set("\<Plug>ReplaceOccurences")
endfunction
