#!/usr/bin/env zsh 

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=20

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  adb
  colorize
  deno
  docker
  # fzf
  genpass
  # git
  git-prompt
  gpg-agent
  ipfs
  jira
  lighthouse
  # nix-shell
  npm
  nvm
  macos
  pip
  postgres
  # pyenv
  pylint
  rust
  safe-paste
  ssh-agent
  systemadmin
  urltools
  vi-mode
  # zsh-autosuggestions # need to find plugin
  z
)

source $ZSH/oh-my-zsh.sh

# User configuration
function lowercase(){
     echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}
export OS="$(lowercase $(uname))"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ll="ls -la"

# inode command for interactive with tab completion
alias inode='rlwrap -p"0;35" -S "node >>> " -r --always-readline -f  ~/src/dotfiles/nodeJS_completions node'

if [[ -e "${HOME}/.cargo/env" ]]; then
  source "${HOME}/.cargo/env"
fi

if [[ -e "${HOME}/.zshrc_custom" ]]; then
    source "${HOME}/.zshrc_custom"
fi

alias mv="mv -i"
alias cp="cp -i"
set -o noclobber

# hardhat completion
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

function nvim() { # remap b/c ctrl-s is flow control in bash, need to disable for vim
    # osx must use stty -g
    local TTYOPTS
    if [ "${OS}" = "darwin" ]; then
        TTYOPTS="$(stty -g)"
    else
        # shellcheck disable=SC2034
        TTYOPTS="$(stty --save)"
    fi
    stty  stop '' -ixoff
    command nvim "$@"
    stty  "$TTYOPTS"
}

function _concatToEternalHist() {
  local last recent linenum
  last=$(grep -Fn "$(tail -1 ~/OneDrive/_eternal_hist | cut -f 5 | cut -d ' ' -f 4)" ~/OneDrive/_eternal_hist  | sed s/:.*$//)
  recent=$(wc -l ~/._eternal_history | sed 's/ \/.*//' | sed 's/^ *//')
  # shellcheck disable=SC2219
  let linenum="${recent} - ${last}"
  tail -n "${linenum}" ~/.eternal_history >> ~/OneDrive/_eternal_hist
}

function mergeEternalHist() {
  rm -f /tmp/_eternal_hist
  _concatToEternalHist 
  sort -n --key=8 ~/OneDrive/_eternal_hist  | LC_ALL=C uniq > /tmp/_eternal_hist
  chmod 600 /tmp/_eternal_hist
  cp -i /tmp/_eternal_hist ~/OneDrive/_eternal_hist  
  mv -i /tmp/_eternal_hist ~/.eternal_history 
  rm -f /tmp/_eternal_hist
}

function ht() {
  touch ${HOME}/.eternal_history
  local QU='cat ${HOME}/.eternal_history'
  local QR="history "
    for GR in "$@"
    do
        QU="${QU} | grep -i ${GR} " 
        QR="${QR} | grep -i ${GR} " 
    done
    eval "${QU}"
    eval "${QR}"
}

function FF() {
    local QU="find . -type f -exec grep -nHi $1 {} \\;" 
    shift
    for GR in "$@"
    do
        QU="${QU} | grep -i ${GR}"
    done
    echo "${QU}" >&2 
    eval "${QU}"
}

function resetNixRCs() {
  local RESETPROFILES=0
  if grep -i nix /etc/bash.bashrc > /dev/null 2>&1; then
    sudo mv -f /etc/bashrc.bashrc /etc/bashrc.backup-before-nix-old
    sudo mv -f /etc/bashrc.backup-before-nix /etc/bashrc.bashrc
    echo -e "Nix detected in bashrc; Swapping backup-before-nix and /etc/bashrc.bashrc"
    RESETPROFILES=1
  fi

  if grep -i nix /etc/zshrc > /dev/null 2>&1; then
    sudo mv -f /etc/zshrc /etc/zshrc.backup-before-nix-old
    sudo mv -f /etc/zshrc.backup-before-nix /etc/zashrc
    echo -e "Nix detected in bashrc; Swapping backup-before-nix and /etc/zshrc"
    RESETPROFILES=1
  fi

  if !${RESETPROFILES}; then
    return 1
  fi

  return 0
}

function NixStaleInstall() {
  echo -e "Sudo command may be required; Please provide if prompted"
  if ! resetNixRCs; then
    echo "Nix in /etc profiles not found"
  fi
  echo "(Re-)installing Nix"
  # curl -L https://nixos.org/nix/install | sh
	return 0
}

function reinstallNixOverBrew() {
  local input="n"
  echo -e "This function will re-install Nix after Homebrew has overwritten or conflicted with the NixOS installs. It will first check if Nix has previously polluted the /etc profiles and then do a complete reinstall."
  echo -e "Proceed y/n?"
  read input
  if [[ $input == "y" ]]; then
    NixStaleInstall
    return 0
  fi
  return 1
}

unsetopt autopushd # do not put cd cmds on dirs
