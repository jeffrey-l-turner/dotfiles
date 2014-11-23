#!/bin/bash

#  SETUP CONSTANTS
#  Bunch-o-predefined colors.  Makes reading code easier than escape sequences.

    # Reset


function colors () {
    arg1=$1

    declare Color_Off="\[\033[0m\]"       # Text Reset

    # Regular Colors
    declare Black="\[\033[0;30m\]"        # Black
    declare Red="\[\033[0;31m\]"          # Red
    declare Green="\[\033[0;32m\]"        # Green
    declare Yellow="\[\033[0;33m\]"       # Yellow
    declare Blue="\[\033[0;34m\]"         # Blue
    declare Purple="\[\033[0;35m\]"       # Purple
    declare Cyan="\[\033[0;36m\]"         # Cyan
    declare White="\[\033[0;37m\]"        # White

    # Bold
    declare BBlack="\[\033[1;30m\]"       # Black
    declare BRed="\[\033[1;31m\]"         # Red
    declare BGreen="\[\033[1;32m\]"       # Green
    declare BYellow="\[\033[1;33m\]"      # Yellow
    declare BBlue="\[\033[1;34m\]"        # Blue
    declare BPurple="\[\033[1;35m\]"      # Purple
    declare BCyan="\[\033[1;36m\]"        # Cyan
    declare BWhite="\[\033[1;37m\]"       # White
    
    # Underline
    declare UBlack="\[\033[4;30m\]"       # Black
    declare URed="\[\033[4;31m\]"         # Red
    declare UGreen="\[\033[4;32m\]"       # Green
    declare UYellow="\[\033[4;33m\]"      # Yellow
    declare UBlue="\[\033[4;34m\]"        # Blue
    declare UPurple="\[\033[4;35m\]"      # Purple
    declare UCyan="\[\033[4;36m\]"        # Cyan
    declare UWhite="\[\033[4;37m\]"       # White
    
    # Background
    declare On_Black="\[\033[40m\]"       # Black
    declare On_Red="\[\033[41m\]"         # Red
    declare On_Green="\[\033[42m\]"       # Green
    declare On_Yellow="\[\033[43m\]"      # Yellow
    declare On_Blue="\[\033[44m\]"        # Blue
    declare On_Purple="\[\033[45m\]"      # Purple
    declare On_Cyan="\[\033[46m\]"        # Cyan
    declare On_White="\[\033[47m\]"       # White
    
    # High Intensty
    declare IBlack="\[\033[0;90m\]"       # Black
    declare IRed="\[\033[0;91m\]"         # Red
    declare IGreen="\[\033[0;92m\]"       # Green
    declare IYellow="\[\033[0;93m\]"      # Yellow
    declare IBlue="\[\033[0;94m\]"        # Blue
    declare IPurple="\[\033[0;95m\]"      # Purple
    declare ICyan="\[\033[0;96m\]"        # Cyan
    declare IWhite="\[\033[0;97m\]"       # White
    
    # Bold High Intensty
    declare BIBlack="\[\033[1;90m\]"      # Black
    declare BIRed="\[\033[1;91m\]"        # Red
    declare BIGreen="\[\033[1;92m\]"      # Green
    declare BIYellow="\[\033[1;93m\]"     # Yellow
    declare BIBlue="\[\033[1;94m\]"       # Blue
    declare BIPurple="\[\033[1;95m\]"     # Purple
    declare BICyan="\[\033[1;96m\]"       # Cyan
    declare BIWhite="\[\033[1;97m\]"      # White
    
    # High Intensty backgrounds
    declare On_IBlack="\[\033[0;100m\]"   # Black
    declare On_IRed="\[\033[0;101m\]"     # Red
    declare On_IGreen="\[\033[0;102m\]"   # Green
    declare On_IYellow="\[\033[0;103m\]"  # Yellow
    declare On_IBlue="\[\033[0;104m\]"    # Blue
    declare On_IPurple="\[\033[10;95m\]"  # Purple
    declare On_ICyan="\[\033[0;106m\]"    # Cyan
    declare On_IWhite="\[\033[0;107m\]"   # White
    
    # Various variables you might want for your PS1 prompt instead
    declare Time12h="\T"
    declare Time12a="\@"
    declare PathShort="\w"
    declare PathFull="\W"
    declare NewLine="\n"
    declare Jobs="\j"

#    echo $1
    echo "${!arg1} test"
}

colors  $*

