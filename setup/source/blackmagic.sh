#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# FUSION environment:
#--------------------------------------------------------------------------------------------------////
fscan() {
	unset all_fversion
	local d i
	local fusion_dir="${BMDIR}/Fusion "
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
	echo -e " List exist ${blue}Fusion${nc} in [${BMDIR}] directory."
	echo
	createmenu "${all_fversion[@]}"
	echo
	fsetenv 2> /dev/null
	edit.profile "FVERSION" "$FVERSION"
	echo ==========================================================================
else
	local format="${red}%s %14s${nc}\n"
	printf "$format" "Blackmagic >" "Not found ||"
fi
}

fsetenv() {
if [ -f "${BMDIR}/Fusion ${FVERSION}/Fusion.exe" ] && [ -n "${FVERSION}" ]; then

	fusion_profiles_dir="$(cygpath -u "$APPDATA\Blackmagic Design\Fusion\Profiles")"
	cp -u "${WGPATH}/blackmagic/masterprefs/${FVERSION}/workgroup.prefs" "${fusion_profiles_dir}/Default"

    case "${FVERSION}" in
	"9")
		export FUSION9_MasterPrefs="$(cygpath -w "${fusion_profiles_dir}/Default/workgroup.prefs")"
		export OFX_PLUGIN_PATH="$(cygpath -w "${WGPATH}/plugins/ofx/fusion/${FVERSION}")"
		sapphire 2019.52
		cryptomatte

		unset FUSION16_MasterPrefs
		;;	
	"16")
		export FUSION16_MasterPrefs="$(cygpath -w "${fusion_profiles_dir}/Default/workgroup.prefs")"
		export OFX_PLUGIN_PATH="$(cygpath -w "${WGPATH}/plugins/ofx/fusion/${FVERSION}")"
		sapphire 2019.52
		cryptomatte

		unset FUSION9_MasterPrefs
		;;
	*)
		local format="%s ${red}%11s${nc} %s\n"
		printf "$format" "Blackmagic >" "${FVERSION}" "|| is not defined fusion version"
		return ;;
esac

	#pathremove "${FBin}"
	#export FBin="${BMDIR}/Fusion ${FVERSION}"
	#pathadd "${FBin}"

	edit.fusionprefs FVERSION "${FVERSION}"
	edit.fusionprefs WG "$WGPATH"
	edit.fusionprefs JOB "$JOB"

	if [ -f "${BMDIR}/DaVinci Resolve/Resolve.exe" ]; then
		local supresolve=1

		#pathremove "${RBin}"
		#export RBin="${BMDIR}/DaVinci Resolve"
		#pathadd "${RBin}"

		if [ -f "/c/Python27/python.exe" ] && [ -d "/c/ProgramData/Blackmagic Design/DaVinci Resolve/Support/Developer" ]; then
			local resolvedev="$(cygpath -w "/c/ProgramData/Blackmagic Design/DaVinci Resolve/Support/Developer/Scripting")"
			export PYTHONPATH="$resolvedev\Modules;$resolvedev\Examples;$PYTHONPATH"
			export RESOLVE_SCRIPT_LIB="$(cygpath -w "${BMDIR}/DaVinci Resolve/fusionscript.dll")"
		fi

	else
		local supresolve=0
	fi

		local format="%s ${green}%11s${nc} %s $(switch.color $supresolve)%s${nc}\n"
		printf "$format" "Blackmagic >" "Fusion ${FVERSION}" "||" "RESOLVE"

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
	local in=`realpath .`
	builtin cd "${BMDIR}/Fusion ${FVERSION}"
	"${BMDIR}/Fusion ${FVERSION}/Fusion.exe" &
	builtin cd "$in"
}

r() {
	local in=`realpath .`
	builtin cd "${BMDIR}/DaVinci Resolve"
	"${BMDIR}/DaVinci Resolve/Resolve.exe" &
	builtin cd "$in"
}


#----------------------////
# Fusion MasterPrefs:
#----------------------////
edit.fusionprefs() {
	local d
	local path_forfusion="$(echo "$(cygpath -w "${2}")" | sed 's|\\|\\\\\\\\|g' )"
	local prefs_dir=${fusion_profiles_dir}
	for d in "${prefs_dir}/"* ; do
		if [ -f "$d/workgroup.prefs" ]; then
           local file="$d/workgroup.prefs"
            sed -i "/\[\"${1}\:\"\]\ \=\ /c\\\t\t\t\t\[\"${1}\:\"\]\ \=\ \"${path_forfusion}\"\," "${file}"
		fi
	done
}

#--------------------------------------------------------------------------------------------------////
# FUSION INITIAL:
#--------------------------------------------------------------------------------------------------////
if [ -z "${BMDIR}" ]; then
	export BMDIR="/c/Program Files/Blackmagic Design"
fi

fsetenv