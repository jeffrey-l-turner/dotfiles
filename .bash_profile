# .bash_profile file
# By Balaji S. Srinivasan (balajis <at> stanford.edu)
# Customized by Jeff Turner for his Heroku and .ssh key setup
#
# Concepts:
# http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html
#
#    1) .bashrc is the *non-login* config for bash, run in scripts and after
#        first connection.
#
#    2) .bash_profile is the *login* config for bash, launched upon first
#        connection (in Ubuntu)
#
#    3) .bash_profile imports .bashrc in our script, but not vice versa.
#
#    4) .bashrc imports .bashrc_custom in our script, which can be used to
#        override variables specified here or for pre-configuring a customized
#        environment prior to running this script.
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

## -----------------------
## -- 1) Import .bashrc --
## -----------------------

# Factor out all repeated profile initialization into .bashrc
#  - All non-login shell parameters go there
#  - All declarations repeated for each screen session go there
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

# Added check and start ssh-agent because of problems with Heroku authtentication
# Heroku was refusing connections because ssh-agent was not started
# start agent and set environment variables, if needed
agent_started=0
if ! env | grep -q SSH_AGENT_PID >/dev/null; then
  echo "Starting ssh agent"
  eval $(ssh-agent -s)
  agent_started=1
fi

# use-ssh-keys for GitHub, Heroku on Mac OS fix 
use-ssh-keys() {
  if ! ssh-add -l >/dev/null 2>&-; then
    if [ -O ~/.ssh/heroku-rsa ]; then
        ssh-add ~/.ssh/heroku-rsa
        echo "ssh added heroku-rsa"
    fi
    if [ -O ~/.ssh/github-rsa ]; then
        ssh-add ~/.ssh/github-rsa
        echo "ssh added github-rsa"
    fi
  fi
}
use-ssh-keys

# function to get pull requests locally from GitHub
pullify() {

git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'

}

# Configure PATH
#  - These are line by line so that you can kill one without affecting the others.
#  - Lowest priority first, highest priority last.
export PATH=$PATH
export PATH=$HOME/bin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/local/sbin:$PATH
if [ -O ~/.ssh/heroku-rsa ]; then
    export PATH=/usr/local/heroku/bin:$PATH # Heroku: https://toolbelt.heroku.com/standalone
fi
export PATH=$PATH:/usr/local/bin  # improper placement for nvm on Mac OS -- others unkonw?

[ -s "/Users/jeffreyturner/.nvm/nvm.sh" ] && . "/Users/jeffreyturner/.nvm/nvm.sh" # This loads nvm
