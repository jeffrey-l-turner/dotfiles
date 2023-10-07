#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init --path)"

which brew > /dev/null 2>&1 && [[ -f $(brew --prefix)/bin/ctags ]] && alias ctags=$(brew --prefix)/bin/ctags

export JAVA_HOME=$(/usr/libexec/java_home -v 11.0) # defalt to jdk 11


if [[ -e /usr/local/man ]]; then
 export MANPATH="/usr/local/man:$MANPATH"
fi

if [[ -f ${HOME}/.nvmrc ]]; then
  if typeset -f nvm >/dev/null 2>&1 ; then
    nodepath=$(dirname $(nvm which | tail -1))
  fi
else
  echo "must create ~/.nvmrc to set nodepath, please \`nvm ls\` to determine which version to place in file"
fi

if [[ -e "${HOME}/.local/bin"  ]]; then
  export PATH=$PATH:${HOME}/.local/bin
else
    echo -e "Cannot find ~/.local/bin"
fi

if [[ -e "${HOME}/.deno" ]]; then
  export DENO_INSTALL="${HOME}/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi
# setup Lunar Vim
if [[ -e "${HOME}/.local/bin/lvim" ]]; then
  export EDITOR='lvim'
  export VISUAL='lvim' 
#  export PATH="${HOME}/.local/bin/lvim:$PATH"
fi

# setup Foundry
if [[ -e "${HOME}/.foundry" ]]; then
   export PATH="$PATH:${HOME}/.foundry/bin"
fi

# nix-profile 
if [[ -e "${HOME}/.nix-profile" ]] && echo ${PATH} | grep "\/usr\/bin\/:" >/dev/null; then
  echo "Adding '/usr/bin:' to 'PATH' env var for Nix"
  export PATH="/usr/bin:${PATH}"
fi

export OPENAI_API_KEY=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 # personal_jlt
#export OPENAI_API_KEY=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
