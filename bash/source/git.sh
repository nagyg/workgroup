#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# git :
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

#--------------------------------------------------------------------------------------------------////
# Download from url :
#--------------------------------------------------------------------------------------------------////
pathadd "${WGPATH}/7za"

export url="http://nagyg.ddns.net:17600/workgroup"

update() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of parameters"
else
	local in=`realpath .`
	local i
	for i in "${@}"; do
		curl -sSf $url/${i}.zip
		if test "$?" != "22"; then
			local path=`realpath "${WGPATH}/${i}"`
			if [ -d "$path" ]; then
				builtin cd "$path"
			else
				mkdir "$path"
				builtin cd "$path"
			fi
			curl $url/${i}.zip --output ./${i}.zip
			7za x ${i}.zip -r -aou && rm ${i}.zip
			echo -e "[${green}$url/${i}.zip${nc}]	>> ${i}"
		else
			echo -e "[${red}$url/${i}.zip${nc}]" 
		fi
	done
	builtin cd "$in"
fi
}

alias update.blackmagic='update blackmagic'
#alias update.cmder='update cmder'
alias update.ffmpeg='update ffmpeg'
alias update.plugins='update plugins'
alias update.project='update project'
alias update.sidefx='update sidefx'
alias update.solidangle='update solidangle'
alias update.tweaksoftware='update tweaksoftware'
alias update.vscode='update vscode'

alias update.all='update blackmagic ffmpeg plugins project sidefx solidangle tweaksoftware vscode'
