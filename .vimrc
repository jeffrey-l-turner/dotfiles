set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" alternatively, pass a path where Vundle should install plugins
"let path = '~/some/path/here'
"call vundle#rc(path)
" let Vundle manage Vundle, required
Plugin 'gmarik/vundle'
" The following are examples of different formats supported.
" Keep Plugin commands between here and filetype plugin indent on.
" scripts on GitHub repos
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/vim-easymotion'
"Plugin 'tpope/vim-rails.git'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" scripts from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
Plugin 'FuzzyFinder'
" scripts not on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/jlt/.vim/path/to/plugin'
" ...
Bundle 'flazz/vim-colorschemes'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'scrooloose/syntastic'
" Syntaxtic will check your file on open too, not just on save.
"let g:syntastic_javascript_checkers = ['jshint', 'jslint'] " if you want both jshint and jslint
let g:syntastic_javascript_checkers = ['jshint'] " if you want only jshint
" let g:syntastic_javascript_checkers = ['jslint'] "if you want only jslint instead
let g:syntastic_check_on_open=1
filetype plugin indent on     " required
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
:set expandtab
:set shiftwidth=4
:set softtabstop=4
:set matchtime=1
"change below : to " or vice versa to stop autoformatting of comments when copying pasting code snipppets into vim
:autocmd FileType *.js *.css *.html *.json setlocal formatoptions-=c formatoptions-=r formatoptions-=o
:autocmd BufNewFile,BufRead *.json set ft=javascript
"set no line numbers -- :set number to enable
"set nonumber
:autocmd BufNewFile,BufRead *.js  :set number
:autocmd BufNewFile,BufRead *.sh  :set number
:set ruler
:syntax on
:set t_Co=256
:set background=dark
