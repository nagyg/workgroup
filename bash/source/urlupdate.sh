#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# URL update:
#--------------------------------------------------------------------------------------------------////

export url1="http://nagyg.ddns.net:17600/workgroup"

update() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of parameters"
else
	local in=`realpath .`
	local i
	for i in "${@}"; do
		curl -is $url1/${i}.zip
		if [ $? -ne 0 ]; then
			local path=`realpath "${WGPATH}/${i}"`
			if [ -d "$path" ]; then
				builtin cd "$path"
			else
				mkdir "$path"
				builtin cd "$path"
			fi
			curl $url1/${i}.zip --output ./${i}.zip
			7za x ${i}.zip -r -aoa && rm ${i}.zip
			echo -e "\n[${green}$url1/${i}.zip${nc}]	>> ${i}\n"
		else
			echo -e "[${red}$url1/${i}.zip${nc}]\n"
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
