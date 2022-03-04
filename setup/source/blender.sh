#!/bin/bash
# I found a way to get the updated environment variables, but is a workaround.
# In this file scripts\modules\addon_utils.py replace this function:
# line:50, only the # BLENDER_USER_ADDONS bit is needed
# MELON Fx
#    import os
#    if 'BLENDER_USER_ADDONS' in os.environ:
#        envpaths = os.environ['BLENDER_USER_ADDONS'].split(os.pathsep)
#        for p in envpaths:
#            if os.path.isdir(p):
#                addon_paths.append(os.path.normpath(p))
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
if [ -z "${Bsuppredshift}" ] || [ ${Bsuppredshift} = 0 ]; then
	echo -e "${red}${RVERSION} Redshift not working with Blender ${BVERSION}${nc}"
	rlist
else

	local path="$(cygpath -w "${WGPATH}/blender/addons/${BVERSION}")"
	export BLENDER_USER_ADDONS="$path"

    bstart
fi
}

#-----------------------////
# Function:
#-----------------------////

#--------------------------------------------------------------------------------------------------////
# INITIAL:
#--------------------------------------------------------------------------------------------------////
export BDIR="${WGPATH}/blender/apps"

if [ -d "${BDIR}" ]; then
	bsetenv
fi
