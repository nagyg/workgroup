#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# URL repo:
#--------------------------------------------------------------------------------------------------////
repo.archive() {
local d
local in=`realpath .`
local archive_dir="${WGPATH}/"

function 7zazip {
	7za a -tzip "${WGPATH}/tmp/${archive}" -x@.repoignore
	echo -e "[${green}${WGPATH}/tmp${nc}]	>> ${archive}.zip\n"
}

if [ "$#" == 0 ]; then
	for d in "${archive_dir}"* ; do
		local archive=${d##${archive_dir}}
		if [ -f "$d/.repoignore" ]; then
			builtin cd "$d"
			7zazip
		fi
	done
else
	for d in "${@}"; do
		local archive=$d
		if [ -f "${WGPATH}/$d/.repoignore" ]; then
			builtin cd "${WGPATH}/$d"
			7zazip
		else
			echo -e "[${red}${WGPATH}/$d${nc}]	>> .repoignore file not found"
		fi
	done
builtin cd "$in"
fi
}

export url0="http://nagyg.ddns.net:17600/workgroup"

update() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of parameters"
else
	local i
	local in=`realpath .`
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
			echo -e "[${green}$url0/${i}.zip${nc}]	>> ${i}\n"
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
