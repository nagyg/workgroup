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
pathshow () { printenv PATH | sed 's|:|\n|g'; }

cygdrive () { echo \"$(cygpath -U "$(cygpath -w "$1")")\"; }

#------------------------------------------////
# Bin:
#------------------------------------------////
pathadd "${WGPATH}/setup/cwrsync"

#------------------------------------------////
# rsync:
#------------------------------------------////
rsync() {
	export rsyncarg=$@

	local in=`pwd`
	( cd ; cwrsync.cmd )
	builtin cd "$in"

	unset rsyncarg
}

#------------------------------------------////
# Bash Finction & Alias:
#------------------------------------------////
edit.profile () { sed -i "/${1}=/c\\${1}=\"${2}\"" ~/.bash_profile; }

switch () {  if [ -z $1 ] || [ $1 == 0 ]; then echo $2 ; else echo $3; fi; }
switch.color () { switch "$1" ${red} ${green}; }

createmenu () {
	if [ -z "$1" ]; then return; fi
	case "$1" in
		"${all_aversion[@]}")
			local input=AVERSION ;;
		"${all_rversion[@]}")
			local input=RVERSION ;;
		"${all_hversion[@]}")
			local input=HVERSION ;;
		"${all_bversion[@]}")
			local input=BVERSION ;;
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

extract() {
	if [ -f "$1" ] ; then
		case "$1" in
		*.tar.bz2) tar xjf "$1" ;;
		*.tar.gz) tar xzf "$1" ;;
		*.tar.Z) tar xzf "$1" ;;
		*.bz2) bunzip2 "$1" ;;
		*.rar) unrar x "$1" ;;
		*.gz) gunzip "$1" ;;
		*.jar) unzip "$1" ;;
		*.tar) tar xf "$1" ;;
		*.tbz2) tar xjf "$1" ;;
		*.tgz) tar xzf "$1" ;;
		*.zip) unzip "$1" ;;
		*.Z) uncompress "$1" ;;
		*) echo "'$1' cannot be extracted." ;;
	esac
	else
		echo "'$1' is not a file."
	fi
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

cdw() { cd "${WGPATH}"; }

alias ..='cd ..'
alias ...='cd ../../'

#------------------------------------------////
# HIDDEN SOURCE:
#------------------------------------------////
source "${WGPATH}/setup/source/git.sh"
source "${WGPATH}/setup/source/repo.sh"

#------------------------------------------////
# INITIAL:
#------------------------------------------////
if [ -z "${WGCACHE}" ] || [ ! -d "${WGCACHE}" ]; then
	export WGCACHE="$HOME/AppData/Local/Temp"
fi

printf "%s ${yellow}%s${nc}\n" "WGPATH     >" "   [${WGPATH}]"
printf "%s ${yellow}%s${nc}\n" "WGCACHE    >" "   [${WGCACHE}]"

builtin cd ~