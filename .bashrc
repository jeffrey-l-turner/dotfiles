#!/bin/bash
# .bashrc file
#  Modified for Jeff Turner
#
# Concepts:
#
#    1) .bashrc is the *non-login* config for bash, run in scripts and after
#        first connection.
#    2) .bash_profile is the *login* config for bash, launched upon first connection.
#    3) .bash_profile imports .bashrc, but not vice versa.
#    4) .bashrc imports .bashrc_custom, which can be used to override
#        variables specified here.
#
# When using GNU screen:
#
#    1) .bash_profile is loaded the first time you login, and should be used
#       only for paths and environmental settings

#    2) .bashrc is loaded in each subsequent screen, and should be used for
#       aliases and things like writing to .bash_eternal_history (see below)
#
# Do 'man bashrc' for the long version or see here:
# http://en.wikipedia.org/wiki/Bash#Startup_scripts
#
# When Bash starts, it executes the commands in a variety of different scripts.
#
#   1) When Bash is invoked as an interactive login shell, it first reads
#      and executes commands from the file /etc/profile, if that file
#      exists. After reading that file, it looks for ~/.bash_profile,
#      ~/.bash_login, and ~/.profile, in that order, and reads and executes
#      commands from the first one that exists and is readable.
#
#   2) When a login shell exits, Bash reads and executes commands from the
#      file ~/.bash_logout, if it exists.
#
#   3) When an interactive shell that is not a login shell is started
#      (e.g. a GNU screen session), Bash reads and executes commands from
#      ~/.bashrc, if that file exists. This may be inhibited by using the
#      --norc option. The --rcfile file option will force Bash to read and
#      execute commands from file instead of ~/.bashrc.

#  Determine the OS:
#  Using the lowercase function for accurate comparisons -- the tput utility on 
#  Mac OS returns a non-printable
#  character so the if statements below do not work
lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}
OS="$(lowercase "$(uname)")"

# source some useful color definitions:
# shellcheck disable=SC1091 disable=SC1090
source ~/src/dotfiles/colordefs.sh


# -----------------------------------
# -- 1.1) Set up umask permissions --
# -----------------------------------
#  The following incantation allows easy group modification of files.
#  See here: http://en.wikipedia.org/wiki/Umask
#
#     umask 002 allows only you to write (but the group to read) any new
#     files that you create.
#
#     umask 022 allows both you and the group to write to any new files
#     which you make.
#
#  In general we want umask 022 on the server and umask 002 on local
#  machines.
#
#  The command 'id' gives the info we need to distinguish these cases.
#
#     $ id -gn  #gives group name
#     $ id -un  #gives user name
#     $ id -u   #gives user ID
#
#  So: if the group name is the same as the username OR the user id is not
#  greater than 99 (i.e. not root or a privileged user), then we are on a
#  local machine (check for yourself), so we set umask 002.
#
#  Conversely, if the default group name is *different* from the username
#  AND the user id is greater than 99, we're on the server, and set umask
#  022 for easy collaborative editing.

if [ "${OS}" == "sunos" ]; then
    if [ "$(/usr/xpg4/bin/id -gn)" == "$(/usr/xpg4/bin/id -un)" ] && [ "$(/usr/xpg4/bin/id -u)" -gt 99 ]; then
        umask 002
    else
        umask 022
    fi
else
    if [ "$(id -gn)" == "$(id -un)" ] && [ "$(id -u)" -gt 99 ]; then
        umask 002
    else
        umask 022
    fi
fi

# ---------------------------------------------------------
# -- 1.2) Set up bash prompt and ~/.bash_eternal_history --
# ---------------------------------------------------------
#  Set various bash parameters based on whether the shell is 'interactive'
#  or not.  An interactive shell is one you type commands into, a
#  non-interactive one is the bash environment used in scripts.
if [ "$PS1" ]; then
    if [ "${OS}" != "darwin" ]; then
        if [ -x /usr/bin/tput ] && [ "${TERM}" != "dumb" ]; then
            if [ "x$(tput kbs)" != "x" ]; then # We can't do this with "dumb" terminal -- this if stmt does not work on Mac OS 
                stty erase "$(tput kbs)"
            elif [ -x /usr/bin/wc ]; then
                if [ "$(tput kbs|wc -c )" -gt 0 ]; then # We can't do this with "dumb" terminal
                    stty erase "$(tput kbs)"
                fi
            fi
        fi
    fi
    case $TERM in
    xterm*)
        if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
            PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
        else
            PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
        fi
        ;;
    screen)
        if [ -e /etc/sysconfig/bash-prompt-screen ]; then
            PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
        else
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
        fi
        ;;
    dumb)
        PROMPT_COMMAND="echo -ne dumb terminal"
        ;;
    *)
        [ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default

        ;;
    esac

    # Bash eternal history
    # --------------------
    # This snippet allows infinite recording of every command you've ever
    # entered on the machine, without using a large HISTFILESIZE variable,
    # and keeps track if you have multiple screens and ssh sessions into the
    # same machine. It is adapted from:
    # http://www.debian-administration.org/articles/543.
    #
    # The way it works is that after each command is executed and
    # before a prompt is displayed, a line with the last command (and
    # some metadata) is appended to ~/.bash_eternal_history.
    #
    # This file is a tab-delimited, timestamped file, with the following
    # columns:
    #
    # 1) user
    # 2) hostname
    # 3) screen window (in case you are using GNU screen)
    # 4) date/time
    # 5) current working directory (to see where a command was executed)
    # 6) the last command you executed
    #
    # The only minor bug: if you include a literal newline or tab (e.g. with
    # awk -F"\t"), then that will be included verbatime. It is possible to
    # define a bash function which escapes the string before writing it; if you
    # have a fix for that which doesn't slow the command down, please submit
    # a patch or pull request.
    PROMPT_COMMAND="setPS1; ${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo -e $$\\t$USER\\t$HOSTNAME\\tscreen $WINDOW\\t`date +%D%t%T%t%Y%t%s`\\t$PWD"$(history 1)" >> ~/.bash_eternal_history'

    # Turn on checkwinsize
    shopt -s checkwinsize

    #Prompt edited from default
    [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\\u \\w]\\$ "

    if [ "x$SHLVL" != "x1" ]; then # We're not a login shell
        for i in /etc/profile.d/*.sh; do
        if [ -r "$i" ]; then
                # shellcheck disable=SC1091,SC1090
            . "$i"
        fi
    done
    fi
fi

# Append to history
# See: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
shopt -s histappend

# Create some useful functions for the prompt if in a Git directory

function _git-branch-prompt { 
    local declare HC
    HC=$(color URed esc)
    local declare TC
    TC=$(color IRed esc)
    if git symbolic-ref HEAD > /dev/null 2>&1 ; then
        HColor=$(color UGreen)
        # The following stmt is better for Atlassian stash setups which requires heads/<branch> specificity
        # echo -ne "$(git symbolic-ref HEAD 2>/dev/null | awk -F"/" '{printf "%s/%s", $(NF-1), $NF ;}')"" "
        echo -ne "$(git symbolic-ref HEAD 2>/dev/null | awk -F"/" '{printf "%s", $NF ;}')"" "
    else
        HColor=$(color URed)
        local declare br
        br=$(git branch 2>/dev/null | head -1 | sed s/*\*\ *\(// | sed s/\)*$//)
        if [ "$br" ]; then
            echo -ne "${HC}warning:${TC} ${br} "
        else
            HColor=$(color IGreen)
        fi
    fi
}

function _git-commits {
    if git status -s > /dev/null 2>&1 ; then
        local num
        num=$(git status -s | wc -l | sed -e 's/^ *//')
        if [ "$num" -gt 0  ]; then
            HColor=$(color URed)
            echo "${num} "
        else
            echo ""
        fi
    else
        echo ""
    fi
}

if [ "${OS}" != "sunos" ]; then
    if which docker >/dev/null 2>&1; then 
       function _docker-prompt { 
          local declare DC
          DC=$(color On_ICyan esc)
          local declare off
          off=$(color Color_Off)
          # shellcheck disable=SC2034
          local declare whale
          whale="\\xF0\\x9F\\x90\\xB3"
          if docker info >/dev/null 2>&1; then
              echo -e "${DC}${whale} ${off} "
          else
              # shellcheck disable=SC2005
              echo "$(color Color_Off)"
          fi
       }
    else
       function _docker-prompt { 
           true;
       }
    fi
else
    function _docker-prompt { 
            # shellcheck disable=SC2005
            echo "$(color Color_Off)"
    }
fi

HColor=$(color IGreen)
function setPS1 { 
    # shellcheck disable=SC2154
    PS1="$(_docker-prompt)${HColor}\$(_git-branch-prompt)$(color BRed)\$(_git-commits)$lbreak$(color Yellow)\\u$(color IPurple)@\\h:$(color BICyan)\\W$(color Color_Off) $ "
}

## -----------------------
## -- 2) Set up aliases --
## -----------------------

# 2.1) Safety
alias mv="mv -i"
alias cp="cp -i"
set -o noclobber

# Move export GREP_OPTIONS="--color=auto" (which is deprecated) from .exports to .alias
# Always enable colored `grep` output`
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# 2.2) Listing, directories, and motion
if [ "${OS}" == "darwin" ]; then
  if which brew > /dev/null 2>&1 && [ -f "$(brew --prefix)/bin/exa" ]; then
    alias ll="exa -lr"
    alias dir='exa -Gx'
    alias vdir='exa -l@G'
  else
    alias ll="ls -lrptFG"
    alias dir='ls -Gx'
    alias vdir='ls -l@G'
  fi
elif [ "${OS}" == "sunos" ]; then
    alias ll="ls -lrtF"
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'
    stty erase ^?
else
    alias ll="ls -lrtF --color"
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'
fi
if which exa > /dev/null 2>&1; then
  alias la="exa -A"
  alias l="exa -F"
else
  alias la="ls -A"
  alias l="ls -CF"
fi
alias m='less'
alias ..='cd ..'
alias ...='cd ..;cd ..'
alias md='mkdir'
if [ "${OS}" = "darwin" ]; then
    alias cl='clear; printf "\e[3J"'
else
    alias cl='clear'
fi

#alias du='du -ch --max-depth=1'
alias treeacl='tree -A -C -L 2'

# 2.3) Text and editor commands
alias em='emacs -nw'     # No X11 windows
alias eqq='emacs -nw -Q' # No config and no X11
export EDITOR='nvim'
export VISUAL='nvim' 

# 2.4) grep options
# export GREP_OPTIONS='--color=auto' # deprecated
export GREP_COLOR='1;31' # green for matches

# 2.5) sort options
# Ensures cross-platform sorting behavior of GNU sort.
# http://www.gnu.org/software/coreutils/faq/coreutils-faq.html#Sort-does-not-sort-in-normal-order_0021
#unset LANG
# deprecating above in favor of better tmux support for vim, $PS1:
#http://stackoverflow.com/questions/11237462/weird-space-before-prompt-using-tmux-on-mac-os-lion

# 2.6) Install rlwrap if not present
# http://stackoverflow.com/a/677212
if ! command -v rlwrap >/dev/null 2>&1 ; then
    if [ "$OS" != "sunos" ]; then
        echo >&2 "Install rlwrap to use node: sudo <installation command> install -y rlwrap";
    fi
fi

# 2.7) node.js and nvm
# http://nodejs.org/api/repl.html#repl_repl
alias node="env NODE_NO_READLINE=1 rlwrap node"
if [ "${OS}" != "sunos" ]; then # doesn't work on sunos
  alias node_repl="node -e \"require('repl').start({ignoreUndefined: true})\""
fi
export NODE_DISABLE_COLORS=1
if [ -s ~/.nvm/nvm.sh ]; then
  NODE_DISABLE_COLORS=1
    export NVM_DIR=~/.nvm
    # shellcheck disable=SC1091 disable=SC1090
    source ~/.nvm/nvm.sh
  NODE_DISABLE_COLORS=0
  # nvm use v12.18 &> /dev/null # silence nvm use; needed for rsync
fi

# 2.8) Pretty Git log graph
alias gitgraph="git log --first-parent --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''  %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' "
alias gitgraphParent="git log  --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''  %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' "

## ------------------------------
## -- 3) User-customized code  --
## ------------------------------
# Setting up tidy for editing angular html fragments
export HTML_TIDY=~/.tidy

## Define any user-specific variables you want here.
if [ -f "${HOME}/.bashrc_custom" ]; then
    # shellcheck disable=SC1091 disable=SC1090
    source ~/.bashrc_custom
fi

# inode command for interactive with tab completion
if [ "${OS}" == "linux" ]; then
    alias inode='rlwrap -p"0;35" -S "node >>> " -r --always-readline -f  ~/src/dotfiles/nodeJS_completions node'
else
    alias inode='rlwrap -p "0;35" -S "node >>> " -r --always-readline -f  ~/src/dotfiles/nodeJS_completions node'
fi

nvim() { # remap b/c ctrl-s is flow control in bash, need to disable for vim
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

