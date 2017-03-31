" Adapted originally from github.com/gmarik/dotfiles
" General "{{{
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
if has("win32") || has("win16")
    set viminfo='10,\"100,:20,%,nc:~/vimfiles/.viminfo 
else
    set viminfo='10,\"100,:20,%,n~/.viminfo
endif

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

colorscheme neon-custom
if has('gui_running')
  set guioptions=cMg " console dialogs, do not show menu and toolbar

  " Fonts
  " :set guifont=* " to launch a GUI dialog
  if has('mac')
    if has('macligatures')
      set antialias macligatures guifont=Fira\ Code\ Light:h13 " -> <=
    else
      set noantialias guifont=Andale\ Mono:h14
    end
  set fuoptions=maxvert,maxhorz ",background:#00AAaaaa
  else
"    set guifont=Terminus:h16
    set guifont=Consolas:h9
    set lines=123 columns=180
  end
endif
" "}}}

" Key mappings " {{{
" Duplication
nnoremap <leader>c mz"dyy"dp`z
vnoremap <leader>c "dymz"dP`z

" quick nav
nnoremap <leader>rs :source ~/.vimrc<CR>
nnoremap <leader>rt :tabnew ~/.vim/vimrc<CR>
nnoremap <leader>re :e ~/.vim/vimrc<CR>
nnoremap <leader>rd :e ~/.vim/ <CR>
nnoremap <leader>rc :silent ! cd ~/.vim/ && git commit ~/.vim/vimrc -v <CR>

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

" AutoCommands " {{{
"
au BufRead,BufNewFile {*.go}                                       setl ft=go
au BufRead,BufNewFile {*.coffee}                                   setl ft=coffee tabstop=2 softtabstop=2 expandtab smarttab
au BufRead,BufNewFile {Gemfile,Rakefile,*.rake,config.ru,*.rabl}   setl ft=ruby tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab
au BufRead,BufNewFile {*.local}                                    setl ft=sh
au BufRead,BufNewFile {*.md,*.mkd,*.markdown}                      setl ft=markdown
au BufRead,BufNewFile {*.scala}                                    setl ft=scala
au BufNewFile,BufRead {*.js}                                       setl ft=javascript tabstop=4 softtabstop=4 expandtab smarttab number foldmethod=syntax foldlevelstart=1 foldlevel=99
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
au! bufwritepost .vimrc nested source % " automatically reload .vimrc on write

au BufWinLeave *.* mkview
au BufWinEnter *.* silent loadview  " use mkview to automatically load cursor position, etc.
" open help in vertical split
" au BufWinEnter {*.txt} if 'help' == &ft | wincmd H | nmap q :q<CR> | endif
" " }}}

" Scripts and Plugins " {{{
" DEIN installation (for tsuquyomi, etc.)

" Required:
if has("win32") || has("win16")
    " for the 'hostile' developer environment...
    set runtimepath+=~/vimfiles/bundle/dein.vim
else
    set runtimepath+=~/.vim/bundle/dein.vim
    if dein#load_state('~/vimfiles/bundle/dein.vim')
    "  call dein#begin('/home/User/employees/culver_city/jturner/.vim/bundle/')
    " 
    "   " Let dein manage dein
    "   " Required:
    "   call dein#add('~/vimfiles/bundle/')
    " 
    "   " Add or remove your plugins here:
    "   call dein#add('Shougo/neosnippet.vim')
    "   call dein#add('Shougo/neosnippet-snippets')
    " 
    "   " You can specify revision/branch/tag.
    "   call dein#add('Shougo/vimshell', { 'rev': '3787e5' })
    " 
    "  call dein#end()
    "  call dein#save_state()
    endif
    " If you want to install not installed plugins on startup.
    "if dein#check_install()
       call dein#install()
    "endif
endif

" Required:
filetype plugin indent on
syntax enable


filetype off
runtime macros/matchit.vim
if has("win32") || has("win16")
    set rtp+=~/vimfiles/bundle/snipmate.snippets/
    set rtp+=~/vimfiles/bundle/vundle/
else
    set rtp+=~/.vim/bundle/snipmate.snippets/
    set rtp+=~/.vim/bundle/vundle/
endif
call vundle#rc()

colorscheme neon-custom
if has("gui_running")
"  colorscheme ingretu
"  colorscheme blue
"  colorscheme candy
   colorscheme neon-custom
endif

" Programming
Plugin 'majutsushi/tagbar'
Plugin 'othree/javascript-libraries-syntax.vim.git'
Plugin 'othree/html5.vim'
Plugin 'git@github.com:vim-scripts/SyntaxComplete.git'
Plugin 'git@github.com:vimplugin/project.vim.git'
Plugin 'vim-syntastic/syntastic'
Plugin 'Quramy/tsuquyomi'
Plugin 'leafgarland/typescript-vim'
Plugin 'groenewege/vim-less'
Plugin 'elzr/vim-json'
Plugin 'editorconfig/editorconfig-vim'

execute pathogen#infect()
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']      " want only eslint
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi']
"let g:syntastic_json_checkers=['jsonlint']
let g:flow#autoclose=1
let g:flow#enable=0

" Python
Plugin 'davidhalter/jedi-vim'
Plugin 'klen/python-mode'
let g:pymode_lint = 0

" Golang
Plugin 'fatih/vim-go'
" unlike gofmt also adds/removes imports
let g:go_fmt_command = 'gofmt'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_build_constraints = 1

" TypeScript
":TsuquyomiStartServer " starts server for TSC checking

augroup go
" clear everything
autocmd!

" set visuals
au BufRead,BufNewFile go setl tabstop=2 softtabstop=2 noexpandtab smarttab
" TODO: not working
au BufWritePost go if get(g:,'auto_test') | exec ':GoTest'<CR> | endif

" bindings
au FileType go nmap <localleader>t :GoTest<CR>
au FileType go nmap <localleader>tf :GoTestFunc<CR>
au FileType go nmap <localleader>r :GoRun<CR>
au FileType go nmap <localleader>e :GoErrCheck<CR>
au FileType go nmap <localleader>v :GoVet<CR>
au FileType go nmap <localleader>l :GoLint<CR>
au FileType go nmap <localleader>ll :GoMetaLinter<CR>
au FileType go nmap <localleader>i :GoImports<CR>
au FileType go nmap <localleader>d :GoDecls<CR>
au FileType go nmap <localleader>dd :GoDeclsDir<CR>

au FileType go nmap <localleader>gr :exec ':CtrlP '.system('go env GOROOT')[:-2].'/src/'<CR>
au FileType go nmap <localleader>gp :exec ':CtrlP '.system('go env GOPATH')[:-2].'/src/'<CR>

" commands
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AT GoAutoTypeInfoToggle<bang> <args>
autocmd Filetype go command! -bang TT let g:auto_test = 1 - get(g:, 'auto_test')

augroup END

" goes to the definition under cursor in a new split
" TODO: doesn't work
"nnoremap <C-W>gd <C-W>^zz


" HDL
Plugin 'suoto/vim-hdl'

" Scala
Plugin 'derekwyatt/vim-scala'

" Ruby/Rails
Plugin 'tpope/vim-rails'

" Js
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'

" Snippets
Plugin 'gmarik/snipmate.vim'

if has("win32") || has("win16")
    nnoremap <leader>so :Explore ~/vimfiles/vendor/snipmate.snippets/snippets/<CR>
else
    nnoremap <leader>so :Explore ~/.vim/vendor/snipmate.snippets/snippets/<CR>
endif

" Syntax highlight
Plugin 'gmarik/vim-markdown'
Plugin 'timcharper/textile.vim'

" Git integration
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-fugitive'
Plugin 'junegunn/gv.vim'

nnoremap <leader>W :Gwrite<CR>
nnoremap <leader>C :Gcommit -v<CR>
nnoremap <leader>S :Gstatus \| 7<CR>
inoremap <leader>W <Esc><leader>W
inoremap <leader>C <Esc><leader>C
inoremap <leader>S <Esc><leader>S

Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'

" bubble current line
nmap <M-j> ]e
nmap <M-k> [e
" bubble visual selection lines
vmap <M-j> ]egv
vmap <M-k> [egv

" Utility
Plugin 'AndrewRadev/splitjoin.vim'
nmap sj :SplitjoinJoin<cr>
nmap sk :SplitjoinSplit<cr>

Plugin 'gmarik/github-search.vim'

Plugin 'gmarik/ide-popup.vim'
Plugin 'gmarik/sudo-gui.vim'

Plugin 'sjl/gundo.vim'
nnoremap <F5> :GundoToggle
" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && !isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

Plugin 'mkitt/browser-refresh.vim'
com! ONRRB :au! BufWritePost <buffer> :RRB
com! NORRB :au! BufWritePost <buffer>


Plugin 'bogado/file-line'
Plugin 'junegunn/vim-easy-align'
Plugin 'vim-scripts/lastpos.vim'

Plugin 'Lokaltog/vim-easymotion'
let g:EasyMotion_leader_key='<LocalLeader><LocalLeader>'

Plugin 'ZoomWin'
noremap <leader>o :ZoomWin<CR>
vnoremap <leader>o <C-C>:ZoomWin<CR>
inoremap <leader>o <C-O>:ZoomWin<CR>

Plugin 'tomtom/tlib_vim'
Plugin 'tomtom/tcomment_vim'
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

Plugin 'gmarik/hlmatch.vim'
nnoremap # :<C-u>HlmCword<CR>
nnoremap <leader># :<C-u>HlmGrepCword<CR>
vnoremap # :<C-u>HlmVSel<CR>
vnoremap <leader># :<C-u>HlmGrepVSel<CR>

nnoremap ## :<C-u>HlmPartCword<CR>
nnoremap <leader>## :<C-u>HlmPartGrepCword<CR>
vnoremap ## :<C-u>HlmPartVSel<CR>
vnoremap <leader>## :<C-u>HlmPartGrepVSel<CR>

Plugin 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<leader>t'
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'
let g:ctrlp_extensions = ['tag', 'buffertag', 'dir', 'rtscript',
                          \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']

nnoremap <leader>0  :CtrlPClearAllCaches<CR>
nnoremap <leader>`  :CtrlPUndo<CR>
nnoremap <leader>1  :CtrlPTag<CR>
nnoremap <leader>2  :exec ':CtrlP '.expand('%:h:p')<CR>
nnoremap <leader>22 :CtrlP<CR>
nnoremap <leader>3  :CtrlPBuffer<CR>
nnoremap <leader>4  :exec 'CtrlPDir '.expand('%:h:p')<CR>
nnoremap <leader>44 :CtrlPDir<CR>
nnoremap <leader>6  :CtrlPMRU<CR>
nnoremap <leader>7  :CtrlPLine<CR>
nnoremap <leader>8  :CtrlPChange<CR>
nnoremap <leader>h  :CtrlPRTS<CR>


Plugin 'rstacruz/sparkup.git', {'rtp': 'vim/'}
let g:sparkupExecuteMapping = '<c-e>'
let g:sparkupNextMapping = '<c-ee>'

filetype plugin indent on      " Automatically detect file types.

" }}}

" Original .vimrc " {{{
"
" ...
"Bundle 'flazz/vim-colorschemes'
" trying pangloss instead of:
"Bundle 'jelera/vim-javascript-syntax'
"Bundle "pangloss/vim-javascript"
"Bundle 'groenewege/vim-less'
"Bundle "burnettk/vim-angular"
"Bundle "moll/vim-node"
" Colorized indentation <leader>ig or \ig to enable
"Bundle "nathanaelkane/vim-indent-guides"

"let g:indent_guides_start_level=1
"let g:indent_guides_guide_size=1
" Omni-competion for environments I typically use:
" To use, type <C-X><C-O> while open in Insert mode. If
" matching names are found, a pop-up menu opens which can be navigated using
" the <C-N> and <C-P> keys.
"
"*css lint checkers
" to use scss-lint, ruby and its gem must be installed: `ruby install scss_lint`
"let g:syntastic_scss_checkers = ['scss_lint']
"let g:CSSLint_FileTypeList = ['css', 'less', 'sess']
" Setup tidy rules:
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
" see :h vundle for more details or wiki for FAQ
" Note: comments after Plugin commands are not allowed.
":set hlsearch 
":set runtimepath^=~/.vim/bundle/ctrlp.vim "ctrl-p plugin helps find files for angular (and others)
":set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
":set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
"Enable the sass_lint checker 
"let g:syntastic_sass_checkers=["sass_lint"]
"let g:syntastic_scss_checkers=["sass_lint"]
"change below : to " or vice versa to stop autoformatting of comments when copying pasting code snipppets into vim
" make and restore views automatically
" run shell check on write to .sh files
":autocmd BufWritePost *.sh  :silent make | redraw!
" Setup node.vim; see: https://github.com/moll/vim-node
"autocmd User Node if &filetype == "javascript" | setlocal expandtab | endif
":set ruler
":syntax on
":set t_Co=256
":set background=dark
"
"map <F2> :mksession! ~/.vim_session <cr> " Quick write session with F2
"map <F3> :source ~/.vim_session <cr>     " And load session with F3
"
" for gvim/mvim:
"
"
" " }}}
