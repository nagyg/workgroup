#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# git helper:
#--------------------------------------------------------------------------------------------------////
git.push() {
    if [ -z "$1" ]; then
     local message="`date +"%D %T"` `whoami`"
     echo -e "\n message: $message \n"
    else
     local message="$1"
    fi
    git commit -a -m "$message"
    git push
}
