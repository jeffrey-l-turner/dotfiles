# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh"

typeset -U path PATH

#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init --path)"

function setBrewShellEnv() {
  if [[ -e /opt/homebrew/bin/brew ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
  elif [[ -e /usr/local/bin/brew ]]; then
    # brew shellenv prepends /usr/local/{bin,sbin}; typeset -U dedupes any
    # earlier occurrence so the brew prefix takes precedence (move-to-front).
    eval $(/usr/local/bin/brew shellenv)
  else
   (uname -a | grep Darwin | grep Mac ) && echo "brew not installed" >&2
  fi
  which brew > /dev/null 2>&1 && [[ -f $(brew --prefix)/bin/ctags ]] && alias ctags=$(brew --prefix)/bin/ctags
}
setBrewShellEnv


if [[ -e /usr/libexec/java_home ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null) # set default jdk
  if [[ "${JAVA_HOME}" = "" ]]; then
    JAVA_HOME="see ~/.zprofile, set to default to jdk 11"
    echo "JAVA_HOME not properly set"
  fi
fi

if [[ -f ${HOME}/.nvmrc ]]; then
  if typeset -f nvm >/dev/null 2>&1 ; then
    nodepath=$(dirname $(nvm which $(cat ~/.nvmrc) | tail -1))
  fi
else
  echo "must create ~/.nvmrc to set nodepath, please \`nvm ls-remote | grep -i LTS | grep -i Latest | tail -1\` to determine which version to place in file"
fi

if [[ -e "${HOME}/.local/bin" ]]; then
  export PATH="$PATH:${HOME}/.local/bin"
fi

if [[ -e "${HOME}/.deno" ]]; then
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
  export PATH="$PATH:${HOME}/.foundry/bin"
fi

# nix-profile
if [[ -e "${HOME}/.nix-profile" ]] && echo ${PATH} | grep "\/usr\/bin\/:" >/dev/null; then
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
