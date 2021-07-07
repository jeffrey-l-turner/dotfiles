"Beginning transition to neovim"{{{
"         ,--.
"       ,--.'|                                                 ____       ,--,                              ____  ,-.----.
"   ,--,:  : |                                ,--,           ,'  , `.    / .`|      ,---.  ,--,           ,'  , `.\    /  \
",`--.'`|  ' :             ,---.            ,--.'|        ,-+-,.' _ |   /' / ;     /__./|,--.'|        ,-+-,.' _ |;   :    \
"|   :  :  | |            '   ,'\      .---.|  |,      ,-+-. ;   , ||  /  / .',---.;  ; ||  |,      ,-+-. ;   , |||   | .\ :
":   |   \ | :   ,---.   /   /   |   /.  ./|`--'_     ,--.'|'   |  || /  / .//___/ \  | |`--'_     ,--.'|'   |  ||.   : |: |
"|   : '  '; |  /     \ .   ; ,. : .-' . ' |,' ,'|   |   |  ,', |  |,/ ./  / \   ;  \ ' |,' ,'|   |   |  ,', |  |,|   |  \ :
"'   ' ;.    ; /    /  |'   | |: :/___/ \: |'  | |   |   | /  | |--'/  /  /   \   \  \: |'  | |   |   | /  | |--' |   : .  /
"|   | | \   |.    ' / |'   | .; :.   \  ' .|  | :   |   : |  | ,  /  /  /     ;   \  ' .|  | :   |   : |  | ,    ;   | |  \
"'   : |  ; .''   ;   /||   :    | \   \   ''  : |__ |   : |  |/  ;  /  /       \   \   ''  : |__ |   : |  |/     |   | ;\  \
"|   | '`--'  '   |  / | \   \  /   \   \   |  | '.'||   | |`-' ./__;  /         \   `  ;|  | '.'||   | |`-'      :   ' | \.'
"'   : |      |   :    |  `----'     \   \ |;  :    ;|   ;/     |   : /           :   \ |;  :    ;|   ;/          :   : :-'
";   |.'       \   \  /               '---" |  ,   / '---'      ;   |/             '---" |  ,   / '---'           |   |.'
"'---'          `----'                       ---`-'             `---'                     ---`-'                  `---'
"
" Author: Jeff Turner
" repo  : https://github.com/jeffrey-l-turner/dotfiles/
" For use with Neovim/VimR:
" See: https://github.com/qvacua/vimr/releases
" Place in ~/.config/nvim/init.vim
"  ```sh
"  $ brew install python python3
"  $ pip2 install neovim --uprgrade
"  $ pip3 install vim-vint pynvim jedi autopep8 yapf flake8 # install globally for linting
"  $ brew install neovim
"  $ curl --create-dirs -fLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  $ curl --create-dirs -fLo "${HOME}/.vim/colors/neon-custom.vim" https://raw.githubusercontent.com/jeffrey-l-turner/dotfiles/master/neon-custom.vim # custom neon=vim color scheme
"  $ npm install -g fixjson
"  ```
"  # if you have problems with Deoplete not finding python run:
"  ```
"  inside neovim:
"  :checkhealth provider
"  :CocInstall coc-tsserver coc-tailwindcss " to install type server for Typescript & tailwind setup
"  :CocInstall coc-deno " use only for deno setup -> disabled due to: https://medium.com/@jimgbest/fixing-coc-tsserver-errors-due-to-deno-59551d65bde7 
"  :CocCommand deno.types " do while editing .ts file, for deno types setup
" -> deprecated: :checkhealth deoplete " deoplete and coc seem to conflict, using Coc with deno now; currently switching between Deopolete for JS & CoC for TS
"  may need to edit ~/.viminfo file to save cursor position & set nu/nonu state saving
"  ```
" Remember to :PlugInstall " after first starting neovim
"
" Note: This looks best with Powerline fonts
" I favor .editorconfig over prettier setups. This config only uses prettier for Typescript
"
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175

" Loosely based from github.com/gmarik/dotfiles
" "}}}
"
" General "{{{
"set nocompatible               " be iMproved
set encoding=utf-8
scriptencoding utf-8           " utf-8 all the way

set history=1000               " Number of things to remember in history.
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
set autoread                   " works better than just a plain set autoread
set t_BE= " turns off bracketed paste mode
augroup focus
  au FocusGained * :checktime
augroup end

set nobackup
set nowritebackup
set directory=/tmp//           " prepend(^=) $HOME/.tmp/ to default path; use full path as backup filename(//)
set noswapfile                 "
set showcmd                    " see leader press

set hidden                     " The current buffer can be put to the background without writing to disk

set hlsearch                   " highlight search
"set ignorecase                 " be case insensitive when searching
set smartcase                  " be case sensitive when input has a capital letter
set incsearch                  " show matches while typing

let g:is_posix = 1             " vim's default is archaic bourne shell, bring it up to the 90s
let g:instant_markdown_slow = 1
let g:mapleader = ','
let g:netrw_banner = 0         " do not show Netrw help banner
" "}}}

" Formatting "{{{
set formatoptions+=o                      " Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
set formatoptions-=r                      " Do not automatically insert a comment leader after an enter
set formatoptions-=t                      " Do no auto-wrap text using textwidth (does not apply to comments)

set nowrap
"set textwidth=0                " Don't wrap lines by default

set tabstop=2                  " tab size eql 4 spaces
set softtabstop=2
set shiftwidth=2               " default shift width for indents
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
" Set up English Spellchecking
set spelllang=en
setlocal spell
" "}}}

" Visual "{{{
syntax on                      " enable syntax

" set synmaxcol=250              " limit syntax highlighting to 128 columns

set mouse=a                   " enable mouse in GUI mode
set mousehide                 " Hide mouse after chars typed
set showmatch                 " Show matching brackets.
set matchtime=2               " Bracket blinking.

set wildmode=longest,list     " At command line, complete longest common string, then list alternatives.
set wildmenu
set wildignore+=*.o,*/lib/python*/*,*.pyc,*/node_modules/*,/.git/*,*/build/*,*/dist/*,npm-debug.log,yarn-error.log,.buckd,*.keystore " wild card ignore

set completeopt-=preview      " disable auto opening preview window

set novisualbell              " No blinking
set noerrorbells              " No noise.

set laststatus=2              " always show status line.
set shortmess=atI             " shortens messages
set showcmd                   " display an incomplete command in statusline

set statusline=%<%f\          " custom statusline
set statusline+=[%{&ff}]      " show fileformat
set statusline+=%y%m%r%=
set statusline+=%-14.(%l,%c%V%)\ %P

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
  set termguicolors              " use true colors
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
        if !has('gui_running')
          set noantialias guifont=Andale\ Mono:h19
        endif
      else
        if !has('gui_running')
          set noantialias guifont=Andale\ Mono:h15
        endif
      endif
    endif
    " for MacOS Only: Fix Python Path (for YCM)
    let g:ycm_path_to_python_interpreter='/usr/local/bin/python'
    " for MacOS homebrew setup): Dein, etc.
    let g:python_host_prog='/usr/local/bin/python3'
    if !has('gui_running')
      set fuoptions=maxvert,maxhorz ",background:#00AAaaaa
    endif
  else
    "    set guifont=Terminus:h16
    set guifont=Consolas:h10
    set lines=123 columns=180
  end
else
  if has('mac')
    let terminal=$TERM_PROGRAM
    if terminal ==# 'iTerm.app'
      set termguicolors              " disable term gui in terminal
    else
      " if Apple_Terminal
      set notermguicolors              " disable term gui in terminal
    endif
  endif
endif
" "}}}

" Key mappings " {{{
" Duplication
nnoremap <eeader>c mz"dyy"dp`z
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
" xnoremap p pgvy

if has('mac')
  " map(range(1,9), 'exec "imap <D-".v:val."> <C-o>".v:val."gt"')
  " map(range(1,9), 'exec " map <D-".v:val."> ".v:val."gt"')

  " Copy whole line
  nnoremap <silent> <D-c> yy

  " close/delete buffer when closing window
  map <silent> <D-w> :bdelete<CR>
endif

" improve vim-fugitive grep with quickfix
command! -nargs=+ Ggr execute 'silent Ggrep!' <q-args> | cw | redraw!
" Control+S and Control+Q are flow-control characters: disable them in your terminal settings.
" $ stty -ixon -ixoff
noremap <C-S> :wa<CR>
vnoremap <C-S> <C-C>:wa<CR>
inoremap <C-S> <C-O>:wa<CR>
" ToggleBlame
function! s:ToggleBlame()
  if &l:filetype ==# 'fugitiveblame'
    close
  else
    Gblame
  endif
endfunction

nnoremap gb :call <SID>s:ToggleBlame()<CR>
"
" generate HTML version current buffer using current color scheme
map <leader>2h :runtime! syntax/2html.vim<CR>
" close terminal on clean exit
augroup terminal
  autocmd!
  autocmd TermClose * if getline('$') ==# 'Exit 0' | close | endif
augroup end
" " }}}

" ale config "{{{
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters = {'css': ['stylelint'], 'jsx': ['stylelint', 'eslint'], 'javascript': ['eslint', 'flow'], 'typescript': ['tslint'], 'python': ['flake8']}
let g:ale_javascript_prettier_options = '--jsx-bracket-same-line --single-quote --print-width 150 --trailing-comma all'
" let g:ale_linters = {'css': ['stylelint'], 'jsx': ['stylelint', 'eslint'], 'javascript': ['eslint', 'flow'], 'python': ['flake8']}
let g:ale_fixers = {'javascript': ['eslint'], 'typescript': ['tslint', 'prettier'],'typescriptreact': ['tslint', 'eslint', 'prettier'], 'python': ['autopep8', 'yapf'], 'json': ['fixjson']}
let g:ale_fix_on_save = 1
let g:ale_type_map = {'flow': {'E': 'I', 'W': 'I'}}
let g:ale_disable_lsp = 1

let g:flow#autoclose = 1
" let g:deoplete#enable_at_startup = 1
" if !exists('g:deoplete#omni#input_patterns') " no longer exists, says use deoplete#custom#var() instead
"  let g:deoplete#omni#input_patterns = {}
"endif
" let g:deoplete#disable_auto_complete = 1
augroup ale
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end
" " }}}

" neovim plugins "{{{
call plug#begin('$HOME/.config/nvim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'w0rp/ale'
" typescript
Plug 'quramy/tsuquyomi'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'majutsushi/tagbar'
let g:tagbar_type_javascript = {
      \ 'ctagstype': 'javascript',
      \ 'kinds': [
      \ 'c:classes',
      \ 'n:modules',
      \ 'f:functions',
      \ 'v:variables',
      \ 'v:varlambdas',
      \ 'm:members',
      \ 'i:interfaces',
      \ 'e:enums',
      \ ]
      \ }

Plug 'tpope/vim-commentary'
"nmap <C-m> gcc
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " seems to conflict with Coc
" Place deoplete before autocomplete-flow
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'wokalski/autocomplete-flow'
"Plug 'steelsojka/deoplete-flow' " this one may not be as good; trying this out for now autocomplet-flow, above
"  Need the following for function argument completion:
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/denite.nvim'
" Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install --cache-min Infinity --loglevel http -g tern tern-jsx tern-react' }
Plug 'ternjs/tern_for_vim', { 'do': 'npm install --cache-min Infinity --loglevel http' }
Plug 'ludovicchabant/vim-gutentags' "c-tags plugin <C-j> definition
Plug 'MaxMEllon/vim-jsx-pretty'  "jsx syntax highlight, incl .js files
Plug 'ianks/vim-tsx' " for .tsx files only
Plug 'mxw/vim-jsx'  "jsx syntax highlight, incl .js files
Plug 'vim-airline/vim-airline' " Nice colorful status line
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter' " git compat gutter
Plug 'tomlion/vim-solidity'   " solidity programming support
Plug 'ap/vim-css-color' " color highlighting for css
"Plug 'sheerun/vim-polyglot' " disabling due to problems with coc
Plug 'tpope/vim-liquid' " liquid files for shopify
Plug 'junegunn/fzf', { 'dir': '~/.fzf/', 'do': './install --bin ' } "
Plug 'junegunn/fzf.vim' " fuzzy finder
Plug 'LnL7/vim-nix' " for editing nix files
Plug 'tpope/vim-fugitive' " only using for airline integration, ctags no longer supported
Plug 'neoclide/coc.nvim', {'branch': 'release'} " had performance issues before, not problems w/curr release
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'leafgarland/typescript-vim' " Typescript syntax highlighting
Plug 'vim-utils/vim-man' " initial testing
Plug 'mbbill/undotree' " initial testing
"Plug 'vim-ctrlspace/vim-ctrlspace' " testing airline integration
"Plug 'pangloss/vim-javascript' " bundled language plugin
"Plug 'flowtype/vim-flow' " json or string format appears to be incorrectly returned with neovim
Plug 'neovimhaskell/haskell-vim' " better Haskell highlighting/indentation
Plug 'purescript-contrib/purescript-vim' " better Haskell highlighting/indentation
"Plug 'wfleming/vim-codeclimate' "  for Code Climate setup -- not a good plugin
"Plug 'jparise/vim-graphql' "  for graphql file detection, syntax highlighting, etc.
Plug 'wincent/ferret' " trying for a few weeks
Plug 'tpope/vim-dispatch' " req'd for ferret
Plug 'statico/vim-javascript-sql' " supposedly experimental
Plug 'nvie/vim-flake8' " lint integration for Python
"Plug 'yegappan/grep' " req'd for ferret - not working b/c of jobs_ diff in newovim
Plug 'makerj/vim-pdf'  " requires pdf to text
Plug 'liuchengxu/vim-clap' " trying for now
Plug 'zchee/deoplete-jedi' " python jedi plugin
Plug 'liuchengxu/vim-clap'
Plug 'mhinz/vim-startify'
" Plug 'mattn/emmet-vim' " trying
call plug#end()
" " }}}

" coc setup "{{{
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

fun! GoCoc()
  inoremap <buffer> <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <buffer> <expr><S-TAB> pumvisible() ? "\C-p>" : "\<C-h>"
  inoremap <buffer> <silent><expr> <C-space> coc#refresh()

  " GoTo code navigation
  nmap <buffer> <leader>gd <Plug>(coc-definition)
  nmap <buffer> <leader>gy <Plug>(coc-type-definition)
  nmap <buffer> <leader>gi <Plug>(coc-implementation)
  nmap <buffer> <leader>gr <Plug>(coc-references)
  nnoremap <buffer> <leader>cr :CocRestart
endfunction
let g:coc_global_extensions = ['coc-tsserver', 'coc-tailwindcss', 'coc-svg', 'coc-marketplace', 'coc-eslint', 'coc-coverage']
" " }}}
"
" denite plugin setup "{{{
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [ '*~', '*.o', '*.exe', '*.bak',
      \ '.DS_Store', '*.pyc', '*.sw[po]', '*.class',
      \ '.hg/', '.git/', '.bzr/', '.svn/',
      \ 'node_modules/', 'bower_components/', 'tmp/', 'env/', 'log/', 'vendor/ruby',
      \ '.idea/', 'dist/',
      \ 'tags', 'tags-*'])
" " }}}

" airline config "{{{
let g:airline_theme  = 'dark_minimal'
let g:airline_powerlin_fonts  = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
"let g:airline_symbols.space = ''

" see https://github.com/powerline/fonts instructions, then restart vim w/new fonts
" unicode symbols
let g:airline_left_sep = '⮀'
let g:airline_right_sep = '⮂'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline#extensions#tabline#left_sep = '⮀'
let g:airline#extensions#tabline#left_alt_sep = '⮀'
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
let g:airline#extensions#ale#enabled = 1
" " }}}

" fzf config "{{{
" Using floating windows of Neovim to start fzf
if has('nvim')
  command! Fzf call fzf#run(fzf#wrap({'source': 'find . -type f' }))
  let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'

  function! FloatingFZF()
    let width = float2nr(&columns * 0.9)
    let height = float2nr(&lines * 0.6)
    let opts = { 'relative': 'editor',
          \ 'row': (&lines - height) / 2,
          \ 'col': (&columns - width) / 2,
          \ 'width': width,
          \ 'height': height }
    let gitdir =  finddir('./.git', '.;')
    let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
  endfunction
  let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif

function! FZFDir()
  let gitdir =  finddir('./.git', '.;')
  if !empty(gitdir)
    command! Fzf call fzf#run(fzf#wrap({'source': 'git ls-files' }))
  else
    command! Fzf call fzf#run(fzf#wrap({'source': 'find . -type f' }))
  endif
endfunction

augroup changePath
  autocmd!
  autocmd VimEnter,DirChanged * :call FZFDir()
augroup end
" "
" " }}}

" guten tags config "{{{
let g:gutentags_generate_on_write = 1
let g:gutentags_ctags_tagfile = '.git/tags'
let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]
" " }}}

" ferret config "{{{
" rip grep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
" For use with ack.vim set g:ackprg as follows. Now when you run :Ack it will use rg instead:
" requires `brew install ripgrep`
let g:ackprg = 'rg --vimgrep --no-heading'
" " }}}

" AutoCommands " {{{
" Required:
filetype plugin indent on
syntax enable

augroup Misc programming langues and files
  autocmd BufRead,BufNewFile {*.go}                                       setl ft=go
  autocmd BufRead,BufNewFile {Gemfile,Rakefile,*.rake,config.ru,*.rabl}   setl ft=ruby tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab
  autocmd BufRead,BufNewFile {*.local}                                    setl ft=sh
  autocmd BufRead,BufNewFile {*.md,*.mkd,*.markdown}                      setl ft=markdown
  autocmd BufRead,BufNewFile {*.scala}                                    setl ft=scala
  autocmd BufRead,BufNewFile {Dockerfile*}                                setl ft=Dockerfile
  autocmd BufRead,BufNewFile {*.md,*.mkd,*.markdown}                      setl ft=markdown
  autocmd BufRead,BufNewFile {*.scala}                                    setl ft=scala
  autocmd BufRead,BufNewFile {Dockerfile*}                                setl ft=Dockerfile
  autocmd! bufwritepost init.vim nested source % " automatically reload init.vim on write

  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent loadview  " use mkview to automatically load cursor position, etc.
augroup end
" open help in vertical split
" au BufWinEnter {*.txt} if 'help' == &ft | wincmd H | nmap q :q<CR> | endif
" omnifuncs
" " }}}

" Programming " {{{
highlight ColorColumn ctermbg=yellow ctermfg=blue

function! MarkMargin (on)
  if exists('b:MarkMargin')
    try
      call matchdelete(b:MarkMargin)
    catch /./
    endtry
    unlet b:MarkMargin
  endif
  if a:on
    let b:MarkMargin = matchadd('ColorColumn', '\%101v\s*\S', 10)
  endif
endfunction

augroup core programming languages
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd BufNewFile,BufRead *.scss  set ft=scss.css tabstop=2 softtabstop=2 expandtab smarttab number foldmethod=syntax foldlevelstart=1 foldlevel=99
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  " autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript
  " autocmd BufWritePre *.js,*.jsx Neoformat " this does not work properly
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd User Node if &filetype == "javascript" | setlocal expandtab | endif
  autocmd BufNewFile,BufRead {*.js}                              setl ft=javascript tabstop=2 softtabstop=2 expandtab smarttab number foldmethod=syntax foldlevelstart=1 foldlevel=99
  autocmd BufNewFile,BufRead {*.jsx}                             setl ft=javascript tabstop=2 softtabstop=2 expandtab smarttab number foldmethod=syntax foldlevelstart=1 foldlevel=99
  autocmd BufNewFile,BufRead {*.py}                              setl ft=python tabstop=8 softtabstop=8 expandtab smarttab number foldmethod=indent foldlevelstart=1 foldlevel=99
  autocmd BufNewFile,BufRead {*.sol}                             setl ft=solidity tabstop=4 softtabstop=4 expandtab smarttab number foldmethod=syntax foldlevelstart=1 foldlevel=99
  " autocmd BufNewFile,BufRead {*.js}                             :call MarkMargin(1)
  autocmd BufNewFile,BufRead {*.ts}                              setl ft=typescript tabstop=2 softtabstop=2 expandtab smarttab number foldmethod=syntax foldlevelstart=1 foldlevel=99
  autocmd BufNewFile,BufRead {*.tsx}                             setl ft=typescriptreact tabstop=2 softtabstop=2 expandtab smarttab number foldmethod=syntax foldlevelstart=1 foldlevel=99
  autocmd BufNewFile,BufRead {*.html}                            setl ft=html number formatoptions-=c formatoptions-=r formatoptions-=o
  autocmd BufRead,BufNewFile {*.json}                            setl ft=json formatoptions-=c formatoptions-=r formatoptions-=o foldmethod=syntax
  autocmd BufNewFile,BufRead {*.sh}                              setl number ft=sh tabstop=2 softtabstop=2 expandtab smarttab number foldmethod=syntax foldlevelstart=1 foldlevel=99
  autocmd BufNewFile,BufRead *.bash                            setl number ft=sh tabstop=2 softtabstop=2 expandtab smarttab number foldmethod=marker foldlevelstart=1 foldlevel=99
  autocmd BufWritePost *.sh   :silent make | redraw!             " run shell check on write to .sh files
  autocmd BufWritePost *.bash :silent make | redraw!             " run shell check on write to .bash files
  autocmd! BufReadPost       {COMMIT_EDITMSG,*/COMMIT_EDITMSG}   exec 'setl ft=gitcommit noml list spell' | norm 1G
  autocmd! BufWritePost      {*.snippet,*.snippets}                       call ReloadAllSnippets()
augroup end


" Neoformat does not seem to work well. Will experiment again when more mature
" augroup NeoformatAutoFormat

" " }}}

" Tern " {{{
" tern
if exists('g:plugs["tern_for_vim"]')
  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1
  augroup tern
    autocmd FileType javascript setlocal omnifunc=tern#Complete
    autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>
  augroup end
endif
let g:errorformat =
      \ '%f:%l:%c: %trror: %m,' .
      \ '%f:%l:%c: %tarning: %m,' .
      \ '%f:%l:%c: %tote: %m'
" Experiment with
" set mouse=nvim
" set mouse=v
" with nvim -e startup in shell to copy/paste with trackpad

let &runtimepath.=',~/.config/nvim/plugged/ale' " to run ale background linting
" " }}}

" Per Project tsx/jsx/@subdirs with jsconfig.json gf Setup" {{{
set suffixesadd=.js,.jsx,.ts,.tsx,.json " recognize typescript, javascript, json
set path&vim
function! SetPath()
  set path=.
  let gitdir =  finddir('./.git', '.;')

  if !empty(gitdir)
    " echom 'git dir found'
    let srcdir =  finddir('./src', '.;')
    if !empty(srcdir)
      " echom 'src/ directory found'
      set path+=src/**
    else
      let srcdir =  finddir('./source', '.;')
      if !empty(srcdir)
        set path+=source/**
      endif
    endif
    let pkgfile = findfile('./package.json', '.;')
    if !empty(pkgfile)
      " echom 'package.json file found'
      set path+=node_modules/**
    endif
  "elseho
  endif
  let jsconfig_file = findfile('./jsconfig.json', '.;')
  if len(jsconfig_file)
    let jsconfig_data = json_decode(join(readfile(jsconfig_file)))
    let gotopaths = get(get(jsconfig_data, 'compilerOptions', {}), 'paths', {})
    for key in keys(gotopaths)
      let value = get(gotopaths, key)
      let pathaddition = value[0]
      "let pathaddition = substitute(addition, '^', './', '')
      let &path = &path . ',' . pathaddition
      echom "added: " pathaddition
    endfor
    if &isfname[0] !=# '^' && &isfname[1] !=# '@' && &isfname[2] !=# '/'
      let &isfname ='^@-@' . '/' . ',' . &isfname
    endif
  else
    set path&vim
    set isfname&vim
  endif
endfunction

augroup SetPath
  autocmd!
  autocmd VimEnter,DirChanged * :call SetPath()
augroup end
" " }}}

" Per Project deno check and setup" {{{
function! InstallnEnableCocDeno()
  :CocInstall coc-deno
  :echom 'Detected deno project; Remember to make sure coc-deno is enabled'
endfunction

function! DisableCocDeno()
"  :CocUninstall coc-deno
"  :echom 'Did not detect deno configuration within project; coc-deno disabled'
endfunction

function! SetupDeno()
  let s:cocSettings = 'coc-settings.json'
  let s:enableDenoKey = 'deno.enable'
  let s:settingsFile = findfile(s:cocSettings, '.vim;') " search for coc settings file project directory
  if s:settingsFile ==? '.vim/coc-settings.json' " only run logic if at project root
    let s:denoFile = readfile(s:settingsFile)
    if !empty(s:denoFile)
      let s:enableDenoDict = json_decode(s:denoFile)
      if has_key(s:enableDenoDict, s:enableDenoKey)
        let s:denoEnable = s:enableDenoDict[s:enableDenoKey]
        if !empty(s:denoEnable) 
          if !empty(s:denoEnable) && s:denoEnable ==? 'true'
            :call InstallnEnableCocDeno()
          else
            :call DisableCocDeno()
          endif
        else
          :call DisableCocDeno()
        endif
      else
        :call DisableCocDeno()
      endif
    endif
  else
    :call DisableCocDeno()
  endif
endfunction

augroup SetupDeno
  autocmd!
  autocmd VimEnter,DirChanged * :call SetupDeno()
augroup end
" " }}}
