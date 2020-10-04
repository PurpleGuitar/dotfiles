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

" ========================================================================
" Editor Settings
" ========================================================================
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set hlsearch
set ignorecase
set mouse=a
set ttymouse=xterm2
set title
set diffopt+=iwhite
set textwidth=75
set hidden
set complete+=k
set modeline
set sidescrolloff=0
set number
set nowrap


" ========================================================================
" Statusline
" ========================================================================
if !empty(glob("~/.vimrc-statusline"))
    source ~/.vimrc-statusline
endif


" ========================================================================
" Sort quickfix results
" ========================================================================
" Adapted from https://stackoverflow.com/a/15394482/4183435
"     and from https://stackoverflow.com/a/4479072/4183435
function! SortQuickfix(fn)
    call setqflist(sort(getqflist(), a:fn))
endfunction
function! QfStrCmpTrim(text)
    let text = a:text
    " Ignore leading and trailing whitespace
    let text = substitute(text, '^\s*\(.\{-}\)\s*$', '\1', '')
    " Ignore signal markers at beginning of line
    let text = substitute(text, '^[^a-zA-Z0-9]\s\+', '', '')
    return text
endfunction
function! QfStrCmp(e1, e2)
    let [t1, t2] = [a:e1.text, a:e2.text]
    let t1 = QfStrCmpTrim(t1)
    let t2 = QfStrCmpTrim(t2)
    return t1 <? t2 ? -1 : t1 ==? t2 ? 0 : 1
endfunction
function! QfStrCmpDesc(e1, e2)
    let [t1, t2] = [a:e1.text, a:e2.text]
    let t1 = QfStrCmpTrim(t1)
    let t2 = QfStrCmpTrim(t2)
    return t1 >? t2 ? -1 : t1 ==? t2 ? 0 : 1
endfunction
command! SortQuickFix call SortQuickfix('QfStrCmp')
command! SortQuickFixDesc call SortQuickfix('QfStrCmpDesc')


" ========================================================================
" Why move fingers if you don't have to?
" ========================================================================

" jj -> Esc
inoremap jj <ESC>

" <Backspace> to switch windows
nnoremap <Backspace> <C-^>

" Use ctrl-s to save (Windows muscle memory)
nnoremap <C-s> :update<CR>
inoremap <C-s> :update<CR>
vnoremap <C-s> <Esc>:update<CR>gv

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

" Tools for fixing up weird ASCII or whitespace characters
nnoremap <Leader>fix<Space> :silent! %s/\s\+$//<CR>:silent! %s/[\xa0]/ /g:silent! %s/\r//g<CR>
nnoremap <Leader>fix' :%s/[\x92’]/'/g<CR>
nnoremap <Leader>fix" :%s/[\x93\x94“”]/"/g<CR>
nnoremap <Leader>fix- :%s/[\x96\xb7]/-/g<CR>
command FindNonAscii /[^\x00-\x7F]

" Syntax highlighting under the cursor
function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction
nnoremap <Leader>hlt :echo SyntaxItem()<CR>

" Copy selected text to clipboard
" From: https://vim.fandom.com/wiki/Copy_search_matches
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)


" Other corrections
" abbrev THe The
" abbrev teh the
" abbrev nad and
" abbrev pkmn Pokémon
" abbrev pokemon Pokémon

" Invoke make
nnoremap <Leader>mm :wa<CR>:make<CR>
inoremap <Leader>mm <Esc>:wa<CR>:make<CR>
nnoremap <Leader>ml :wa<CR>:make lint<CR>
inoremap <Leader>ml <Esc>:wa<CR>:make lint<CR>
nnoremap <Leader>mt :wa<CR>:make test<CR>
inoremap <Leader>mt <Esc>:wa<CR>:make test<CR>

" Search for selected text, forwards or backwards.
" from http://vim.wikia.com/wiki/Search_for_visually_selected_text
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

" Fold everything around selected text
" From http://stackoverflow.com/questions/674613/vim-folds-for-everything-except-something
" vnoremap <Leader>za <Esc>`<kzfgg`>jzfG`<
" nnoremap <leader>zp :set foldmethod=manual<CR>zEvipjok<Esc>`<kzfgg`>jzfG`<

nnoremap <Leader>vr :e ~/.vimrc<CR>
nnoremap <Leader>vp :e ~/.vimrc-plugins<CR>
nnoremap <Leader>vl :e ~/.vimrc-local<CR>

" Markdown tables
nmap <leader>mdt gaap*\|
imap <leader>mdt <Esc>gaap*\|

" ========================================================================
" Other Misc Stuff
" ========================================================================

" Show tabs and trailing spaces
" From http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html
" Turn on with command :set list
set listchars=tab:>.,trail:.,nbsp:.

" Number selected list
" From: //stackoverflow.com/a/4224454
command! -nargs=0 -range=% NumberLines <line1>,<line2>s/^\s*\zs/\=(line('.') - <line1>+1).'. '

" Load my colorscheme if available (Must be called after vundle#end())
silent! colorscheme croz_dark

" ========================================================================
" Import local .vimrc, if there is one
" (this section should always be last)
" ========================================================================
if !empty(glob("~/.vimrc-local"))
    source ~/.vimrc-local
endif
