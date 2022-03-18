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
		if [ -d "$JOB/Asset" ]; then export ASSETDIR="$JOB/Asset"; fi;

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
   		echo "Usage  : mkproj [OPTION]... [DESTINATION DIR]"
   		echo
   		echo "Options:"
   		echo "--level, -l      Set project level (0 or 1)"
   		echo
   		echo "Syntax : [ mkproj --level 0 ~/testproj ]"
		echo "         [ mkproj -l 1 ~/testproj ]"
	}

if [ "$#" -ne 3 ]; then
	mkproj.help
else
	function make.proj {
		local path=`realpath "${3}"`
		if [ ! -d "$path" ]; then
			cp -r "${WGPATH}/project/proj${2}" "$path"
			job "$path"
		else
			echo "bash: $path: directory exists"
		fi
	}

	if [ "$1" == "--level" ] || [ "$1" == "-l" ]; then
		case "$2" in
			"0")
				make.proj $@
				mk3d > /dev/null 2>&1 ;;
			"1")
				make.proj $@ ;;
			*)
				echo "bash: invalid level argument" ;;
		esac	
	else
		echo "bash: --level argument missing"
	fi
fi
}

mkscene() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of arguments"
else
	if [ -d "$JOB/Scene" ]; then
		builtin cd "$JOB/Scene"
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

mk3d() {
if [ -d "$JOB" ]; then
	builtin cd "$JOB"
	local path=`realpath "$JOB/3D"`
	if [ ! -d "$path" ]; then
		cp -r "${WGPATH}/project/3D" "$path"
		job "$JOB"
		printf "%s ${blue}%s${nc}\n" "3D         >" "${path}"
	else
		echo "bash: $path: directory exists"
	fi
else
	echo "bash: JOB variable zero or directory not exists"
fi
}

# some more cd aliases
cdj() { cd "$JOB/$1"; }
cda() { cd "$ASSETDIR/$1"; }
cds() { cd "$JOB/Scene/$1"; }

#------------------------------------------////
# INITIAL:
#------------------------------------------////
job "$JOB"
