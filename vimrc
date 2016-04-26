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
Plugin 'godlygeek/tabular'                 " Line up columns of text
Plugin 'vim-voom/VOoM'                     " Outliner for use with e.g. Pandoc/Markdown text files
Plugin 'tmux-plugins/vim-tmux'             " Syntax support for tmux files
Plugin 'pangloss/vim-javascript'           " Syntax handler for JavaScript
Plugin 'elzr/vim-json'                     " Syntax handling for JSON
Plugin 'nblock/vim-dokuwiki'               " Syntax highlighting for Dokuwiki text files
Plugin 'Raimondi/delimitMate'              " Automatically close quote, parens, brackets, etc.
Plugin 'tommcdo/vim-exchange'              " Exchange chunks of text
Plugin 'kshenoy/vim-signature'             " Show marks in gutter


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
Plugin 'bling/vim-airline.git'
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
let g:pandoc#formatting#mode = 'h'                " hard line breaks
let g:pandoc#keyboard#sections#header_style = 's' " Use setext style headers for 1 and 2
let g:pandoc#formatting#textwidth = 75            " Text width for Pandoc documents
let g:pandoc#folding#level=999                    " Don't initally fold docs
" nnoremap <Leader>pp :!pandoc --standalone --smart --css style.css % --output %.html<CR>
" nmap <Leader>pb <Leader>pp<CR>:!midori %.html &<CR>
" nmap <Leader>pr <Leader>pp<CR>:!midori --execute Reload<CR>


" NERDTree file browser
Plugin 'scrooloose/nerdtree'
nnoremap <Leader>nt :NERDTreeFind<CR>


" Highlights targets for f, F, t, and T motions
Plugin 'unblevable/quick-scope'
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']


" Navigate undo tree
Plugin 'sjl/gundo.vim'
nnoremap <Leader>gu :GundoToggle<CR>


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

" Use \hlt to reveal the highlighting under the cursor.  Thanks to:
" http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
nnoremap <Leader>hlt :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>

" Fixup whitespace, ASCII
nnoremap <Leader>fix<Space> :%s/\s\+$//<CR>
nnoremap <Leader>fix' :%s/’/'/g<CR>
nnoremap <Leader>fix" :%s/[“”]/"/g<CR>

" Search for visually selected text with //
vnoremap // y/<C-R>"<CR>

" Handle line movement
nnoremap j gj
nnoremap k gk

" Window shortcuts
nmap <C-w>- <C-w>s
nmap <C-w>\ <C-w>v

" Alt-up and Alt-down to move lines around
" (This mimics the excellent S-A-Up and Down on OneNote)
nmap <Esc><Up> [e
nmap <Esc><Down> ]e


" Import local .vimrc, if there is one
" ========================================================================
if !empty(glob("~/.vimrc-local"))
    source ~/.vimrc-local
endif


" Finish with Vundle (putting this at the end allows the local .vimrc
" to load plugins if it wishes.)
call vundle#end()
filetype plugin indent on


" Load my colorscheme if available
" Must be called after vundle#end()
silent! colorscheme croz
