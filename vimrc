" Welcome to Craig's .vimrc file.

" Import plugins if available
" ========================================================================
if !empty(glob("~/.vimrc-plugins"))
    source ~/.vimrc-plugins
endif

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
autocmd FileType pandoc nnoremap j gj
autocmd FileType pandoc nnoremap k gk
autocmd FileType pandoc vnoremap j gj
autocmd FileType pandoc vnoremap k gk

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
silent! colorscheme croz

" Import local .vimrc, if there is one
" ========================================================================
if !empty(glob("~/.vimrc-local"))
    source ~/.vimrc-local
endif

" Lookup date
" Set date prog if it's something other than 'date'
" let g:date_prog = 'C:\MinGW\msys\1.0\bin\date.exe'
" Should move this to a vim plugin
function! s:get_date(...)
    if a:0 > 0
        let date_string = a:1
    else
        let date_string = input("Enter date: ")
    endif
    if exists("g:date_prog")
        let date_prog = g:date_prog
    else
        let date_prog = 'date'
    endif
    return substitute(system(date_prog . ' --date="' . date_string . '" +%Y-%m-%d'), '\n\+$', '', '')
endfunction
command! -nargs=* DateCopy let @" = s:get_date(<args>)
command! -nargs=* DatePasteAfter let @" = s:get_date(<args>) . ' ' | normal! ""p
command! -nargs=* DatePasteBefore let @" = s:get_date(<args>) . ' ' | normal! ""P

inoremap \ddd <C-o>:DatePasteAfter<CR>
inoremap \dd0 <C-o>:DatePasteAfter 'today'<CR>
inoremap \dd1 <C-o>:DatePasteAfter 'tomorrow'<CR>
inoremap \dd- <C-o>:DatePasteAfter 'tomorrow'<CR>
inoremap \dd2 <C-o>:DatePasteAfter '2 day'<CR>
inoremap \dd= <C-o>:DatePasteAfter '2 day'<CR>
inoremap \dd3 <C-o>:DatePasteAfter '3 day'<CR>
inoremap \dd4 <C-o>:DatePasteAfter '4 day'<CR>
inoremap \ddm <C-o>:DatePasteAfter 'monday'<CR>
inoremap \ddt <C-o>:DatePasteAfter 'tuesday'<CR>
inoremap \ddw <C-o>:DatePasteAfter 'wednesday'<CR>
inoremap \ddr <C-o>:DatePasteAfter 'thursday'<CR>
inoremap \ddf <C-o>:DatePasteAfter 'friday'<CR>
inoremap \dds <C-o>:DatePasteAfter 'saturday'<CR>
inoremap \ddu <C-o>:DatePasteAfter 'sunday'<CR>

nnoremap \ddd :DatePasteBefore<CR>
nnoremap \dd0 :DatePasteBefore 'today'<CR>
nnoremap \dd1 :DatePasteBefore 'tomorrow'<CR>
nnoremap \dd- :DatePasteBefore 'tomorrow'<CR>
nnoremap \dd2 :DatePasteBefore '2 day'<CR>
nnoremap \dd= :DatePasteBefore '2 day'<CR>
nnoremap \dd3 :DatePasteBefore '3 day'<CR>
nnoremap \dd4 :DatePasteBefore '4 day'<CR>
nnoremap \ddm :DatePasteBefore 'monday'<CR>
nnoremap \ddt :DatePasteBefore 'tuesday'<CR>
nnoremap \ddw :DatePasteBefore 'wednesday'<CR>
nnoremap \ddr :DatePasteBefore 'thursday'<CR>
nnoremap \ddf :DatePasteBefore 'friday'<CR>
nnoremap \dds :DatePasteBefore 'saturday'<CR>
nnoremap \ddu :DatePasteBefore 'sunday'<CR>


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
