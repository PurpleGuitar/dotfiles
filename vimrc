" Welcome to Craig's .vimrc file.
scriptencoding utf-8

" ========================================================================
" Import plugins if available
" ========================================================================
" Vundle not installed?  Here's how to get it set up:
" 1. mkdir -p ~/.vim/bundle
" 2. cd ~/.vim/bundle
" 3. git clone https://github.com/VundleVim/Vundle.vim.git
" 4. Start Vim
" 5. :PluginInstall
" 6. Happy Vimming!

" Helpful Vundle commands:
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" see :h vundle for more details or wiki for FAQ
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
if !empty(glob("~/.vimrc-plugins"))
    source ~/.vimrc-plugins
endif
if !empty(glob("~/.vimrc-plugins-local"))
    source ~/.vimrc-plugins-local
endif
call vundle#end()
filetype plugin indent on
syntax on

" Don't wrap pandoc docs (has to happen after plugins)
autocmd FileType pandoc set nowrap

" ========================================================================
" Editor Settings
" ========================================================================
set expandtab
set shiftwidth=4
set softtabstop=4
set hlsearch
set ignorecase
set mouse=a
set ttymouse=xterm2
set nowrap
set title
set diffopt+=iwhite
set textwidth=75
set hidden
set complete+=k
set modeline


" ========================================================================
" Why move fingers if you don't have to?
" ========================================================================

" jj -> Esc
inoremap jj <ESC>

" Invoke make
nnoremap <Leader>m :wa<CR>:make<CR>
inoremap <Leader>m <Esc>:wa<CR>:make<CR>

" Use ctrl-s to save (Windows muscle memory)
nnoremap <C-s> :update<CR>
inoremap <C-s> :update<CR>
vnoremap <C-s> <Esc>:update<CR>gv

" Fixup whitespace, ASCII
nnoremap <Leader>fix<Space> :silent! %s/\s\+$//<CR>:silent! %s/[\xa0]/ /g<CR>
nnoremap <Leader>fix' :%s/[\x92’]/'/g<CR>
nnoremap <Leader>fix" :%s/[\x93\x94“”]/"/g<CR>
nnoremap <Leader>fix- :%s/[\x96\xb7]/-/g<CR>
nnoremap <leader>fa /[^\x00-\x7F]<CR>
nnoremap <leader>ga ga


" Search for visually selected text with //
vnoremap // y/<C-R>"<CR>

" Handle linewise movement
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Window shortcuts
nmap <C-w>- <C-w>s
nmap <C-w>\ <C-w>v

" Alt-up and Alt-down to move lines around
" (This mimics the excellent S-A-Up and Down on OneNote)
nmap <Esc><Up> [e
nmap <Esc><Down> ]e
nmap <A-Up> [e
nmap <A-Down> ]e
nmap <A-S-Up> [e
nmap <A-S-Down> ]e
nnoremap <A-Left> <<
nnoremap <A-Right> >>
nnoremap <A-S-Left> <<
nnoremap <A-S-Right> >>

" Load my colorscheme if available
" Must be called after vundle#end()
silent! colorscheme croz_dark

" Correct two initial capitals
" From: https://groups.google.com/forum/#!topic/comp.editors/L8_j0vrs2Hg
fu! AAa_to_Aaa()
    let c = getline(".")[0:col(".")-2]
    if c =~ '\v\C<[[:upper:]]{2}[[:lower:]]$'
        let pos = getpos('.')
        normal hh~
        call setpos('.',pos)
    endif
endf
:au CursorMovedI * call AAa_to_Aaa()

" Other corrections
abbrev teh the
abbrev nad and
abbrev pkmn Pokémon
abbrev pokemon Pokémon

" Fold everything around selected text
" From: http://stackoverflow.com/questions/674613/vim-folds-for-everything-except-something
vnoremap <Leader>za <Esc>`<kzfgg`>jzfG`<
nnoremap <leader>zp :set foldmethod=manual<CR>zEvipjok<Esc>`<kzfgg`>jzfG`<

"
" Python2 vs. Python3
"
function Py2()
  let g:syntastic_python_python_exec = '/usr/local/bin/python2.7'
endfunction

function Py3()
  let g:syntastic_python_python_exec = '/usr/local/bin/python3.6'
endfunction

call Py3()   " default to Py3 because I try to use it when possible

" ========================================================================
" Import local .vimrc, if there is one
" ========================================================================
if !empty(glob("~/.vimrc-local"))
    source ~/.vimrc-local
endif

