#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# MAIN environment:
#--------------------------------------------------------------------------------------------------////
green='\e[32m'
yellow='\e[33m'
red='\e[31m'
blue='\e[34m'
nc='\e[0m'

#------------------------------------------////
# Functions to PATH:
#------------------------------------------////
pathremove () { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'"$1"'"' | sed 's/:$//'`; }
pathadd () { pathremove $1; export PATH="$1:$PATH"; }

ftobslash () { echo "$1" | sed 's|/|\\|g'; }
btofslash () { echo "$1" | sed 's|\\|/|g'; }
colonremove () { echo "$1" | sed 's|\\|/|g; s|\(.\):|/\1|g'; }
pathshow () { printenv PATH | sed 's|:|\n|g'; }

#------------------------------------------////
# Bin:
#------------------------------------------////
pathadd "${WGPATH}/bin/7za"

#------------------------------------------////
# Bash Finction & Alias:
#------------------------------------------////
edit.profile () { sed -i "/${1}=/c\\${1}=\"${2}\"" ${WGPATH}/.wgsource; }

switch () {  if [ -z $1 ] || [ $1 == 0 ]; then echo $2 ; else echo $3; fi; }
switch.color () { switch "$1" ${red} ${green}; }

createmenu () {
if [ -z "$1" ]; then return; fi
case "$1" in
	"${all_aversion[@]}")
		local input=AVERSION ;;
	"${all_hversion[@]}")
		local input=HVERSION ;;
	"${all_fversion[@]}")
		local input=FVERSION ;;
	*)
		return ;;
esac
echo " ${input}"
PS3=$'\nSelect version : '
echo
select version; do
	if [ 1 -le "$REPLY" ] 2>/dev/null && [ "$REPLY" -le $(($#)) ] 2>/dev/null; then
		export "${input}"="${version}"
		break;
	else
		echo "bash: $REPLY: incorrect input"
	fi
done
unset PS3
}

tree () {
	find $@ | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"
}

reload() {
	source ~/.bash_profile
}

# some more ls aliases
alias ls='ls -Fhr --color=auto' # add colors for filetype recognition, reverse order
alias ll='ls -l'   # long listing
alias la='ls -Al'  # show hidden files
alias lk='la -S'   # sort by size
alias lc='la -c'   # sort by ctime
alias lu='la -u'   # sort by access time
alias lt='la -t'   # sort by modification time
alias lx='la -XB'  # sort by extension
alias lr='la -R'   # recursice ls

# some more cd aliases
cd() {
if [ -n "$1" ]; then
	builtin cd "$@" && lt # list and sort by modification time
else
 	builtin cd ~          # go home
fi
}

alias ..='cd ..'
alias ...='cd ../../'

#------------------------------------------////
# HIDDEN SOURCE:
#------------------------------------------////
source "${WGPATH}/bash/source/git.sh"
source "${WGPATH}/bash/source/repo.sh"

#------------------------------------------////
# INITIAL:
#------------------------------------------////
if [ -d "$JOB" ]; then
	builtin cd "$JOB"
else
	builtin cd ~
fi

printf "%s ${yellow}%11s${nc}\n" "Workgroup  >" "${WGPATH}"