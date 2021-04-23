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

	fusion_profile_dir="$(cygpath -u "$APPDATA\Blackmagic Design\Fusion\Profiles\Default")"

	if [ ! -d "${fusion_profile_dir}" ]; then mkdir -p "${fusion_profile_dir}"; fi
	cp -u "${WGPATH}/blackmagic/masterprefs/workgroup.prefs" "${fusion_profile_dir}"

	fusion_prefs="${fusion_profile_dir}/workgroup.prefs"

    case "${FVERSION}" in
	"9")
		export FUSION9_MasterPrefs="$(cygpath -w "${fusion_prefs}")"
		export OFX_PLUGIN_PATH="$(cygpath -w "${WGPATH}/plugins/ofx/fusion/${FVERSION}")"
		sapphire 2021.02
		cryptomatte
		
		edit.fusionprefs WGFusion "WG:\blackmagic\masterprefs\9"
		edit.fusionprefs FFmpeg "WG:ffmpeg\ffmpeg-3.4.2-win64-shared"

		unset FUSION16_MasterPrefs
		;;
	"17")
		export FUSION16_MasterPrefs="$(cygpath -w "${fusion_prefs}")"
		export OFX_PLUGIN_PATH="$(cygpath -w "${WGPATH}/plugins/ofx/fusion/${FVERSION}")"
		sapphire 2021.02
		cryptomatte

		edit.fusionprefs WGFusion "WG:\blackmagic\masterprefs\17"
		edit.fusionprefs FFmpeg "WG:ffmpeg\ffmpeg-latest-win64-shared"

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

	edit.fusionprefs "\[\"WG:\"\]" "$WGPATH"
	edit.fusionprefs "\[\"JOB:\"\]" "$JOB"

	if [ -n "${BINSERVER}" ]; then
	edit.fusionprefs Server "$BINSERVER"
	fi

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

	export SAPPHIRE_LOAD_PRESET_PATH="$(cygpath -w "${WGPATH}/plugins/borisfx/GenArts")"
	export SAPPHIRE_SAVE_PRESET_PATH="$(cygpath -w "${WGPATH}/plugins/borisfx/GenArts")"

#	local GenartsData="$(cygpath -w "${ProgramData}/GenArts")"
#	if [ ! -d "${GenartsData}" ]; then mkdir -p "${GenartsData}"; fi
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
if [ -n "${2}" ]; then

	if [[ ${2} == *":"* ]]; then
  		local path_forfusion="$(echo "${2}" | sed 's|\\|\\\\\\\\|g' )"
	else
		local path_forfusion="$(echo "$(cygpath -w "${2}")" | sed 's|\\|\\\\\\\\|g' )"
	fi

	if [ -f "${fusion_prefs}" ]; then
		sed -i "/${1}\ \=\ /c\\\t\t\t\t${1}\ \=\ \"${path_forfusion}\"\," "${fusion_prefs}"
	fi
fi
}

#--------------------------------------------------------------------------------------------------////
# FUSION INITIAL:
#--------------------------------------------------------------------------------------------------////
if [ -z "${BMDIR}" ]; then
	export BMDIR="/c/Program Files/Blackmagic Design"
fi

fsetenv