#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init --path)"

which brew > /dev/null 2>&1 && [[ -f $(brew --prefix)/bin/ctags ]] && alias ctags=$(brew --prefix)/bin/ctags
