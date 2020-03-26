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
	if [ $? -eq 0 ]; then
		echo -e "[${green}${WGPATH}/tmp/${archive}.zip${nc}]\n"
	else
		echo -e "[${red}${WGPATH}/tmp/${archive}.zip${nc}]\n"
	fi
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

update() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of parameters"
else
	local i
	local in=`realpath .`
	local ext=zip


	local url0="http://nagyg.ddns.net:17600/workgroup/win"

	for i in "${@}"; do
		curl -sSf $url0/${i}.${ext} > /dev/null
		if [ $? -eq 23 ]; then
			local path=`realpath "${WGPATH}/${i}"`
			if [ -d "$path" ]; then
				builtin cd "$path"
			else
				mkdir "$path"
				builtin cd "$path"
			fi
			curl $url0/${i}.${ext} --output ./${i}.${ext}
			7za x ${i}.${ext} -r -aoa && rm ${i}.${ext}
				if [ $? -eq 0 ]; then
					echo -e "[${green}$url0/${i}.${ext}${nc}]	${green}>> ${i}${nc}\n"
				else
					echo -e "[${red}$url0/${i}.${ext}${nc}]\n"
				fi
		else
			echo -e "[${red}$url0/${i}.${ext}${nc}]\n"
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
