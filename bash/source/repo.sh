#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# URL repo:
#--------------------------------------------------------------------------------------------------////

export url0="http://nagyg.ddns.net:17600/workgroup"

update() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of parameters"
else
	local in=`realpath .`
	local i
	for i in "${@}"; do
		curl -is $url0/${i}.zip
		if [ $? -ne 0 ]; then
			local path=`realpath "${WGPATH}/${i}"`
			if [ -d "$path" ]; then
				builtin cd "$path"
			else
				mkdir "$path"
				builtin cd "$path"
			fi
			curl $url0/${i}.zip --output ./${i}.zip
			7za x ${i}.zip -r -aoa && rm ${i}.zip
			echo -e "\n[${green}$url0/${i}.zip${nc}]	>> ${i}\n"
		else
			echo -e "[${red}$url0/${i}.zip${nc}]\n"
		fi
	done
	builtin cd "$in"
fi
}

#------------------////
# alias:
#------------------////
alias update.blackmagic='update blackmagic'
alias update.ffmpeg='update ffmpeg'
alias update.plugins='update plugins'
alias update.project='update project'
alias update.sidefx='update sidefx'
alias update.solidangle='update solidangle'
alias update.tweaksoftware='update tweaksoftware'
alias update.vscode='update vscode'

alias update.all='update blackmagic ffmpeg plugins project sidefx solidangle tweaksoftware vscode'
