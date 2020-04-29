#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# REDSHIFT environment:
#--------------------------------------------------------------------------------------------------////
hr() {
local rsversion=2.6.54
local rssuphversion=18.0.416

if [ "${HVERSION}" == "${rssuphversion}" ]; then

	hsetenv &> /dev/null

	local path="$(cygpath -w "${WGPATH}/redshift/${rsversion}/Plugins/Houdini/${rssuphversion}")"
	export HOUDINI_PATH="$path;${HOUDINI_PATH}"

	pathremove "${REDSHIFT_COREDATAPATH}/bin"
	export REDSHIFT_COREDATAPATH=${WGPATH}/redshift/${rsversion}
	pathadd "${REDSHIFT_COREDATAPATH}/bin"

	#export REDSHIFT_LICENSEPATH=${REDSHIFT_COREDATAPATH}

	htors_env=true

	hstart
else
	echo supported houdini version ${rssuphversion}
fi
}
