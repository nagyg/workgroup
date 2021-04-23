#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# HOUDINI environment:
#--------------------------------------------------------------------------------------------------////
hscan() {
	unset all_hversion
	local d i
	local hfs_dir="${HDIR}/Houdini "
	for d in "${hfs_dir}"* ; do
		if [ -f "$d/bin/houdini.exe" ]; then
			all_hversion+=(`echo ${d##${hfs_dir}}`)
		fi
	done
	# sort by version
	all_hversion=($(for i in "${all_hversion[@]}"; do echo "$i"; done | sort -Vr))
}

hversion() {
	hscan
if [ ${#all_hversion[@]} != 0 ]; then
	echo ==========================================================================
	echo -e " List exist ${blue}Houdini${nc} in [${HDIR}] directory."
	echo
	createmenu "${all_hversion[@]}"
	echo
	rsetenv > /dev/null 2>&1
	asetenv > /dev/null 2>&1
	hsetenv
	edit.profile "HVERSION" "$HVERSION"
	echo ==========================================================================
else
	local format="${red}%s %14s${nc}\n"
	printf "$format" "Houdini    >" "Not found ||"
fi
}

hsetenv() {
export HFS="${HDIR}/Houdini ${HVERSION}"
if [ -d "${HFS}" ]; then

	pathremove "${HB}"
	export HB="${HFS}/bin"
	pathadd "${HB}"

	export H="${HFS}"
	export HH="${H}/houdini"
	export HHC="${HH}/config"
	export HT="${H}/toolkit"

	export HOUDINI_MAJOR_RELEASE=${HVERSION:0:2}
	export HOUDINI_MINOR_RELEASE=${HVERSION:3:1}
	export HOUDINI_BUILD_VERSION=${HVERSION:5}
	export HOUDINI_RELEASE_VERSION=${HVERSION:0:4}

	export HOUDINI_DSO_ERROR=2
	export HOUDINI_EXTERNAL_HELP_BROWSER=1

	export HSITE="$(cygpath -w "${WGPATH}/sidefx/HSITE")"

	unset HOUDINI_PATH HOUDINI_OTLSCAN_PATH

	hplug.mlnlib
	hplug.qlib
	hplug.sidefxlabs
	hplug.mops

	#-----------------------////
	# FCK PLUGINS
	#-----------------------////
	if [ "${expreditor[0]}" == "true" ]; then
		hplug.expreditor
	fi

	if [ "${magascans[0]}" == "true" ]; then
		hplug.magascans
	fi

	if [ "${modeler[0]}" == "true" ]; then
		hplug.modeler
	fi

	if [ "${groombear[0]}" == "true" ]; then
		hplug.groombear
	fi

	hplug.axiom

	#HOUDINI_PATH safe end
	export HOUDINI_PATH="${HOUDINI_PATH};&"
	export HOUDINI_OTLSCAN_PATH="${HOUDINI_OTLSCAN_PATH};&"

	htoa_env=false
	htor_env=false

	local format="%s ${green}%11s${nc} %s $(switch.color $supphtoa)%s${nc} %s $(switch.color $suppredshift)%s${nc}\n"
	printf "$format" "Houdini    >" "${HVERSION}" "||" "ARNOLD" "|" "REDSHIFT"

else
	unset HFS
	hversion
fi
}

hstart() {
	if [[ -z $1  ]]; then
		# no args: just start houdini
		houdini &
	elif [[ "$1" = '-envonly' ]]; then
		# don't run houdini
		echo 'Environment is set for ARNOLD or REDSHIFT';
	else 
		# run houdini and pass all args
		houdini "${@}" &
	fi
}
#-----------------------////
# mlnLib:
#-----------------------////
hplug.mlnlib() {
	export MLNLIB="$HSITE\mlnLib"
	export HOUDINI_PATH="$MLNLIB"
}

#-----------------------////
# qLib:
#-----------------------////
hplug.qlib() {
	export QLIB="$HSITE\qLib"
	export QOTL="$QLIB\otls"

	export HOUDINI_PATH="$QLIB;${HOUDINI_PATH}"
	export HOUDINI_OTLSCAN_PATH="$QOTL\base;$QOTL\future;$QOTL\experimental"
}

#-----------------------////
# SideFXLabs:
#-----------------------////
hplug.sidefxlabs() {
	export SIDEFXLABS="$HSITE\sidefxlabs"

	export HOUDINI_PATH="$SIDEFXLABS;${HOUDINI_PATH}"
}

#-----------------------////
# MOPs:
#-----------------------////
hplug.mops() {
	export MOPS="$HSITE\mops"

	export HOUDINI_PATH="$MOPS;${HOUDINI_PATH}"
}

#-----------------------////
# Houdini ExprEditor:
#-----------------------////
hplug.expreditor () {
local path="${HSITE}\expreditor\\${expreditor[1]}"
	export HOUDINI_PATH="$path;${HOUDINI_PATH}"
	export EDITOR="${WGPATH}/vscode/VSCode-win32-x64/Code.exe"
}

#-----------------------////
# Quixel Megascans:
#-----------------------////
hplug.megascans () {
local path="$HSITE\magascans\\${magascans[1]}\MSLiveLink"
if [ -d "$(cygpath -u "${path}")" ]; then
	export MS_HOUDINI_PATH="$(cygpath -w "$path\scripts\python\MSPlugin")"
	export HOUDINI_PATH="$path;${HOUDINI_PATH}"
fi
}

#-----------------------////
# Axiom Solver:
#-----------------------////
hplug.axiom () {
local path="$HSITE\axiom\\${HVERSION}"
if [ -d "$(cygpath -u "${path}")" ]; then
	export HOUDINI_PATH="$path;${HOUDINI_PATH}"
fi
}

#-----------------------////
# Modeler:
#-----------------------////
hplug.modeler () {
local path="${HSITE}\modeler\\${modeler[1]}\modeler"
	export MODELER_PATH="$path"
	export HOUDINI_PATH="$path;${HOUDINI_PATH}"
}

#-----------------------////
# GROOMBEAR:
#-----------------------////
hplug.groombear () {
local path="${HSITE}\groombear\\${groombear[1]}"
if [ -d "$(cygpath -u "${path}")" ]; then
	export GROOMBEAR_PATH="$path"
	export GROOMBEAR_ICONS="$path\icons"
	export HOUDINI_PATH="$path;${HOUDINI_PATH}"
fi
}

#-----------------------////
# RUN:
#-----------------------////
h() {
if [ "${htoa_env}" == "true" ]; then
	asetenv &> /dev/null
	hsetenv &> /dev/null
fi
if [ "${htor_env}" == "true" ]; then
	hsetenv &> /dev/null
fi
hstart
}

ha() {
if [ -z "${supphtoa}" ] || [ ${supphtoa} = 0 ]; then
	echo -e "${red}${AVERSION} Arnold not working with Houdini ${HVERSION}${nc}"
	alist
else

	hsetenv &> /dev/null

	pathremove "${ARNOLD_BINDIR}"
	export ARNOLD_BINDIR="${htoa_path}/scripts/bin"
	pathadd "${ARNOLD_BINDIR}"

	local path="$(cygpath -w "${htoa_path}")"

	export HOUDINI_PATH="$path;${HOUDINI_PATH}"

	htoa_env=true

    hstart
fi
}

hr() {
if [ -z "${suppredshift}" ] || [ ${suppredshift} = 0 ]; then
	echo -e "${red}${RVERSION} Redshift not working with Houdini ${HVERSION}${nc}"
	rlist
else

	hsetenv &> /dev/null

	pathremove "${REDSHIFT_COREDATAPATH}/bin"
	export REDSHIFT_COREDATAPATH="${htor_path}"
	pathadd "${REDSHIFT_COREDATAPATH}/bin"

	local path="$(cygpath -w "${htor_path}/Plugins/Houdini/${HVERSION}")"
	export HOUDINI_PATH="$path;${HOUDINI_PATH}"

	local pxrpath="$(cygpath -w "${htor_path}/Plugins/Solaris/${HVERSION}")"
	export PXR_PLUGINPATH_NAME="${pxrpath};&"

	export REDSHIFT_RV_OPEN_ONLY=1

	htor_env=true

    hstart
fi
}

#-----------------------////
# Function:
#-----------------------////
pathhshow () { printenv HOUDINI_PATH | sed 's|;|\n|g'; }

cdhsite() { cd $HSITE; }

hrop() {
local rop
for rop in "${@}"; do
	if [ "$rop" == "$1" ]; then
		continue
	else
		cmd //c "echo render -C -V -I $rop | hbatch $1"
	fi
done
}

lasthip() {
local history="~/houdini${HOUDINI_RELEASE_VERSION}/file.history"
if [ -f "$history" ]; then
    while read line ; do
	    case $line in
		    *"}"*)
		    break ;;
		    *)
		    local lasthip="$line" ;;
	    esac
    done < "$history"
echo $lasthip
fi
}

h.last() { echo -e "lasthip >> [${blue}`lasthip`${nc}]"; h "`lasthip`"; }

ha.last() { echo -e "lasthip >> [${blue}`lasthip`${nc}]"; ha "`lasthip`"; }

hr.last() { echo -e "lasthip >> [${blue}`lasthip`${nc}]"; hr "`lasthip`"; }

hrop.last() { echo -e "lasthip >> [${blue}`lasthip`${nc}] | rop [${blue}"$@"${nc}]"; hrop "`lasthip`" ${@}; }

#--------------------------------------------------------------------------------------------------////
# INITIAL:
#--------------------------------------------------------------------------------------------------////
if [ -z "${HDIR}" ]; then
	export HDIR="/c/Program Files/Side Effects Software"
fi
hsetenv