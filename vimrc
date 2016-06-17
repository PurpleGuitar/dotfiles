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

" Special commands for todoing
autocmd FileType pandoc nnoremap <Leader>tla   :cd ~/Documents/todo<CR>:PandocTaskListTodo             'project/**/*.md', 'journal/**/*.md'<CR>
autocmd FileType pandoc nnoremap <Leader>tna   :cd ~/Documents/todo<CR>:PandocTaskListTodoSorted       'project/**/*.md', 'journal/**/*.md'<CR>
autocmd FileType pandoc nnoremap <Leader>tnaj  :cd ~/Documents/todo<CR>:PandocTaskListTodoSorted       'project/**/*.md', 'journal/**/*.md'<CR>:cc<CR>
autocmd FileType pandoc nnoremap <Leader>tua   :cd ~/Documents/todo<CR>:PandocTaskListUnfinished       'project/**/*.md', 'journal/**/*.md'<CR>
autocmd FileType pandoc nnoremap <Leader>tuna  :cd ~/Documents/todo<CR>:PandocTaskListUnfinishedSorted 'project/**/*.md', 'journal/**/*.md'<CR>
autocmd FileType pandoc nnoremap <Leader>tunaj :cd ~/Documents/todo<CR>:PandocTaskListUnfinishedSorted 'project/**/*.md', 'journal/**/*.md'<CR>:cc<CR>
autocmd FileType pandoc nnoremap <Leader>tda   :cd ~/Documents/todo<CR>:PandocTaskListDoneSorted       'project/**/*.md', 'journal/**/*.md'<CR>

function! s:new_journal_entry()
    let timestamp_filename = strftime( "~/Documents/todo/journal/%Y-%m-%d_%H-%M-%S.md", localtime() )
    execute "e " . timestamp_filename
endfunction
command! NewJournalEntry call s:new_journal_entry()
autocmd FileType pandoc nnoremap <Leader>nje  :NewJournalEntry<CR>

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
command! -nargs=* CopyDate let @" = s:get_date(<args>)
command! -nargs=* PasteDateAfter let @" = s:get_date(<args>) . ' ' | normal! ""p
command! -nargs=* PasteDateBefore let @" = s:get_date(<args>) . ' ' | normal! ""P

inoremap \ddd <C-o>:PasteDateAfter<CR>
inoremap \dd0 <C-o>:PasteDateAfter 'today'<CR>
inoremap \dd1 <C-o>:PasteDateAfter 'tomorrow'<CR>
inoremap \dd- <C-o>:PasteDateAfter 'tomorrow'<CR>
inoremap \dd2 <C-o>:PasteDateAfter '2 day'<CR>
inoremap \dd= <C-o>:PasteDateAfter '2 day'<CR>
inoremap \dd3 <C-o>:PasteDateAfter '3 day'<CR>
inoremap \dd4 <C-o>:PasteDateAfter '4 day'<CR>
inoremap \ddm <C-o>:PasteDateAfter 'monday'<CR>
inoremap \ddt <C-o>:PasteDateAfter 'tuesday'<CR>
inoremap \ddw <C-o>:PasteDateAfter 'wednesday'<CR>
inoremap \ddr <C-o>:PasteDateAfter 'thursday'<CR>
inoremap \ddf <C-o>:PasteDateAfter 'friday'<CR>
inoremap \dds <C-o>:PasteDateAfter 'saturday'<CR>
inoremap \ddu <C-o>:PasteDateAfter 'sunday'<CR>

nnoremap \ddd :PasteDateBefore<CR>
nnoremap \dd0 :PasteDateBefore 'today'<CR>
nnoremap \dd1 :PasteDateBefore 'tomorrow'<CR>
nnoremap \dd- :PasteDateBefore 'tomorrow'<CR>
nnoremap \dd2 :PasteDateBefore '2 day'<CR>
nnoremap \dd= :PasteDateBefore '2 day'<CR>
nnoremap \dd3 :PasteDateBefore '3 day'<CR>
nnoremap \dd4 :PasteDateBefore '4 day'<CR>
nnoremap \ddm :PasteDateBefore 'monday'<CR>
nnoremap \ddt :PasteDateBefore 'tuesday'<CR>
nnoremap \ddw :PasteDateBefore 'wednesday'<CR>
nnoremap \ddr :PasteDateBefore 'thursday'<CR>
nnoremap \ddf :PasteDateBefore 'friday'<CR>
nnoremap \dds :PasteDateBefore 'saturday'<CR>
nnoremap \ddu :PasteDateBefore 'sunday'<CR>

function! s:todo_quickfix(command_name)
    copen
    cd ~/Documents/todo
    execute a:command_name . " 'project/**/*.md', 'journal/**/*.md'"
    setlocal modifiable
    1,$EasyAlign 4/ /
    setlocal nomodifiable
    setlocal nomodified
endfunction
command! TodoQuickfix call s:todo_quickfix('PandocTaskListTodoSorted')
command! TodoQuickfixAll call s:todo_quickfix('PandocTaskListUnfinishedSorted')
nnoremap <Leader>tq :TodoQuickfix<CR>
nnoremap <Leader>qt :TodoQuickfix<CR>
nnoremap <Leader>tqa :TodoQuickfixAll<CR>
nnoremap <Leader>qta :TodoQuickfixAll<CR>

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
