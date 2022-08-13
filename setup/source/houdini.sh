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
if [ -d "${WGCACHE_HOUDINI}/apps/Houdini ${HVERSION}" ]; then
	export HFS="${WGCACHE_HOUDINI}/apps/Houdini ${HVERSION}"
else
	export HFS="${HDIR}/Houdini ${HVERSION}"
fi

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
	export EDITOR=code.exe

	export HSITE="$(cygpath -w "${WGPATH}/sidefx/HSITE")"
	export HOUDINI_TEMP_DIR="$(cygpath -w "${WGCACHE_HOUDINI}/temp")"
	
	unset package_success package_fail HOUDINI_PATH HOUDINI_OTLSCAN_PATH ROSL

	#-----------------------////
	# ADDONS
	#-----------------------////
	if [ "${mlnlib}" == "true" ]; then
		package.mlnlib
	fi

	if [ "${qlib}" == "true" ]; then
		package.qlib
	fi

	if [ "${sidefxlabs}" == "true" ]; then
		package.sidefxlabs
	fi

	if [ "${mops}" == "true" ]; then
		package.mops
	fi

	if [ "${axiom}" == "true" ]; then
		package.axiom
	fi

	if [ "${megascans}" == "true" ]; then
		package.megascans
	fi

	if [ "${odtools}" == "true" ]; then
		package.odtools
	fi

	if [ "${modeler}" == "true" ]; then
		package.modeler
	fi

	if [ "${groombear}" == "true" ]; then
		package.groombear
	fi

	# HOUDINI_PATH safe end
	export HOUDINI_PATH="${HOUDINI_PATH};&"
	export HOUDINI_OTLSCAN_PATH="${HOUDINI_OTLSCAN_PATH};&"

	htoa_env=false
	htor_env=false

	local format="%s ${green}%11s${nc} %s $(switch.color $Hsuppredshift)%s${nc} %s $(switch.color $supphtoa)%s${nc}\n"
	printf "$format" "Houdini    >" "${HVERSION}" "||" "REDSHIFT" "|" "ARNOLD"

else
	unset HFS
	hversion
fi
}

hpathadd() {
	if [ -z "${HOUDINI_PATH}" ]; then
		export HOUDINI_PATH="$1"
	else
		export HOUDINI_PATH="$1;${HOUDINI_PATH}"
	fi
}

#-----------------------////
# mlnLib:
#-----------------------////
package.mlnlib() {
local path="$HSITE\mlnLib"
local name=mlnLib
if [ -d "$(cygpath -u "${path}")" ]; then
	export MLNLIB="$path"
	hpathadd "$path"
	package_success+=($name)
else
	package_fail+=($name)
fi
}

#-----------------------////
# qLib:
#-----------------------////
package.qlib() {
local path="$HSITE\qLib"
local name=qLib
if [ -d "$(cygpath -u "${path}")" ]; then
	export QLIB="$path"
	export QOTL="$QLIB\otls"
	export HOUDINI_OTLSCAN_PATH="$QOTL\base;$QOTL\future;$QOTL\experimental"
	hpathadd "$path"
	package_success+=($name)
else
	package_fail+=($name)
fi
}

#-----------------------////
# SideFXLabs:
#-----------------------////
package.sidefxlabs() {
local path="$HSITE\sidefxlabs\\${HVERSION}"
local name=sidefxLabs
if [ -d "$(cygpath -u "${path}")" ]; then
	export SIDEFXLABS="$path"
	hpathadd "$path"
	package_success+=($name)
else
	package_fail+=($name)
fi
}

#-----------------------////
# MOPs:
#-----------------------////
package.mops() {
local path="$HSITE\mops"
local name=MOPS
if [ -d "$(cygpath -u "${path}")" ]; then
	export MOPS="$path"
	hpathadd "$path"
	package_success+=($name)
else
	package_fail+=($name)
fi
}

#-----------------------////
# Axiom Solver:
#-----------------------////
package.axiom () {
local path="$HSITE\axiom\\${HVERSION}"
local name=Axiom
if [ -d "$(cygpath -u "${path}")" ]; then
	hpathadd "$path"
	package_success+=($name)
else
	package_fail+=($name)
fi
}

#-----------------------////
# Quixel Megascans:
#-----------------------////
package.megascans () {
local path="$HSITE\megascans\\${HVERSION}\MSLiveLink"
local name=Megascans
if [ -d "$(cygpath -u "${path}")" ]; then
	export MS_HOUDINI_PATH="$path\scripts\python\MSPlugin"
	hpathadd "$path"
	package_success+=($name)
else
	package_fail+=($name)
fi
}

#-----------------------////
# OD Houdini ShelfTools:
#-----------------------////
package.odtools () {
local path="$HSITE\odtools\\${HVERSION}"
local name=ODTools
if [ -d "$(cygpath -u "${path}")" ]; then
	hpathadd "$path"
	package_success+=($name)
else
	package_fail+=($name)
fi
}

#-----------------------////
# Modeler:
#-----------------------////
package.modeler () {
local path="${HSITE}\modeler\\${HVERSION}\modeler"
local name=Modeler
if [ -d "$(cygpath -u "${path}")" ]; then
	export MODELER_PATH="$path"
	export MODELER_MATERIAL_TYPE="principledshader::2.0"
#	export MODELER_ZBRUSH_EXEC_PATH="C:/Program Files/Pixologic/ZBrush 2021/ZBrush.exe"
#	export MODELER_ZBRUSH_CACHE_PATH="C:/z_cache"
	export MODELER_POLYPEN_SCREEN_DELTA=10
	hpathadd "$path"
	package_success+=($name)
else
	package_fail+=($name)
fi
}

#-----------------------////
# GROOMBEAR:
#-----------------------////
package.groombear () {
local path="${HSITE}\groombear\\${HVERSION}"
local name=Groombear
if [ -d "$(cygpath -u "${path}")" ]; then
	export GROOMBEAR_PATH="$(cygpath -u "$path")"
	export GROOMBEAR_ICONS="$(cygpath -u "$path\icons")"
	hpathadd "$path"
	package_success+=($name)
else
	package_fail+=($name)
fi
}

#-----------------------////
# RUN:
#-----------------------////
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

	printf "%s${blue} %s${nc}\n" "Houdini File System     >" "${HFS}"

	if [ ${#package_success[@]} != 0 ]; then
		printf "%s${blue} %s${nc}\n" "Packages in environment >" "${package_success[*]}"
	fi
	if [ ${#package_fail[@]} != 0 ]; then
		printf "%s${red} %s${nc}\n" "Packages not found      >" "${package_fail[*]}"
	fi
}

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
	package_success+=(ARNOLD)

    hstart
fi
}

hr() {
if [ -z "${Hsuppredshift}" ] || [ ${Hsuppredshift} = 0 ]; then
	echo -e "${red}${RVERSION} Redshift not working with Houdini ${HVERSION}${nc}"
	rlist
else

	hsetenv &> /dev/null

	local path="$(cygpath -w "${WGPATH}/sidefx/HtoR/${HVERSION}/Houdini")"
	export HOUDINI_PATH="$path;${HOUDINI_PATH}"

	local pxrpath="$(cygpath -w "${WGPATH}/sidefx/HtoR/${HVERSION}/Solaris")"
	export PXR_PLUGINPATH_NAME="${pxrpath};&"

	export REDSHIFT_RV_OPEN_ONLY=1

	export ROSL="$(cygpath -u "${RDIR}/OSLShaders")"

	htor_env=true
	package_success+=(REDSHIFT)

	hstart
fi
}

htocache() {
	local cachepath="${WGCACHE_HOUDINI}/apps"; mkdir -p "$cachepath"
	echo -e "Destination cache folder: ${yellow}[$cachepath]${nc}"

	hversion
  
	local sourcepath="${HDIR}/Houdini ${HVERSION}"

	if [ -d "${sourcepath}" ] && [ -d "${cachepath}" ]; then	
		rsync --perms --no-p --no-g --chmod=ugo=rwX -rtvh $(cygdrive "${sourcepath}") $(cygdrive "${cachepath}/")
		echo -e "rsync: ${green}[${sourcepath}]${nc} --> ${green}[${cachepath}/Houdini $HVERSION]${nc}"
		hsetenv &> /dev/null
	else
		echo -e "rsync: ${red}[${sourcepath}]${nc} --> ${red}[${cachepath}/Houdini $HVERSION]${nc}"
	fi

	echo "cache:" ; lt "$cachepath"
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

export WGCACHE_HOUDINI="$WGCACHE/Houdini"; mkdir -p "${WGCACHE_HOUDINI}"

hsetenv