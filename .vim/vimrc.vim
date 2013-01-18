" make sure .vim is used
set runtimepath=~/.vim,$VIMRUNTIME

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
