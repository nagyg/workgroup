#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# URL repo:
#--------------------------------------------------------------------------------------------------////

export url="http://nagyg.ddns.net:17600/workgroup/win"

repo.archive() {
local dir arg
local in=`realpath .`
local archive_dir="${WGPATH}/"
local ext=tar.gz

function repo.tar {
local tmp=${WGPATH}/tmp
mkdir -p "${tmp}"
if [ -f "$dir/.repoignore" ]; then
	builtin cd "$dir"
	tar -zcvf "${tmp}/${archive}.tar.gz" -X "$dir/.repoignore" .
	if [ $? -eq 0 ]; then
		echo -e "[${green}${tmp}/${archive}.${ext}${nc}]\n"
	else
		echo -e "[${red}tar exit [$?] ${tmp}/${archive}.${ext}${nc}]\n"
	fi
else
	echo -e "[${dir}]	>> .repoignore file not found"
fi
}

if [ "$#" == 0 ]; then
	for dir in "${archive_dir}"* ; do
		local archive=${dir##${archive_dir}}
		repo.tar
	done
else
	for arg in "${@}"; do
		local archive=$arg
		local dir=${WGPATH}/$arg
		repo.tar
	done
fi
builtin cd "$in"
}

update() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of parameters"
else
	local i
	local ext=tar.gz

	for i in "${@}"; do
		wget -q --spider $url/${i}.${ext} > /dev/null
		if [ $? -eq 0 ]; then

			local path=`realpath "${WGPATH}/${i}"`

			wget -N $url/${i}.${ext} -P "${path}"
			tar -xf ${path}/${i}.${ext} -C ${path} && rm ${path}/${i}.${ext}
				if [ $? -eq 0 ]; then
					echo -e "[${green}$url/${i}.${ext}${nc}]	${green}>> ${i}${nc}\n"
				else
					echo -e "[${red}tar exit [$?] $url/${i}.${ext}${nc}]\n"
				fi
		else
			echo -e "[${red}wget exit [$?] $url/${i}.${ext}${nc}]\n"
		fi
	done
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
alias update.redshift='update redshift'
alias update.tweaksoftware='update tweaksoftware'
alias update.vscode='update vscode'

alias update.all='update blackmagic ffmpeg plugins project sidefx solidangle redshift tweaksoftware vscode'
