#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init --path)"

function setBrewShellEnv() {
  if [[ -e /opt/homebrew/bin/brew ]]; then
    PATH=$(echo "${PATH}" | sed -e 's/\/opt\/homebrew\/bin://g')
    PATH=$(echo "${PATH}" | sed -e 's/\/opt\/homebrew\/sbin://g')
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
  export JAVA_HOME=$(/usr/libexec/java_home -v 11.0 2>/dev/null) # defalt to jdk 11
  if [[ "${JAVA_HOME}" = "" ]]; then
    JAVA_HOME="see ~/.zprofile, sets default to jdk 11"
    echo 'warning: jdk 11 not set in $JAVA_HOME;  may want to `[brew, sudo apt-install, ...] install openjdk@11`.' >&2
  fi
fi

if [[ -f ${HOME}/.nvmrc ]]; then
  if typeset -f nvm >/dev/null 2>&1 ; then
    nodepath=$(dirname $(nvm which | tail -1))
  fi
else
  echo "must create ~/.nvmrc to set nodepath, please \`nvm ls-remote | grep -i LTS | grep -i Latest | tail -1\` to determine which version to place in file"
fi

# Make HOME directory string subsitutable for sed
HOMESub=$(echo "${HOME}" | sed -e 's/\//\\\//g')

# local executables such as lunarvim
if [[ -e "${HOME}/.local/bin"  ]]; then
  PATH=$(echo "${PATH}" | sed -e "s/${HOMESub}\/.local\/bin://g")
  export PATH=$PATH:${HOME}/.local/bin
fi

# setup Lunar Vim
if [[ -x "${HOME}/.local/bin/lvim" ]]; then
  export EDITOR='lvim'
  export VISUAL='lvim' 
fi

# for Rust cargo
if [[ -e "${HOME}/.cargo/bin"  ]]; then
  PATH=$(echo "${PATH}" | sed -e "s/${HOMESub}\/.cargo\/bin://g")
  export PATH=$PATH:${HOME}/.cargo/bin
fi

if [[ -e "${HOME}/.deno" ]]; then
  PATH=$(echo "${PATH}" | sed -e "s/${HOMESub}\/.deno\/bin://g")
  export DENO_INSTALL="${HOME}/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# setup Foundry
if [[ -e "${HOME}/.foundry" ]]; then
  PATH=$(echo "${PATH}" | sed -e "s/${HOMESub}\/.foundry\/bin://g")
  export PATH="$PATH:${HOME}/.foundry/bin"
fi

# nix-profile 
if [[ -e "${HOME}/.nix-profile" ]] && echo ${PATH} | grep "\/usr\/bin\/:" >/dev/null; then
  PATH=$(echo "${PATH}" | sed -e "s/${HOMESub}\/usr\/bin://g")
  echo "Adding '/usr/bin:' to 'PATH' env var for Nix"
  export PATH="/usr/bin:${PATH}"
fi

# Test for duplicates in path:
Function testDupsInPath() {
  local uniqpathitems=$(echo $PATH | sed -e 's/:/:\n/g' | sort | uniq | wc -l)
  local pathlist=$(echo $PATH | sed -e 's/:/:\n/g' | sort | wc -l)
  if [[ "${uniqpathitems}" != "${pathlist}" ]]; then
    echo 'warning: duplicate items in your $PATH.' >&2
  fi
}
testDupsInPath
