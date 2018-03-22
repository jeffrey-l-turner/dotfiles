#!/bin/bash

#  SETUP CONSTANTS
#  Bunch-o-predefined colors.  Makes reading code easier than escape sequences.

function color () {
    arg1=$1

    export local declare Color_Off="\[\033[0m\]"       # Text Reset

    # Regular Colors
    export local declare Black="\[\033[0;30m\]"        # Black
    export local declare Red="\[\033[0;31m\]"          # Red
    export local declare Green="\[\033[0;32m\]"        # Green
    export local declare Yellow="\[\033[0;33m\]"       # Yellow
    export local declare Blue="\[\033[0;34m\]"         # Blue
    export local declare Purple="\[\033[0;35m\]"       # Purple
    export local declare Cyan="\[\033[0;36m\]"         # Cyan
    export local declare White="\[\033[0;37m\]"        # White

    # Bold
    export local declare BBlack="\[\033[1;30m\]"       # Black
    export local declare BRed="\[\033[1;31m\]"         # Red
    export local declare BGreen="\[\033[1;32m\]"       # Green
    export local declare BYellow="\[\033[1;33m\]"      # Yellow
    export local declare BBlue="\[\033[1;34m\]"        # Blue
    export local declare BPurple="\[\033[1;35m\]"      # Purple
    export local declare BCyan="\[\033[1;36m\]"        # Cyan
    export local declare BWhite="\[\033[1;37m\]"       # White
    
    # Underline
    export local declare UBlack="\[\033[4;30m\]"       # Black
    export local declare URed="\[\033[4;31m\]"         # Red
    export local declare UGreen="\[\033[4;32m\]"       # Green
    export local declare UYellow="\[\033[4;33m\]"      # Yellow
    export local declare UBlue="\[\033[4;34m\]"        # Blue
    export local declare UPurple="\[\033[4;35m\]"      # Purple
    export local declare UCyan="\[\033[4;36m\]"        # Cyan
    export local declare UWhite="\[\033[4;37m\]"       # White
    
    # Background
    export local declare On_Black="\[\033[40m\]"       # Black
    export local declare On_Red="\[\033[41m\]"         # Red
    export local declare On_Green="\[\033[42m\]"       # Green
    export local declare On_Yellow="\[\033[43m\]"      # Yellow
    export local declare On_Blue="\[\033[44m\]"        # Blue
    export local declare On_Purple="\[\033[45m\]"      # Purple
    export local declare On_Cyan="\[\033[46m\]"        # Cyan
    export local declare On_White="\[\033[47m\]"       # White
    
    # High Intensty
    export local declare IBlack="\[\033[0;90m\]"       # Black
    export local declare IRed="\[\033[0;91m\]"         # Red
    export local declare IGreen="\[\033[0;92m\]"       # Green
    export local declare IYellow="\[\033[0;93m\]"      # Yellow
    export local declare IBlue="\[\033[0;94m\]"        # Blue
    export local declare IPurple="\[\033[0;95m\]"      # Purple
    export local declare ICyan="\[\033[0;96m\]"        # Cyan
    export local declare IWhite="\[\033[0;97m\]"       # White
    
    # Bold High Intensty
    export local declare BIBlack="\[\033[1;90m\]"      # Black
    export local declare BIRed="\[\033[1;91m\]"        # Red
    export local declare BIGreen="\[\033[1;92m\]"      # Green
    export local declare BIYellow="\[\033[1;93m\]"     # Yellow
    export local declare BIBlue="\[\033[1;94m\]"       # Blue
    export local declare BIPurple="\[\033[1;95m\]"     # Purple
    export local declare BICyan="\[\033[1;96m\]"       # Cyan
    export local declare BIWhite="\[\033[1;97m\]"      # White
    
    # High Intensty backgrounds
    export local declare On_IBlack="\[\033[0;100m\]"   # Black
    export local declare On_IRed="\[\033[0;101m\]"     # Red
    export local declare On_IGreen="\[\033[0;102m\]"   # Green
    export local declare On_IYellow="\[\033[0;103m\]"  # Yellow
    export local declare On_IBlue="\[\033[0;104m\]"    # Blue
    export local declare On_IPurple="\[\033[10;95m\]"  # Purple
    export local declare On_ICyan="\[\033[0;106m\]"    # Cyan
    export local declare On_IWhite="\[\033[0;107m\]"   # White

    if [ $arg1 ]; then
        if [[ $# -gt 0 && $# -lt 2 ]]; then
            echo -n "${!arg1}"
        else 
            echo -n ${!arg1} | sed -e 's/\\\[//' -e 's/\\\]//' | tr -d '\n'
        fi
    fi
}
    
function Prompt () {
    # Various variables you might want for your PS1 prompt instead
    export local declare Time12h="\T"
    export local declare Time12a="\@"
    export local declare PathShort="\w"
    export local declare PathFull="\W"
    export local declare NewLine="\n"
    export local declare Jobs="\j"

    if [ $arg1 ]; then 
            echo -n "${!arg1}"
    fi
}
