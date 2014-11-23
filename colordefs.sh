#!/bin/bash

#  SETUP CONSTANTS
#  Bunch-o-predefined colors.  Makes reading code easier than escape sequences.

    # Reset


function color () {
    arg1=$1

    local declare Color_Off="\[\033[0m\]"       # Text Reset

    # Regular Colors
    local declare Black="\[\033[0;30m\]"        # Black
    local declare Red="\[\033[0;31m\]"          # Red
    local declare Green="\[\033[0;32m\]"        # Green
    local declare Yellow="\[\033[0;33m\]"       # Yellow
    local declare Blue="\[\033[0;34m\]"         # Blue
    local declare Purple="\[\033[0;35m\]"       # Purple
    local declare Cyan="\[\033[0;36m\]"         # Cyan
    local declare White="\[\033[0;37m\]"        # White

    # Bold
    local declare BBlack="\[\033[1;30m\]"       # Black
    local declare BRed="\[\033[1;31m\]"         # Red
    local declare BGreen="\[\033[1;32m\]"       # Green
    local declare BYellow="\[\033[1;33m\]"      # Yellow
    local declare BBlue="\[\033[1;34m\]"        # Blue
    local declare BPurple="\[\033[1;35m\]"      # Purple
    local declare BCyan="\[\033[1;36m\]"        # Cyan
    local declare BWhite="\[\033[1;37m\]"       # White
    
    # Underline
    local declare UBlack="\[\033[4;30m\]"       # Black
    local declare URed="\[\033[4;31m\]"         # Red
    local declare UGreen="\[\033[4;32m\]"       # Green
    local declare UYellow="\[\033[4;33m\]"      # Yellow
    local declare UBlue="\[\033[4;34m\]"        # Blue
    local declare UPurple="\[\033[4;35m\]"      # Purple
    local declare UCyan="\[\033[4;36m\]"        # Cyan
    local declare UWhite="\[\033[4;37m\]"       # White
    
    # Background
    local declare On_Black="\[\033[40m\]"       # Black
    local declare On_Red="\[\033[41m\]"         # Red
    local declare On_Green="\[\033[42m\]"       # Green
    local declare On_Yellow="\[\033[43m\]"      # Yellow
    local declare On_Blue="\[\033[44m\]"        # Blue
    local declare On_Purple="\[\033[45m\]"      # Purple
    local declare On_Cyan="\[\033[46m\]"        # Cyan
    local declare On_White="\[\033[47m\]"       # White
    
    # High Intensty
    local declare IBlack="\[\033[0;90m\]"       # Black
    local declare IRed="\[\033[0;91m\]"         # Red
    local declare IGreen="\[\033[0;92m\]"       # Green
    local declare IYellow="\[\033[0;93m\]"      # Yellow
    local declare IBlue="\[\033[0;94m\]"        # Blue
    local declare IPurple="\[\033[0;95m\]"      # Purple
    local declare ICyan="\[\033[0;96m\]"        # Cyan
    local declare IWhite="\[\033[0;97m\]"       # White
    
    # Bold High Intensty
    local declare BIBlack="\[\033[1;90m\]"      # Black
    local declare BIRed="\[\033[1;91m\]"        # Red
    local declare BIGreen="\[\033[1;92m\]"      # Green
    local declare BIYellow="\[\033[1;93m\]"     # Yellow
    local declare BIBlue="\[\033[1;94m\]"       # Blue
    local declare BIPurple="\[\033[1;95m\]"     # Purple
    local declare BICyan="\[\033[1;96m\]"       # Cyan
    local declare BIWhite="\[\033[1;97m\]"      # White
    
    # High Intensty backgrounds
    local declare On_IBlack="\[\033[0;100m\]"   # Black
    local declare On_IRed="\[\033[0;101m\]"     # Red
    local declare On_IGreen="\[\033[0;102m\]"   # Green
    local declare On_IYellow="\[\033[0;103m\]"  # Yellow
    local declare On_IBlue="\[\033[0;104m\]"    # Blue
    local declare On_IPurple="\[\033[10;95m\]"  # Purple
    local declare On_ICyan="\[\033[0;106m\]"    # Cyan
    local declare On_IWhite="\[\033[0;107m\]"   # White

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
    local declare Time12h="\T"
    local declare Time12a="\@"
    local declare PathShort="\w"
    local declare PathFull="\W"
    local declare NewLine="\n"
    local declare Jobs="\j"
}

color  $*

