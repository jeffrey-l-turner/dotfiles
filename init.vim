" Beginning transition to neovim"{{{
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175

" Adapted originally from github.com/gmarik/dotfiles
" General "{{{
set termguicolors              " use true colors
set nocompatible               " be iMproved
scriptencoding utf-8           " utf-8 all the way
set encoding=utf-8

set history=1000                " Number of things to remember in history.
set timeoutlen=250             " Time to wait after ESC (default causes an annoying delay)
set clipboard+=unnamed         " Yanks go on clipboard instead.
set pastetoggle=<F10>          " toggle between paste and normal: for 'safer' pasting from keyboard
set shiftround                 " round indent to multiple of 'shiftwidth'
set tags=.git/tags;$HOME       " consider the repo tags first, then
                               " walk directory tree upto $HOME looking for tags
                               " note `;` sets the stop folder. :h file-search
                               " Tell vim to remember certain things when we exit
                               "  '10  :  marks will be remembered for up to 10 previously edited files
                               "  "100 :  will save up to 100 lines for each register
                               "  :20  :  up to 20 lines of command-line history will be remembered
                               "   %    :  saves and restores the buffer list
                               "   n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.nviminfo

set modeline
set modelines=5                " default numbers of lines to read for modeline instructions

set autowrite                  " Writes on make/shell commands
set autoread                   " In case file is changed externally

set nobackup
set nowritebackup
set directory=/tmp//           " prepend(^=) $HOME/.tmp/ to default path; use full path as backup filename(//)
set noswapfile                 "

set hidden                     " The current buffer can be put to the background without writing to disk

set hlsearch                   " highlight search
"set ignorecase                 " be case insensitive when searching
set smartcase                  " be case sensitive when input has a capital letter
set incsearch                  " show matches while typing

let g:is_posix = 1             " vim's default is archaic bourne shell, bring it up to the 90s
let g:instant_markdown_slow = 1
let mapleader = ','
let maplocalleader = '	'      " Tab as a local leader
let g:netrw_banner = 0         " do not show Netrw help banner
" "}}}

" Formatting "{{{
set fo+=o                      " Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
set fo-=r                      " Do not automatically insert a comment leader after an enter
set fo-=t                      " Do no auto-wrap text using textwidth (does not apply to comments)

set nowrap
"set textwidth=0                " Don't wrap lines by default

set tabstop=4                  " tab size eql 4 spaces
set softtabstop=4
set shiftwidth=4               " default shift width for indents
set expandtab                  " replace tabs with ${tabstop} spaces
set smarttab                   "

set backspace=indent
set backspace+=eol
set backspace+=start

set autoindent
set cindent
set indentkeys-=0#            " do not break indent on #
set cinkeys-=0#
set cinoptions=:s,ps,ts,cs
set cinwords=if,else,while,do
set cinwords+=for,switch,case
" "}}}

" Visual "{{{
syntax on                      " enable syntax

" set synmaxcol=250              " limit syntax highlighting to 128 columns

set mouse=a "enable mouse in GUI mode
set mousehide                 " Hide mouse after chars typed
set showmatch                 " Show matching brackets.
set matchtime=2               " Bracket blinking.

set wildmode=longest,list     " At command line, complete longest common string, then list alternatives.
set wildmenu

set completeopt-=preview      " disable auto opening preview window

set novisualbell              " No blinking
set noerrorbells              " No noise.
set vb t_vb=                  " disable any beeps or flashes on error

set laststatus=2              " always show status line.
set shortmess=atI             " shortens messages
set showcmd                   " display an incomplete command in statusline

set statusline=%<%f\          " custom statusline
set stl+=[%{&ff}]             " show fileformat
set stl+=%y%m%r%=
set stl+=%-14.(%l,%c%V%)\ %P

set foldenable                " Turn on folding
set foldmethod=marker         " Fold on the marker
"set foldmethod=indent        "fold based on indent
"set foldmethod=syntax        "fold based on syntax
set foldlevel=100             " Don't autofold anything (but I can still fold manually)

set foldopen=block,hor,tag    " what movements open folds
set foldopen+=percent,mark
set foldopen+=quickfix

"Vim folding commands:
"  zf#j creates a fold from the cursor down # lines.
"  zf/string creates a fold from the cursor to string .
"  zj moves the cursor to the next fold.
"  zk moves the cursor to the previous fold.
"  zo opens a fold at the cursor.
"  zO opens all folds at the cursor.
"  zm increases the foldlevel by one.
"  zM closes all open folds.
"  zr decreases the foldlevel by one.
"  zR decreases the foldlevel to zero -- all folds will be open.
"  zd deletes the fold at the cursor.
"  zE deletes all folds.
"  [z move to start of open fold.
"  ]z move to end of open fold.
"  Ctrl-P setup

set virtualedit=block

set splitbelow
set splitright

set list                      " display unprintable characters f12 - switches
set listchars=tab:\ ·,eol:¬
set listchars+=trail:·
set listchars+=extends:»,precedes:«
map <silent> <F12> :set invlist<CR>

source ~/.vim/colors/neon-custom.vim
colorscheme neon-custom
if has('gui_running')
  set guioptions=cMg " console dialogs, do not show menu and toolbar

  " Fonts
  " :set guifont=* " to launch a GUI dialog
  if has('mac')
    if has('macligatures')
"     Set font size based on screen size. When vertical height is greater than 900
"     (i.e. an external monitor is attached on 13" or smaller MacBooks), use 18, else use 16.
      if system("osascript -e 'tell application \"Finder\" to get bounds of window of desktop' | cut -d ' ' -f 4") > 900
        set noantialias macligatures guifont=Andale\ Mono:h18 
      else
        set noantialias macligatures guifont=Andale\ Mono:h15 
      endif
    else
      if system("osascript -e 'tell application \"Finder\" to get bounds of window of desktop' | cut -d ' ' -f 4") > 900
        set noantialias guifont=Andale\ Mono:h19 
      else
        set noantialias guifont=Andale\ Mono:h15
      endif
    endif
    " for MacOS Only: Fix Python Path (for YCM)
    let g:ycm_path_to_python_interpreter="/usr/local/bin/python"
    " for MacOS homebrew setup): Dein, etc.
    let g:python_host_prog="/usr/local/bin/python3"
    set fuoptions=maxvert,maxhorz ",background:#00AAaaaa
  else
"    set guifont=Terminus:h16
    set guifont=Consolas:h10
    set lines=123 columns=180
  end
endif
" "}}}

" Key mappings " {{{
" Duplication
nnoremap <leader>c mz"dyy"dp`z
vnoremap <leader>c "dymz"dP`z

" quick nav
nnoremap <leader>rs :source ~/config/nvim/init.vim<
nnoremap <leader>rt :tabnew ~/config/nvim/init.vim>
nnoremap <leader>re :e ~/config/nvim/init.vim>
nnoremap <leader>rd :e ~/.vim/ <CR>
"nnoremap <leader>rc :silent ! cd ~/.vim/ && git commit ~/.vim/vimrc -v <CR>

" Disable Esc: future is inescapeable
"inoremap <Esc> <NOP>
"nnoremap <Esc> <NOP>
" use Ctrl-C or below ones instead
inoremap <leader><localleader> <C-C>
inoremap <leader><leader> <C-C>

" Tabs
nnoremap <M-h> :tabprev<CR>
nnoremap <M-l> :tabnext<CR>

" Buffers
nnoremap <localleader>- :bd<CR>
nnoremap <localleader>-- :bd!<CR>
" Split line(opposite to S-J joining line)
nnoremap <C-J> gEa<CR><ESC>ew

" map <silent> <C-W>v :vnew<CR>
" map <silent> <C-W>s :snew<CR>

" copy filename
map <silent> <leader>. :let @+=expand('%:p').':'.line('.')<CR>
map <silent> <leader>/ :let @+=expand('%:p:h')<CR>
" copy path


map <S-CR> A<CR><ESC>

map <leader>E :Explore<CR>
map <leader>EE :Vexplore!<CR><C-W>=

" toggle search highlighting
"nnoremap <silent> <space> :let &hls=1-&hls<cr>

" " Make Control-direction switch between windows (like C-W h, etc)
" nmap <silent> <C-k> <C-W><C-k>
" nmap <silent> <C-j> <C-W><C-j>
" nmap <silent> <C-h> <C-W><C-h>
" nmap <silent> <C-l> <C-W><C-l>

inoremap <silent> <C-k> <Up>
inoremap <silent> <C-j> <Down>
inoremap <silent> <C-h> <Left>
inoremap <silent> <C-l> <Right>


" vertical paragraph-movement
nmap <C-K> {
nmap <C-J> }

" vertical split with fuzzy-searcher
nnoremap <leader>v :exec ':vnew \| CtrlP'<CR>
" and without
nnoremap <leader>V :vnew<CR>

" when pasting copy pasted text back to 
" buffer instead replacing with owerride
xnoremap p pgvy

if has('mac')

  if has('gui_running')
    set macmeta
  end

" map(range(1,9), 'exec "imap <D-".v:val."> <C-o>".v:val."gt"')
" map(range(1,9), 'exec " map <D-".v:val."> ".v:val."gt"')

" Copy whole line
nnoremap <silent> <D-c> yy

" close/delete buffer when closing window
map <silent> <D-w> :bdelete<CR>
endif

" Control+S and Control+Q are flow-control characters: disable them in your terminal settings.
" $ stty -ixon -ixoff
noremap <C-S> :wa<CR>
vnoremap <C-S> <C-C>:wa<CR>
inoremap <C-S> <C-O>:wa<CR>
"
" generate HTML version current buffer using current color scheme
map <leader>2h :runtime! syntax/2html.vim<CR>

" " }}}

" neovim plugins "{{{
call plug#begin('$HOME/.config/nvim/plugged')
Plug 'w0rp/ale'
"Plug 'https://github.com/wesQ3/vim-windowswap'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Place deoplete before autocomplete-flow
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'wokalski/autocomplete-flow'
"  Need the following for function argument completion:
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install --cache-min Infinity --loglevel http -g tern' }
Plug 'ternjs/tern_for_vim', { 'do': 'npm install --cache-min Infinity --loglevel http' }
Plug 'flowtype/vim-flow'
call plug#end()
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:flow#autoclose = 1
let g:deoplete#enable_at_startup = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
" let g:deoplete#disable_auto_complete = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" " }}}
"
" AutoCommands " {{{
"
au BufRead,BufNewFile {*.go}                                       setl ft=go
au BufRead,BufNewFile {*.coffee}                                   setl ft=coffee tabstop=2 softtabstop=2 expandtab smarttab
au BufRead,BufNewFile {Gemfile,Rakefile,*.rake,config.ru,*.rabl}   setl ft=ruby tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab
au BufRead,BufNewFile {*.local}                                    setl ft=sh
au BufRead,BufNewFile {*.md,*.mkd,*.markdown}                      setl ft=markdown
au BufRead,BufNewFile {*.scala}                                    setl ft=scala
au BufNewFile,BufRead {*.js}                                       setl ft=javascript tabstop=2 softtabstop=2 expandtab smarttab number foldmethod=syntax foldlevelstart=1 foldlevel=99
"au FileType javascript set formatprg=prettier\ --stdin " set formatter to use prettier
"au BufWritePre *.js :normal gggqG " If you want to format on save:
"au BufWritePre *.js exe "normal! gggqG\<C-o>\<C-o> " If you want to restore cursor position on save (can be buggy): 
au User Node if &filetype == "javascript" | setlocal expandtab | endif
au BufNewFile,BufRead {*.ts}                                       setl ft=typescript tabstop=4 softtabstop=4 expandtab smarttab number foldmethod=syntax foldlevelstart=1 foldlevel=99
au BufNewFile,BufRead {*.html}                                     setl ft=html number formatoptions-=c formatoptions-=r formatoptions-=o 
au BufRead,BufNewFile {*.json}                                     setl ft=json formatoptions-=c formatoptions-=r formatoptions-=o 
au BufNewFile,BufRead {*.sh}                                       setl number
au BufWritePost *.sh  :silent make | redraw!                          " run shell check on write to .sh files
au User Node if &filetype == "javascript" | setlocal expandtab | endif " Setup node.vim; see: https://github.com/moll/vim-node
au! BufReadPost       {COMMIT_EDITMSG,*/COMMIT_EDITMSG}            exec 'setl ft=gitcommit noml list spell' | norm 1G
au! BufWritePost      {*.snippet,*.snippets}                       call ReloadAllSnippets()
if has('gui_running')
    au! BufWritePost      {*.ts}                                       setl balloonexpr=tsuquyomi#balloonexpr() "use :TsuGeterr here to get errors in new window
endif
au! bufwritepost init.vim nested source % " automatically reload init.vim on write

au BufWinLeave *.* mkview
au BufWinEnter *.* silent loadview  " use mkview to automatically load cursor position, etc.
" open help in vertical split
" au BufWinEnter {*.txt} if 'help' == &ft | wincmd H | nmap q :q<CR> | endif
" " }}}

let &runtimepath.=',~/.vim/bundle/ale' " to run ale background linting

" Original vimrc to move to neovim "{{{
"source ~/.vimrc
" " }}}
