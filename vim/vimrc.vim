" TODO: easyalign cheat40

" Disable legacy cruft and enable compatibility.
set nocompatible
set langnoremap
filetype plugin indent on
syntax on

" --------------------------------------------------------------------------------------------------
" Set VIM up such that it loads config from our dotfiles, and save data there.
" --------------------------------------------------------------------------------------------------

" http://stackoverflow.com/questions/3377298
" Set default 'runtimepath' (without ~/.vim folders).
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)

" What is the name of the directory containing this file?
let s:portable = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let $VIMHOME = s:portable

" Add the directory to 'runtimepath'.
let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)

" Create data directories.
if has('nvim')
    let $VIMDATA = $VIMHOME . '/.nvimdata'
else
    let $VIMDATA = $VIMHOME . '/.vimdata'
endif

call mkdir($VIMDATA . '/backup', 'p')
call mkdir($VIMDATA . '/cache',  'p')
call mkdir($VIMDATA . '/swap',   'p')
call mkdir($VIMDATA . '/undo',   'p')

" Set portable file locations.
let $MYVIMRC = $VIMHOME . '/vimrc.vim'
" let g:unite_data_directory = $VIMDATA . '/.cache'
let g:NERDTreeBookmarksFile = $VIMDATA . '/NERDTreeBookmarks'

set backupdir=$VIMDATA/backup/
set backup

set directory=$VIMDATA/swap//  " Two slashes intentional, see :help dir.
set swapfile

if exists('+undofile')
    set undodir=$VIMDATA/undo//  " Two slashes intentional, see :help dir.
    set undofile
endif

if has('nvim')
    let &shadafile = $VIMDATA . '/shada'
else
    if exists('+viminfo')
        let &viminfofile = $VIMDATA . '/viminfo'
        set viminfo+=!
    endif
endif


" --------------------------------------------------------------------------------------------------
" Plugins.
" --------------------------------------------------------------------------------------------------

call plug#begin($VIMHOME . '/plugged')
Plug 'orlp/vim-bunlink'
Plug 'tweekmonster/helpful.vim'

" Unsure about these for now.
Plug 'junegunn/goyo.vim'             " Distraction-free editing.
Plug 'scrooloose/nerdtree'           " File explorer.
Plug 'justinmk/vim-dirvish'          " File explorer.
Plug 'metakirby5/codi.vim'           " Live evaluation.

Plug 'orlp/vim-repeat'               " Adds repeat support for plugin commands.
Plug 'orlp/vim-quick-replace'        " Quick find/replace.
Plug 'ap/vim-buftabline'             " Uses tabline to show open buffers.
" Plug 'bling/vim-bufferline'        " Uses statusline to show open buffers.
Plug 'tpope/vim-surround'            " Adds surround text objects (e.g. s) for parentheses).
Plug 'tpope/vim-commentary'          " Adds gc command to (un)comment.
Plug 'tpope/vim-fugitive'            " Git support.
Plug 'tpope/vim-unimpaired'          " Lots of neat paired mappings.
Plug 'tpope/vim-characterize'        " Improves ga character analysis output.
Plug 'tpope/vim-eunuch'              " Filesystem commands.
Plug 'mbbill/undotree'               " Visualize undos as a tree.
Plug 'junegunn/vim-easy-align'       " Quick aligning.
Plug 'kana/vim-textobj-user'         " Custom text objects.
Plug 'kana/vim-textobj-line'         " al/il for current line object.
Plug 'beloglazov/vim-textobj-quotes' " aq/iq for quotes.
Plug 'kana/vim-textobj-entire'       " ae/ie for entire file.
Plug 'AndrewRadev/sideways.vim'      " Argument shuffling and text objects.
Plug 'gcmt/wildfire.vim'             " Fast automatic selection of object around cursor.
Plug 'ervandew/supertab'             " Use tab for code completion.
Plug 'lifepillar/vim-cheat40'        " Cheat sheet.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Color schemes.
Plug 'morhetz/gruvbox'               " Color scheme.
Plug 'lifepillar/vim-solarized8'     " Color scheme.
Plug 'NLKNguyen/papercolor-theme'    " Color scheme.
call plug#end()

" Use ripgrep if possible.
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif

" Use fd for fzf if possible.
if executable('fd')
    let $FZF_DEFAULT_COMMAND = 'fd --type file --hidden --exclude .git'
    command! -bang -nargs=? -complete=dir FilesNoIgnore call fzf#vim#files(<q-args>,
        \ fzf#vim#with_preview({'source': 'fd --type file --hidden --no-ignore --exclude .git'}), <bang>0)
else
    command! -bang -nargs=? -complete=dir FilesNoIgnore
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
endif

" Prefer if file history just broke ties by recently used.
command! -bang -nargs=? -complete=dir FileHistory
    \ call fzf#vim#history({'options': ['--tiebreak=index']}, <bang>0)

" CTRL-A CTRL-Q to select all and build quickfix list.
function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:half-page-down,ctrl-u:half-page-up,tab:toggle'


let g:cheat40_foldlevel = 0
let g:cheat40_use_default = 0

let g:buftabline_show = 1        " Only show with 2+ buffers.
let g:buftabline_indicators = 1  " Indicate modified buffers.
let g:buftabline_numbers = 2     " Use ordinal numbering.

" NERDTree config.
let g:NERDTreeRespectWildIgnore=1
let g:NERDTreeNaturalSort=1
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="-"
" Close NERDTree if it's the only window left.
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" --------------------------------------------------------------------------------------------------
" Pure Vim settings.
" --------------------------------------------------------------------------------------------------

" This is mandatory for my Vim workflow, allows switch buffers with unsaved changes.
set hidden

" Sane backspace behavior.
set backspace=indent,eol,start

" Allow the cursor to go everywhere in block mode.
set virtualedit=block

" Enable mouse.
set mouse=a

" Indent settings.
set tabstop=4    " One tab is equivalent to 4 spaces.
set shiftwidth=4 " One 'indent' is 4 spaces.
set expandtab    " Insert spaces instead of tab.
set autoindent   " Copy indent from last line.
set smarttab     " Sane tab and backspace behavior for indenting.
set shiftround   " Round indents (when using < and >) to multiple of shiftwidth.
set cino+=(0     " Don't add extra indent after opening parentheses.

" Wrapping.
set textwidth=100
set linebreak          " Wrap at word boundaries (purely display).
if has('nvim') || v:version > 704 || v:version == 704 && has("patch338")
    set breakindent    " Wrapped lines keep indent (purely display).
endif
set formatoptions+=cj  " Automatically add/remove comment leaders when wrapping.
if exists('+colorcolumn') && !exists('g:vscode')
    set colorcolumn=+1 " Render line indicating text width.
endif
set scrolloff=5        " Keep some distance from the edge of the screen while scrolling.
set sidescroll=1       " When wrap is off, with what increment should we scroll horizontally?

" Search.
set hlsearch   " Highlight all previous search results.
set incsearch  " Incremental search.
set ignorecase " Ignore case while searching (use \C for exact match)...
set smartcase  " ...but don't ignore when there's a capital in query.
set wrapscan   " Searches wrap around file end/start.

" Status line.
set laststatus=2 " Always show status line.
set showcmd      " Show (part of) the command we're typing, and visual mode stats.

function! vimrc#scrollbar()
    let width = 9
    let perc = (line('.') - 1.0) / (max([line('$'), 2]) - 1.0)
    let before = float2nr(round(perc * (width - 3)))
    let after = width - 3 - before
    return '[' . repeat(' ',  before) . '=' . repeat(' ', after) . ']'
endfunction

set statusline=                                   " Clear the statusline for when vimrc is reloaded.
set statusline+=%f\                               " File name.
set statusline+=%m%r%w                            " Flags.
set statusline+=%=                                " Right align.
set statusline+=%{strlen(&ft)?&ft:'none'}         " Filetype.
set statusline+=\ \|\ %{strlen(&fenc)?&fenc:&enc} " Encoding.
" set statusline+=\ \|\ %{&fileformat}            " File format.
" set statusline+=\ %3p%%                         " Percentage.
set statusline+=\ \ %{vimrc#scrollbar()}          " Scrollbar
set statusline+=\ \ %4l\:\%-3v                    " Line/column number.

" Line numbers.
set number     " The line numbers.
if !exists('g:vscode')
    set cursorline " A line highlighting the currently selected line.
    augroup vimrc_cursorline_only_active_window
        autocmd!
        autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        autocmd WinLeave * setlocal nocursorline
    augroup END  
endif

" Autocomplete.
set complete-=i           " No included files (clutters).
set completeopt+=longest  " Automatically complete up to longest shared prefix.

" Miscellaneous.
set nrformats=bin,hex " When de/incrementing with CTRL-A/X, don't consider octal.
set nostartofline     " Try to maintain column when using e.g. gg/G/ctrl-D.
set autoread          " Automatically read files if updated.

" Generic enhancements/sane defaults.
set encoding=UTF-8              " Internal Vim encoding.
set belloff=all                 " No bells please.
set fsync                       " I never had problems with it; I don't want uncertainty.
set history=10000               " Longer command history.
set undolevels=10000            " Longer undo history.
if has('nvim')
    set display=lastline,msgsep " Saner long line and command msg display.
else
    set display=lastline        " Saner long line display.
endif
set sessionoptions+=unix,slash  " Saner sessions.
set sessionoptions-=options
set viewoptions+=unix,slash
set shortmess+=F                " Avoid hit-enter prompt when file is edited.
set tabpagemax=50               " Allow more tabs to be opened.
set ttyfast                     " Faster Vim.
set lazyredraw                  " Don't redraw during macros, faster.
set notimeout                   " Do not timeout mappings.
set ttimeout                    " Time out key codes.
" set timeoutlen=10               " Short timeout for keycodes.
set ttimeoutlen=10              " Short timeout for keycodes.
let $ESCDELAY=10                " Faster escape timeout for FZF (might be problematic).
set wildmenu                    " Better command-line completion.
if has('nvim')
    set wildoptions=tagfile,pum
else
    set wildoptions=tagfile
endif
set wildmode=longest:full,full
set wildignore+=*.swp,*.pyc,*.o,*.pyo,*.gch,*.gch.d,*.bz2,*.pdf
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" Comments.
augroup vimrc_comments
    autocmd!
    autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s  " Double slashes please.
    " autocmd FileType python setlocal comments=b:#  " Don't know why this includes - normally.
augroup END

" --------------------------------------------------------------------------------------------------
" Aesthetics.
" --------------------------------------------------------------------------------------------------

" Style bat colors based on our theme.
function! s:toggle_bat_envvar()
    if (&background == "light")
        let $BAT_THEME='Monokai Extended Light'
    else
        let $BAT_THEME=''
    endif
endfunction
augroup vimrc_update_bat_theme
    autocmd!
    autocmd ColorScheme * call s:toggle_bat_envvar()
augroup end

function! s:patch_colorscheme()
    if g:colors_name == 'gruvbox'
        hi link Function GruvboxGreen
    endif
endfunction
augroup vimrc_colorscheme_patch
    autocmd!
    autocmd ColorScheme * call s:patch_colorscheme()
augroup end

" https://github.com/vim/vim/issues/993
" Set Vim-specific sequences for RGB colors.
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set background=dark
colorscheme gruvbox

if has('gui_running')
    set guioptions-=a    " Don't constantly update clipboard.
    set guioptions-=e    " No GUI tab line.
    set guioptions-=m    " No menu bar.
    set guioptions-=T    " No toolbar.
    set guioptions-=l    " No scrollbar.
    set guioptions-=L    " No scrollbar.
    set guioptions-=r    " No scrollbar.
    set guioptions-=R    " No scrollbar.
    set guioptions+=i    " Icon is nice.
    set guioptions+=c    " No dialogs please.

    if has('win32')
        " set guifont=Consolas:h10
        set guifont=Iosevka_Fixed:h10
    endif
endif


" --------------------------------------------------------------------------------------------------
" Mappings.
" --------------------------------------------------------------------------------------------------

" Never time out on mappings.
set notimeout

" Fix alt not working on terminal vim, and disable alt in insert mode.
let s:alnum = map(range(48, 57) + range(97, 122) , 'nr2char(v:val)')
for s:char in s:alnum
    if !has('nvim') && !has('gui_running')
        execute "set <A-" . s:char . ">=\e" . s:char
    endif
    execute "imap <A-" . s:char . "> <NOP>"
endfor
unlet s:alnum
unlet s:char

" Fix ctrl+6 sometimes not working in gvim.
nnoremap <silent> <C-6> <C-^>

" Fix visual mode ctrl-X on windows.
silent! vunmap <C-X>

" Change the mapleader from \ to space.
let mapleader=" "

" Make space do nothing.
nnoremap <Space> <Nop>
xnoremap <Space> <Nop>

" Ignore shift to make it easier to hit shift-leader mappings.
nmap <S-Space> <Space>


if has("user_commands")
    " No typos from holding shift.
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

" Free up s and S (use cl instead of s and cc for S). Prevent muscle-memory.
nmap s <Nop>
xmap s <Nop>
nmap S <Nop>

" Significantly easier de/indenting of code.
nnoremap > >>
nnoremap < <<
xnoremap < <gv
xnoremap > >gv
xnoremap <TAB> >gv
xnoremap <S-TAB> <gv

" Select until end of line using vv.
vnoremap v $h

" Make yanking consistent with deleting.
nnoremap Y y$

" Better j/k with wrapping.
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
xnoremap j gj
xnoremap k gk
xnoremap gj j
xnoremap gk k

" Quick rewrapping.
xmap Q gw
nmap Q gwap

" Split navigation.
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Line shuffling (uses vim-unimpaired).
nmap <A-j> ]e
nmap <A-k> [e
xmap <A-j> ]egv
xmap <A-k> [egv

" Argument shuffling.
nnoremap <A-h> :SidewaysLeft<CR>
nnoremap <A-l> :SidewaysRight<CR>

" Argument append/insert.
nmap si <Plug>SidewaysArgumentInsertBefore
nmap sa <Plug>SidewaysArgumentAppendAfter
nmap sI <Plug>SidewaysArgumentInsertFirst
nmap sA <Plug>SidewaysArgumentAppendLast

" Argument text object.
xmap aa <Plug>SidewaysArgumentTextobjA
omap aa <Plug>SidewaysArgumentTextobjA
xmap ia <Plug>SidewaysArgumentTextobjI
omap ia <Plug>SidewaysArgumentTextobjI
omap , ia
xmap , ia
" When deleting an argument we also want to delete the comma.
nmap d, daa

" Quote text object.
xmap q iq
omap q iq
xmap Q aq
omap Q aq

" Select closest text object.
let g:wildfire_objects = ["ia", "i'", 'i"', "i)", "i]", "i}", "i>", "al", "ip", "it"]
nmap <ENTER> <Plug>(wildfire-fuel)
xmap <ENTER> <Plug>(wildfire-fuel)
omap <ENTER> <Plug>(wildfire-fuel)
xmap <S-ENTER> <Plug>(wildfire-water)

" Change character under cursor.
nnoremap ss cl

" Trim trailing whitespace.
function! s:trim_whitespace()
    let l:save = winsaveview()
    let l:search = @/
    if mode() == 'n'
        %s/\s\+$//e
    else
        '<,'>s/\s\+$//e
    endif
    call winrestview(l:save)
    let @/ = l:search
    nohl
endfun
nnoremap <silent> st :call <SID>trim_whitespace()<CR>
xnoremap <silent> st :<C-U>call <SID>trim_whitespace()<CR>

" EasyAlign.
nmap sa <Plug>(EasyAlign)
xmap sa <Plug>(EasyAlign)

" Quick-replace and search.
nmap <silent> sr <Plug>(QuickReplaceWord)
nmap <silent> sR <Plug>(QuickReplaceWordBackward)
xmap <silent> sr <Plug>(QuickReplaceSelection)
xmap <silent> sR <Plug>(QuickReplaceSelectionBackward)
xmap <silent> * <Plug>(StartSelectionSearch):<C-U>call feedkeys('n')<CR>
xmap <silent> # <Plug>(StartSelectionSearchBackward):<C-U>call feedkeys('n')<CR>

" Create splits.
if !exists('g:vscode')
    nnoremap <silent> sh :leftabove vsplit<CR>
    nnoremap <silent> sl :rightbelow vsplit<CR>
    nnoremap <silent> sk :leftabove split<CR>
    nnoremap <silent> sj :rightbelow split<CR>
endif

" Easily edit vimrc and reload.
nnoremap <silent> <leader>ve :e $MYVIMRC<CR>
nnoremap <silent> <leader>vo :so $MYVIMRC<CR>

" Start/stop spellchecking.
nnoremap <silent> <leader>s :set spell!<CR>

" Quick clear highlighting / error msg.
nnoremap <silent> <leader>l :nohlsearch <Bar> echon ''<CR>

" Extra easy copy/paste register.
nnoremap sp "sp
xnoremap sp "sp
nnoremap sP "sP
xnoremap sP "sP
nnoremap sy "sy
xnoremap sy "sy
nnoremap sY "sY
xnoremap sY "sY

" Quick copy/paste to/from system clipboard.
nnoremap <leader>p "+p
xnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <leader>P "+P
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>Y "+Y
xnoremap <leader>Y "+Y

" Change directory to the file contained in the buffer.
nnoremap <silent> <leader>cd :lcd %:p:h<CR>

" Change directory to the git root of the file contained in the buffer.
nnoremap <silent> <leader>cg :Glcd<CR>

" Fzf.
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>F :FilesNoIgnore<CR>
" All files in git repository, except ignored.
nnoremap <silent> <leader>g :Glcd<CR>:GFiles --others --cached --exclude-standard<CR>
" Only tracked files.
nnoremap <silent> <leader>G :Glcd<CR>:GFiles<CR>
nnoremap <silent> <leader>h :FileHistory<CR>

" Unlink buffer.
nnoremap <silent> <leader>x :Bunlink<CR>
nnoremap <silent> <leader>X :Bunlink!<CR>

" Dirvish.
nnoremap <silent> <leader>d :Dirvish<CR>
nnoremap <silent> <leader>D :Dirvish %<CR>

" Cheat sheet.
let g:cheat40_buf_id = 0
function! s:toggle_cheatsheet()
    if bufwinnr(g:cheat40_buf_id) == -1
        call cheat40#open(0)
        normal! jj
    else
        if bufwinnr(g:cheat40_buf_id) == winnr()
            wincmd p
        endif
        silent! exe 'bd ' . g:cheat40_buf_id
    endif
endfunction
augroup vimrc_cheat40_enhance
    autocmd!
    autocmd FileType cheat40 nnoremap <silent><buffer> <ENTER> za
    autocmd FileType cheat40 nnoremap <silent><buffer> q :bd<CR>
    autocmd FileType cheat40 let g:cheat40_buf_id = bufnr('%')
augroup END
nnoremap <silent> <leader>cs :call <SID>toggle_cheatsheet()<CR>
nnoremap <silent> <leader>cS :e $VIMHOME/cheat40.txt<CR>

" Undotree.
nnoremap <leader>u :UndotreeToggle<CR>

" NERDTree.
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>N :call <SID>NERDTreeVCSFind(expand('%', ':p'))<CR>

function! s:NERDTreeVCSFind(path)
    execute 'NERDTreeVCS ' . fnamemodify(a:path, ':p:h')
    execute 'NERDTreeFind ' . fnamemodify(a:path, ':p')
endfunction

" Open current file in system file explorer.
if has('win32')
    nnoremap <silent> <leader>e :silent exe "!start explorer /select," . shellescape(expand("%:p"))<CR>
else
    nnoremap <silent> <leader>e :silent exe "!xdg-open " . shellescape(expand("%:p:h"))<CR>
endif

" Copy current filename to clipboard.
nnoremap <leader>% :let @+ = expand('%:p')<CR>

" Execute line on terminal.
nnoremap <leader>t :put =system(getline('.'))<cr>
vnoremap <leader>t :<C-U>'>put =system(join(getline('''<','''>'),\"\n\").\"\n\")<cr>

" Buftabline.
nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(-1)

" Quick quit help.
augroup vimrc_help
    autocmd!
    autocmd Filetype help nnoremap <silent><buffer> q :bd<CR>
augroup END

" --------------------------------------------------------------------------------------------------
" Other features.
" --------------------------------------------------------------------------------------------------

" If path doesn't exist on write, ask to create it.
" https://stackoverflow.com/a/42872275/565635
augroup vimrc_auto_mkdir
    autocmd!
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
    function! s:auto_mkdir(dir, force)
        if !isdirectory(a:dir)  && (a:force ||
            \ input("Directory '" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$')
            call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
        endif
    endfunction
augroup END
