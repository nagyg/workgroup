#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# FUSION environment:
#--------------------------------------------------------------------------------------------------////
fscan() {
	unset all_fversion
	local d i
	local fusion_dir="${FDIR}/Fusion "
	for d in "${fusion_dir}"* ; do
		if [ -f "$d/Fusion.exe" ]; then
			all_fversion+=(`echo ${d##${fusion_dir}}`)
		fi
	done
	# sort by version
	all_fversion=($(for i in "${all_fversion[@]}"; do echo "$i"; done | sort -Vr))
}

fversion() {
    fscan
if [ ${#all_fversion[@]} != 0 ]; then
	echo ==========================================================================
	echo -e " List exist ${blue}Fusion${nc} in [${FDIR}] directory."
	echo
	createmenu "${all_fversion[@]}"
	echo
	fsetenv 2> /dev/null
	edit.profile "FVERSION" "$FVERSION"
	echo ==========================================================================
else
	local format="${red}%s %24s${nc}\n"
	printf "$format" "Fusion    >" "|| Not found"
fi
}

fsetenv() {
if [ -f "${FDIR}/Fusion ${FVERSION}/Fusion.exe" ] && [ -n "${FVERSION}" ]; then

	pathremove "${FBin}"
	export FBin="${FDIR}/Fusion ${FVERSION}"
	pathadd "${FBin}"

    case "${FVERSION}" in
	"9")
		export FUSION9_MasterPrefs="$(cygpath -w "${WGPATH}/blackmagic/fusion/${FVERSION}/masterprefs/Master.prefs")"
		export OFX_PLUGIN_PATH="$(cygpath -w "${WGPATH}/plugins/ofx/fusion/${FVERSION}")"
		sapphire 2019.52
		cryptomatte
		;;	
	"16")
		export FUSION16_MasterPrefs="$(cygpath -w "${WGPATH}/blackmagic/fusion/${FVERSION}/masterprefs/Master.prefs")"
		export OFX_PLUGIN_PATH="$(cygpath -w "${WGPATH}/plugins/ofx/fusion/${FVERSION}")"
		sapphire 2019.52
        cryptomatte
		;;
	*)
		local format="%s ${red}%11s${nc} %s\n"
		printf "$format" "Fusion    >" "${FVERSION}" "|| is not defined fusion version"
		return ;;
esac

	local format="%s ${green}%11s${nc} %s\n"
	printf "$format" "Fusion    >" "${FVERSION}" "||"
else
	fversion
fi
}

#--------------------------------------------------------------------------------------------------////
# SAPPHIRE:
#--------------------------------------------------------------------------------------------------////
sapphire() {
	export SAPPHIRE_OFX_DIR="$(cygpath -w "${WGPATH}/plugins/borisfx/sapphire/$1")"
	export LD_LIBRARY_PATH="$(cygpath -w "${WGPATH}/plugins/borisfx/sapphire/$1/lib64")"

	local GenartsData="$(cygpath -w "${ProgramData}/GenArts")"
	if [ ! -d "${GenartsData}" ]; then mkdir -p "${GenartsData}"; fi
}

#--------------------------------------------------------------------------------------------------////
# CRYPTOMATTE:
#--------------------------------------------------------------------------------------------------////
cryptomatte() {
	export LUA_PATH="$(cygpath -w "${WGPATH}/plugins/cryptomatte/fusion/Modules/Lua/cryptomatte_utilities.lua")"
}

#----------------------////
# RUN:
#----------------------////
f() {
Fusion.exe &
}

#----------------------////
# Fusion MasterPrefs:
#----------------------////
edit.masterprefs() {
	local d
    local wgpath_forfusion="$(echo "$(cygpath -w "${WGPATH}")" | sed 's|\\|\\\\\\\\|g' )"
	local fusion_dir="${WGPATH}/blackmagic/fusion/"
	for d in "${fusion_dir}"* ; do
		if [ -f "$d/masterprefs/Master.prefs" ]; then
            local file="$d/masterprefs/Master.prefs"
            sed -i "/\[\"WG\:\"\]\ \=\ /c\\\t\t\t\t\[\"WG\:\"\]\ \=\ \"${wgpath_forfusion}\"\," "${file}"
		fi
	done
}

#--------------------------------------------------------------------------------------------------////
# FUSION INITIAL:
#--------------------------------------------------------------------------------------------------////
if [ -z "${FDIR}" ]; then
	export FDIR="/c/Program Files/Blackmagic Design"
fi

fsetenv
edit.masterprefs