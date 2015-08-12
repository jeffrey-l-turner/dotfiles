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

## ----------------------------------------------------------------
## -- determine if on Cygwin, then use other options on ssh-keys --
## ----------------------------------------------------------------
   
OS=`uname | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"  | cut -b 1-6`
if [ "${OS}" == "cygwin" ]; then # define simple pgrep for cygwin
    pgrep(){
        ps aux | fgrep $1 | cut -d ' ' -f 6- | cut -d ' ' -f 1
    }
    PGopts=""
    SSHopts=""
else
    PGopts="-lu"
    SSHopts="-K"
fi

# Added check and start ssh-agent because of problems with Heroku and GitHub authtentication
# start agent and set environment variables, if needed

SSH_ENV="$HOME/.ssh/environment"

# use-ssh-keys(), start_agent() for starting ssh-agent with appropriate rsa keys (for Heroku, GitHub, etc.)
# on Mac OS fixed to detect multiple processes and ask for manual restart 

function use-ssh-keys() {
    ssh-add -l >/dev/null 2>&1
    status=$?  
    if [[ $status -eq 1 ]] ; then # agent is started but no identities associated 
        ls ~/.ssh/*.pub | while read PUB; do
            KEY=`echo $PUB | sed 's/\.pub$//'`
           if [ -O $KEY ]; then
               echo $KEY
               ssh-add ${SSHopts} "$KEY"
           fi
        done
        ssh-add -l
    else
       if [[ $status -eq 2 && "${agent_started}" -eq 1 ]]; then
           echo -e "ssh-agent failed to start..."
           echo -e "attempting to restart agent"
           eval $(ssh-agent -s)
           # this is a fix for Mac OS but will skip rest of shell config
           #ssh-agent bash
           agent_started=1 
       fi
    fi
}

function start_agent {
     echo "Initialising new SSH agent..."
     rm -f "${SSH_ENV}"
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     agent_started=1
 }

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null  || { start_agent; }
    SPROCS=`pgrep $PGopts $USER | fgrep ssh-agent | sed s/ssh-agent//`
    echo 'ssh-agent process(es): ' "${SPROCS}"
    if [[ `echo "${SPROCS}" | wc -w ` -gt 1 ]] ; then 
        echo "Too many ssh-agent processes already started; killing processes and removing existing environment file..."
        echo "Please start another shell to correct."
        pkill -9 -u $USER ssh-agent 
        rm -f "${SSH_ENV}"
    else
        agent_started=1
        use-ssh-keys
    fi
 else
     start_agent;
     use-ssh-keys
 fi


function eternalhist() {
    grep -i $1 ~/.bash_eternal_history | cut -f 5-
}

# function to get pull requests locally from GitHub
pullify() {

git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'

}

# function to update all local branches from remote repo 
git-pull-all() { 
    REMOTES="$@"; 
    if [ -z "$REMOTES" ]; then 
        REMOTES=$(git remote); 
    fi 
    REMOTES=$(echo "$REMOTES" | xargs -n1 echo) 
    CLB=$(git branch -l | awk '/^\*/{print $2}'); 
    echo "$REMOTES" | while read REMOTE; do 
        git remote update $REMOTE 
        git remote show $REMOTE -n | awk '/rebases onto remote/{print $5" "$1}' | while read line; do 
           RB=$(echo "$line" | cut -f1 -d" "); 
           ARB="refs/remotes/$REMOTE/$RB"; 
           LB=$(echo "$line" | cut -f2 -d" "); 
           ALB="refs/heads/$LB"; 
           echo  RB = ${RB} / ARB = ${ARB}
           NBEHIND=$(( $(git rev-list --count $ALB..$ARB 2>/dev/null) +0)); 
           NAHEAD=$(( $(git rev-list --count $ARB..$ALB 2>/dev/null) +0)); 
           if [ "$NBEHIND" -gt 0 ]; then 
                if [ "$NAHEAD" -gt 0 ]; then 
                   echo " branch $LB is $NBEHIND commit(s) behind and $NAHEAD commit(s) ahead of $REMOTE/$RB. could not be fast-forwarded";
                elif [ "$LB" = "$CLB" ]; then 
                   echo " branch $LB was $NBEHIND commit(s) behind of $REMOTE/$RB. fast-forward merge"; 
                   git merge -q $ARB; 
           else 
                   echo " branch $LB was $NBEHIND commit(s) behind of $REMOTE/$RB. reseting local branch to remote"; 
                   git branch -l -f $LB -t $ARB >/dev/null; 
                fi 
           fi 
        done 
    done 
}

# Configure PATH
#  - These are line by line so that you can kill one without affecting the others.
#  - Lowest priority first, highest priority last.
export PATH=$PATH
export PATH=$HOME/bin:$PATH
# export PATH=/usr/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export HISTFILESIZE=2500 # Set the bash history to 2500 entries
if [ -O ~/.ssh/heroku-rsa ]; then
    export PATH=/usr/local/heroku/bin:$PATH # Heroku: https://toolbelt.heroku.com/standalone
fi
export PATH=$PATH:/usr/local/bin  # testing placement for nvm on Mac OS -- still checking other OSes

[ -s "/Users/jeffreyturner/.nvm/nvm.sh" ] && . "/Users/jeffreyturner/.nvm/nvm.sh" # This loads nvm
