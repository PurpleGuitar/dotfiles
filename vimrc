" Welcome to Craig's .vimrc file.

" Vundle and plugins
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


Plugin 'gmarik/Vundle.vim'                 " Vundle vundles Vundle
Plugin 'PurpleGuitar/vim-croz-colorscheme' " Craig's color scheme
Plugin 'tpope/vim-sensible'                " Sensible defaults for vim settings
Plugin 'tpope/vim-fugitive'                " Git integration (:GStatus, :GPush, etc.)
Plugin 'tpope/vim-unimpaired'              " Shortcuts, such as ]b (:bnext), ]q (:cnext), an ]e (exchange line)
Plugin 'tomtom/tcomment_vim'               " Sophisticated commenting, e.g. Ctrl-// to comment
Plugin 'guns/xterm-color-table.vim'        " Display a color chart of XTerm color codes
Plugin 'vim-voom/VOoM'                     " Outliner for use with e.g. Pandoc/Markdown text files
Plugin 'tmux-plugins/vim-tmux'             " Syntax support for tmux files
Plugin 'pangloss/vim-javascript'           " Syntax handler for JavaScript
Plugin 'elzr/vim-json'                     " Syntax handling for JSON
Plugin 'nblock/vim-dokuwiki'               " Syntax highlighting for Dokuwiki text files
Plugin 'Raimondi/delimitMate'              " Automatically close quote, parens, brackets, etc.
Plugin 'tommcdo/vim-exchange'              " Exchange chunks of text
Plugin 'kshenoy/vim-signature'             " Show marks in gutter
Plugin 'tpope/vim-speeddating'             " Increment/decrement dates
Plugin 'kergoth/vim-hilinks'               " Show highlighting at the cursor


Plugin 'junegunn/vim-easy-align'                 " Line up columns of text
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" Automatic code linting for Python, JS, Java, etc.
Plugin 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0


" Pretty Powerline statusbar
Plugin 'vim-airline/vim-airline.git'
Plugin 'vim-airline/vim-airline-themes.git'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_powerline_fonts = 1


" Show adds, dels, mods in gutter
Plugin 'airblade/vim-gitgutter'
let g:gitgutter_sign_column_always = 1
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk


" Support for Pandoc documents
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'
let g:pandoc#formatting#mode = 'h'                               " hard line breaks
let g:pandoc#keyboard#sections#header_style = 's'                " Use setext style headers for 1 and 2
let g:pandoc#formatting#textwidth = 75                           " Text width for Pandoc documents
let g:pandoc#folding#level=999                                   " Don't initally fold docs
let g:pandoc#syntax#conceal#blacklist = ["emdashes", "endashes"] " Don't show dashes (they're invisible)
let g:pandoc#folding#fdc = 0                                     " Don't show foldlevel column
let g:pandoc#formatting#equalprg='pandoc -t markdown-shortcut_reference_links --reference-links --standalone --columns 75'

function! PandocIndentOnWrite()
    if &ft == 'pandoc'
        let save_cursor = getpos('.')
        normal! H
        let save_window = getpos('.')
        :normal! gg=G
        call setpos('.', save_window)
        normal! zt
        call setpos('.', save_cursor)
    endif
endfunction
autocmd BufWritePre * call PandocIndentOnWrite()

" Use tab to jump to next link
autocmd FileType pandoc nnoremap <Tab> /\[[^]]\+\][[(]<CR>:nohlsearch<CR>
autocmd FileType pandoc nnoremap <S-Tab> ?\[[^]]\+\][[(]<CR>:nohlsearch<CR>

" Remap goto definition to goto link
autocmd FileType pandoc nmap gd <Leader>gl

" Insert journal entry at bottom of file
nnoremap <Leader>je Go<CR><C-o>0### <Esc>"=strftime("%a %b %d %Y %I:%M %p")<CR>po<CR>
inoremap <Leader>je <Esc>Go<CR><C-o>0### <Esc>"=strftime("%a %b %d %Y %I:%M %p")<CR>po<CR>


" NERDTree file browser
Plugin 'scrooloose/nerdtree'
nnoremap <Leader>nt :NERDTreeFind<CR>

" From: http://superuser.com/questions/195022/vim-how-to-synchronize-nerdtree-with-current-opened-tab-file-path
" returns true iff is NERDTree open/active
function! s:isNTOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! s:syncTree()
  if &modifiable && s:isNTOpen() && strlen(expand('%')) > 0 && !&diff
    let l:curwinnr = winnr()
    NERDTreeFind
    exec l:curwinnr . "wincmd w"
    "wincmd p
  endif
endfunction

autocmd BufEnter * call s:syncTree()

" Highlights targets for f, F, t, and T motions
Plugin 'unblevable/quick-scope'
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']


" Navigate undo tree
Plugin 'sjl/gundo.vim'
nnoremap <Leader>gu :GundoToggle<CR>

" Gui options
set guioptions=

" Task management in Pandoc
Plugin  'PurpleGuitar/vim-pandoc-tasks'
autocmd FileType pandoc nnoremap <Leader>tx  :PandocTaskDelete<CR>
autocmd FileType pandoc vnoremap <Leader>tx  :PandocTaskDelete<CR>gv
autocmd FileType pandoc nnoremap <NUL>       :PandocTaskToggle<CR>
autocmd FileType pandoc vnoremap <NUL>       :PandocTaskToggle<CR>gv
autocmd FileType pandoc nnoremap <C-Space>   :PandocTaskToggle<CR>
autocmd FileType pandoc vnoremap <C-Space>   :PandocTaskToggle<CR>gv
autocmd FileType pandoc nnoremap <Leader>tl  :PandocTaskListTodo<CR>
autocmd FileType pandoc nnoremap <Leader>tlj :PandocTaskListTodo<CR>:cc<CR>
autocmd FileType pandoc nnoremap <Leader>tn  :PandocTaskListTodoSorted<CR>
autocmd FileType pandoc nnoremap <Leader>tnj :PandocTaskListTodoSorted<CR>:cc<CR>
autocmd FileType pandoc nnoremap <Leader>tu  :PandocTaskListUnfinished<CR>
autocmd FileType pandoc nnoremap <Leader>tun :PandocTaskListUnfinishedSorted<CR>
autocmd FileType pandoc nnoremap <Leader>td  :PandocTaskListDoneSorted<CR>
autocmd FileType pandoc nnoremap <Leader>pp  :Pandoc  html --standalone<CR>
autocmd FileType pandoc nnoremap <Leader>pb  :Pandoc! html --standalone<CR>

" Finish with Vundle
call vundle#end()
filetype plugin indent on


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
autocmd FileType pandoc nnoremap j gj
autocmd FileType pandoc nnoremap k gk

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
    let timestamp_filename = strftime( "~/Documents/todo/journal/%Y-%m-%d_%H%M%S.md", localtime() )
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

function! s:todo_quickfix()
    copen
    cd ~/Documents/todo
    PandocTaskListUnfinishedSorted 'project/**/*.md', 'journal/**/*.md'
    setlocal modifiable
    1,$EasyAlign 4/ /
    setlocal nomodifiable
    setlocal nomodified
endfunction
command! TodoQuickfix call s:todo_quickfix()
nnoremap <Leader>tq :TodoQuickfix<CR>
nnoremap <Leader>qt :TodoQuickfix<CR>

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
