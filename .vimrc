set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
" let Vundle manage Vundle, required
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
call vundle#begin('~/.vim/bundle')
" Convention: Plugin '~/.vim/path/to/plugin'
Plugin 'gmarik/vundle'
" Plugins that have been cloned separately
" The following two plugins have taken a great deal of experimentation to find the right path...
" Plugin 'git://git.wincent.com/command-t.git'
"Plugin 'file:///users/jeffturner~/.vim/bundle/command-t'
Plugin 'git@github.com:wincent/command-t.git'
" supported using SyntaxComplete
Plugin 'othree/javascript-libraries-syntax.vim.git'
Plugin 'othree/html5.vim'
Plugin 'git@github.com:vim-scripts/SyntaxComplete.git'
" alternatively, pass a path where Vundle should install plugins
"let path = '~/some/path/here'
"call vundle#rc(path)
" The following are examples of different formats supported.
" Keep Plugin commands between here and filetype plugin indent on.
" scripts on GitHub repos
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'tpope/vim-surround'
"Plugin 'tpope/vim-rails.git'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" scripts from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
Plugin 'FuzzyFinder'
" plugins not on GitHub
" \ is leader key
" command-t uses \t for file interface;
" git repos on your local machine (i.e. when working on your own plugin)
call vundle#end()
" ...
Bundle 'flazz/vim-colorschemes'
" trying pangloss instead of:
"Bundle 'jelera/vim-javascript-syntax'
Bundle "pangloss/vim-javascript"
Bundle 'scrooloose/syntastic'
Bundle 'groenewege/vim-less'
Bundle "burnettk/vim-angular"
Bundle "moll/vim-node"
" Lines of history to remember
set history=1000
" turn on autoread in case file modified externally
set autoread
" Omni-competion for environments I typically use:
" To use, type <C-X><C-O> while open in Insert mode. If
" matching names are found, a pop-up menu opens which can be navigated using
" the <C-N> and <C-P> keys.
set ofu=syntaxcomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
" autocmd FileType c set omnifunc=ccomplete#Complete
" Syntaxtic will check your file on open too, not just on save.
"let g:syntastic_javascript_checkers = ['jshint', 'jslint'] " if you want both jshint and jslint
"let g:syntastic_javascript_checkers = ['jshint'] " if you want only jshint
" let g:syntastic_javascript_checkers = ['jslint'] "if you want only jslint instead

let g:syntastic_javascript_checkers = ['eslint'] " if you want only eslint
let g:syntastic_check_on_open=1

"*css lint checkers
" to use scss-lint, ruby and its gem must be installed: `ruby install scss_lint`
"let g:syntastic_scss_checkers = ['scss_lint']
let g:CSSLint_FileTypeList = ['css', 'less', 'sess']
" Setup tidy rules:
let g:syntastic_html_tidy_ignore_errors = [ '<dom-module>' ]
filetype plugin indent on     " required
" setup use for libraries-syntax:
let g:used_javascript_libs = 'underscore,angularjs,angularui,requirejs'
" other lib options are: jquery, backbone, prelude, sugar, jasmine
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Plugin commands are not allowed.
" Put your stuff after this line:set expandtab
" turn on incremental search highlighting
:set incsearch
:set hlsearch 
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
:set runtimepath^=~/.vim/bundle/ctrlp.vim "ctrl-p plugin helps find files for angular (and others)
":set foldmethod=indent   "fold based on indent
:set foldmethod=syntax   "fold based on syntax
syntax region foldBraces start=/{/ end=/}/ transparent fold keepend extend
:set foldnestmax=10      "deepest fold is 10 levels
:set nofoldenable        "dont fold by default
:set foldcolumn=0
":set foldlevel=1        "use if indent based
:let javaScript_fold=1 
:set expandtab
:set shiftwidth=4
:set softtabstop=4
:set matchtime=1
:set cursorline
:let javascript_enable_domhtmlcss=1
" Setup custom folding of HTML Tags with `F` key map
:map F :source ~/.vim/html.vim<CR> 
" setup commenting of html with surround.vim -- 
" vat,c on head of item to be  commented out
:vmap ,c <esc>a--><esc>'<i<!--<esc>'>$
"change below : to " or vice versa to stop autoformatting of comments when copying pasting code snipppets into vim
:autocmd FileType *.js *.css *.html *.json *.less setlocal formatoptions-=c formatoptions-=r formatoptions-=o 
:autocmd FileType *.js *.json *.html setlocal foldmethod=syntax foldlevelstart=1 foldlevel=99
:autocmd BufNewFile,BufRead *.json set ft=javascript
" make and restore views automatically
:autocmd BufWinLeave *.* mkview
:autocmd BufWinEnter *.* silent loadview 
"set no line numbers -- :set number to enable
"set nonumber
:autocmd BufNewFile,BufRead *.js  :set number
:autocmd BufNewFile,BufRead *.sh  :set number
" run shell check on write to .sh files
set makeprg=shellcheck\ -f\ gcc\ % 
:autocmd BufWritePost *.sh  :silent make | redraw!
" Setup node.vim; see: https://github.com/moll/vim-node
autocmd User Node if &filetype == "javascript" | setlocal expandtab | endif
:set ruler
:syntax on
:set t_Co=256
set showcmd  " (sc) display an incomplete command in the lower right
:set background=dark
