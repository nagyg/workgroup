#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# BLENDER environment:
#--------------------------------------------------------------------------------------------------////
bscan() {
	unset all_bversion
	local d i
	local bfs_dir="${BDIR}/Blender "
	for d in "${bfs_dir}"* ; do
		if [ -f "$d/blender.exe" ]; then
			all_bversion+=(`echo ${d##${bfs_dir}}`)
		fi
	done
	# sort by version
	all_bversion=($(for i in "${all_bversion[@]}"; do echo "$i"; done | sort -Vr))
}

bversion() {
	bscan
if [ ${#all_bversion[@]} != 0 ]; then
	echo ==========================================================================
	echo -e " List exist ${blue}Blender${nc} in [${BDIR}] directory."
	echo
	createmenu "${all_bversion[@]}"
	echo
	rsetenv > /dev/null 2>&1
	bsetenv
	edit.profile "BVERSION" "$BVERSION"
	echo ==========================================================================
else
	local format="${red}%s %14s${nc}\n"
	printf "$format" "Blender    >" "Not found ||"
fi
}

bsetenv() {
export BFS="${BDIR}/Blender ${BVERSION}"
if [ -d "${BFS}" ]; then

	pathremove "${BB}"
	export BB="${BFS}"
	pathadd "${BB}"

	btor_env=false

    local format="%s ${green}%11s${nc} %s $(switch.color $Bsuppredshift)%s${nc}\n"
	printf "$format" "Blender    >" "${BVERSION}" "||" "REDSHIFT"

else
	unset BFS
	bversion
fi
}

#-----------------------////
# RUN:
#-----------------------////
bstart() {
    blender "${@}" &
}

b() {
if [ "${btor_env}" == "true" ]; then
	bsetenv &> /dev/null
fi
bstart
}

br() {
if [ -z "${Bsuppredshift}" ] || [ ${Bsuppredshift} = 0 ]; then
	echo -e "${red}${RVERSION} Redshift not working with Blender ${BVERSION}${nc}"
	rlist
else

	bsetenv &> /dev/null

	local path="$(cygpath -w "${REDSHIFT_COREDATAPATH}/Plugins/Blender/${BVERSION}")"
	export BLENDER_ADDONS_PATH="$path"

	btor_env=true

    bstart
fi
}

#-----------------------////
# Function:
#-----------------------////

#--------------------------------------------------------------------------------------------------////
# INITIAL:
#--------------------------------------------------------------------------------------------------////
if [ -z "${BDIR}" ]; then
	export BDIR="/c/Program Files/Blender Foundation"
fi

#if [ -z "${DISKCACHE}" ]; then
#	export DISKCACHE_BLENDER="$(cygpath -u "$HOME/AppData/Local/Temp")"
#else
#	export DISKCACHE_BLENDER="$(cygpath -u "$DISKCACHE/Blender")"
#fi

bsetenv