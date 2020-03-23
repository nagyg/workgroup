#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# git helper:
#--------------------------------------------------------------------------------------------------////
# SUBMODULES
# If you want to clone a repository including its submodules you can use the --recursive parameter.
#   git clone --recursive [URL to Git repo]

# If you already have cloned a repository and now want to load it’s submodules you have to use submodule update.
#   git submodule update --init
# if there are nested submodules:
#   git submodule update --init --recursive

# download up to 8 submodules at once
#   git submodule update --init --recursive --jobs 8
#   git clone --recursive --jobs 8 [URL to Git repo]
# short version
#   git submodule update --init --recursive -j 8

# add submodule and define the master branch as the one you want to track
#   git submodule add -b master [URL to Git repo] 
#   git submodule init 

# pull all changes for the submodules
# update your submodule --remote fetches new commits in the submodules
# and updates the working tree to the commit described by the branch
#   git submodule update --remote

# pull all changes in the repo including changes in the submodules
#   git pull --recurse-submodules

#------------------////
# functions:
#------------------////
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

git.submodule.update() {
    git submodule update --remote
}

git.pull.recurse() {
    git pull --recurse-submodules
}

# some more cd aliases
cdw() { cd "${WGPATH}"; }