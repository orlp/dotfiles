" set default 'runtimepath' (without ~/.vim folders)
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)

" what is the name of the directory containing this file?
let s:portable = expand('<sfile>:p:h')

" add the directory to 'runtimepath'
let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)

" syntax highlighting
colorscheme wombat
syntax on

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




" line numbers
:set number

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

    " don't use these strange menu snips
    set guioptions-=t
end
