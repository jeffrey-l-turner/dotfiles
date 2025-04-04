# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh"
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init --path)"

function setBrewShellEnv() {
  if [[ -e /opt/homebrew/bin/brew ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
  elif [[ -e /usr/local/bin/brew ]]; then
    # remove shellenv addition of /usr/local/bin
    PATH=$(echo "${PATH}" | sed -e 's/\/usr\/local\/bin://g')
    PATH=$(echo "${PATH}" | sed -e 's/\/usr\/local\/sbin://g')
    eval $(/usr/local/bin/brew shellenv)
  else
    echo "brew not installed" >&2
  fi
}
setBrewShellEnv

which brew > /dev/null 2>&1 && [[ -f $(brew --prefix)/bin/ctags ]] && alias ctags=$(brew --prefix)/bin/ctags

if [[ -e /usr/libexec/java_home ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null) # set default jdk
  if [[ "${JAVA_HOME}" = "" ]]; then
    JAVA_HOME="see ~/.zprofile, set to default to jdk 11"
    echo "JAVA_HOME not properly set"
  fi
fi

if [[ -f ${HOME}/.nvmrc ]]; then
  if typeset -f nvm >/dev/null 2>&1 ; then
    nodepath=$(dirname $(nvm which | tail -1))
  fi
else
  echo "must create ~/.nvmrc to set nodepath, please \`nvm ls-remote | grep -i LTS | grep -i Latest | tail -1\` to determine which version to place in file"
fi

if [[ -e "${HOME}/.local/bin"  ]]; then
  PATH=$(echo "${PATH}" | sed -e 's/\/.local\/bin://g')
  export PATH=$PATH:${HOME}/.local/bin
fi

if [[ -e "${HOME}/.deno" ]]; then
  PATH=$(echo "${PATH}" | sed -e 's/\/.deno\/bin://g')
  export DENO_INSTALL="${HOME}/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi
# setup Lunar Vim
if [[ -e "${HOME}/.local/bin/lvim" ]]; then
  export EDITOR='lvim'
  export VISUAL='lvim' 
fi

# setup Foundry
if [[ -e "${HOME}/.foundry" ]]; then
  PATH=$(echo "${PATH}" | sed -e 's/\/.foundry\/bin://g')
  export PATH="$PATH:${HOME}/.foundry/bin"
fi

# nix-profile 
if [[ -e "${HOME}/.nix-profile" ]] && echo ${PATH} | grep "\/usr\/bin\/:" >/dev/null; then
  PATH=$(echo "${PATH}" | sed -e 's/\/usr\/bin://g')
  echo "Adding '/usr/bin:' to 'PATH' env var for Nix"
  export PATH="/usr/bin:${PATH}"
fi

# Test for duplicates in path:
Function testDupsInPath() {
  local uniqpathitems=$(echo $PATH | sed -e 's/:/:\n/g' | sort | uniq | wc -l)
  local pathlist=$(echo $PATH | sed -e 's/:/:\n/g' | sort | wc -l)
  if [[ "${uniqpathitems}" != "${pathlist}" ]]; then
    echo "warning: duplicates items in your \$PATH." >&2
  fi
}
testDupsInPath
