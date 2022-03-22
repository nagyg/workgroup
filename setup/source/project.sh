#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# Project environment:
#--------------------------------------------------------------------------------------------------////
job () {
if [ "$#" == 0 ]; then
	printf "%s ${yellow}%s${nc}\n" "JOB        >" "${JOB}"
else
	local path=`realpath "$1" 2> /dev/null`
	if [ -d "$path" ]; then

		export JOB="$path"
		
		if [ ! -f "$path/job_env.py" ]; then cp -r "${WGPATH}/project/proj0/job_env.py" "$path"; fi
		edit.profile "export JOB" "$JOB" 2> /dev/null
		edit.fusionprefs JOB "$JOB" 2> /dev/null

		if [ -d "$JOB/3D/Asset" ]; then export ASSETDIR="$JOB/3D/Asset"; fi;
		if [ -d "$JOB/3D/Scene" ]; then export SCENEDIR="$JOB/3D/Scene"; fi;

		job
	else
		unset JOB
		edit.profile "export JOB" "$JOB" 2> /dev/null
		edit.fusionprefs JOB "$JOB" 2> /dev/null
		printf "%s ${yellow}%11s${nc} %s\n" "JOB        >" "Empty" "||"
	fi
fi
}

mkproj() {

	function mkproj.help {
   		echo "Usage  : mkproj [DESTINATION DIR]"
   		echo "Syntax : mkproj ~/testproj"
	}

if [ "$#" -ne 1 ]; then
	mkproj.help
else
	local path=`realpath "${1}"`
	if [ ! -d "$path" ]; then
		cp -r "${WGPATH}/project/proj" "$path"
		job "$path"
	else
		echo "bash: $path: directory exists"
	fi
fi
}

mkscene() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of arguments"
else
	if [ -d "${SCENEDIR}" ] && [ -n "${SCENEDIR}" ]; then
		builtin cd "${SCENEDIR}"
		local i
		for i in "${@}"; do
		local path=`realpath "${i}"`
		if [ ! -d "${i}" ]; then
			cp -r "${WGPATH}/project/scene" "$path"
			echo -e "${i}	>> [${blue}${path}${nc}]"
		else
			echo "bash: $path: directory exists"
		fi
		done
	else
		echo "bash: $JOB/Scene directory not exists"
	fi
fi
}

mkasset() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of arguments"
else
	if [ -d "${ASSETDIR}" ] && [ -n "${ASSETDIR}" ]; then
		builtin cd "${ASSETDIR}"
		local i
		for i in "${@}"; do
		local path=`realpath "${i}"`
		if [ ! -d "${i}" ]; then
			cp -r "${WGPATH}/project/asset" "$path"
			echo -e "${i}	>> [${blue}${path}${nc}]"
		else
			echo "bash: $path: directory exists"
		fi
		done
	else
		echo "bash: ASSETDIR directory not exists"
	fi
fi
}

# some more cd aliases
cdj() { cd "$JOB/$1"; }
cda() { cd "$ASSETDIR/$1"; }
cds() { cd "$JOB/3D/Scene/$1"; }

#------------------------------------------////
# INITIAL:
#------------------------------------------////
job "$JOB"
