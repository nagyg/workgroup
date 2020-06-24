#--------------------------------------------------------------------------------------------------////
# SOFTIMAGE environment:
#--------------------------------------------------------------------------------------------------////
sscan() {
	unset all_sversion
	local d i
	local xsi_dir="${ADSK_HOME}/Softimage "
	for d in "${xsi_dir}"* ; do
		if [ -f "$d/Application/bin/xsi.exe" ]; then
			all_sversion+=(`echo ${d##$xsi_dir} | sed 's/ /_/g'`)
		fi
	done
	# sort by version
	all_sversion=($(for i in "${all_sversion[@]}"; do echo "$i"; done | sort -Vr))
}

sversion() {
	sscan
if [ ${#all_sversion[@]} != 0 ]; then
	echo ==========================================================================
	echo -e " List exist ${blue}Softimage${nc} in [${ADSK_HOME}] directory."
	echo
	createmenu "${all_sversion[@]}"
	echo
	asetenv > /dev/null 2>&1
	ssetenv
	hsetenv > /dev/null 2>&1
	edit.profile "SVERSION" "$SVERSION"
	echo ==========================================================================
else
	local format="${red}%s %24s${nc}\n"
	printf "$format" "Softimage >" "|| Not found"
fi
}

ssetenv() {
export XSI_HOME="${ADSK_HOME}/Softimage ${SVERSION/_/ }"
if [ -d "${XSI_HOME}" ]; then

	pathremove "`colonremove "${XSI_BINDIR}"`"
	export XSI_BINDIR="${XSI_HOME}/Application/bin"
	pathadd "`colonremove "${XSI_BINDIR}"`"

	export PYTHONPATH=`ftobslash ${WGPATH}/softimage/pythonlibs`";"${PYTHONPATH}
	export XSI_USER_PREF=`btofslash "${USERPROFILE}\\Autodesk\\Softimage_${SVERSION}\\Data\\Preferences"`

	# WORKGROUP ####################################################################################################
	local wglocation="${WGPATH}/softimage/${SVERSION}"
	if [ ! -d "${XSI_USER_PREF}" ]; then mkdir -p "${XSI_USER_PREF}"; fi
	# ARNOLD #######################################################################################################
	if [ -z "${suppsitoa}" ] || [ ${suppsitoa} = 0 ]; then
		xsipref "${wglocation}"
		unset SITOA_SHADERS SITOA_SHADERS_PATH SITOA_PROCEDURALS SITOA_PROCEDURALS_PATH
		rm -f "${XSI_USER_PREF}/Arnold Render.Preset"
	else
	# LOAD PLUGINS #################################################################################################
		cp -u "${WGPATH}/softimage/${SVERSION}/Data/Preferences/melon.xsipref" "${XSI_USER_PREF}"
		xsipref "${wglocation};${sitoa_path}"
		rm -f "${XSI_USER_PREF}/Arnold Render.Preset"

		# ADD SITOA SHADERS #########
		SITOA_SHADERS="${sitoa_path}/Application/Plugins/bin/nt-x86-64;${sitoa_path}/Addons/3rd-party/Application/Plugins/bin/nt-x86-64"
		SITOA_PROCEDURALS=""

	################################################################################################################
		export SITOA_SHADERS_PATH=`ftobslash ${SITOA_SHADERS}`
		export SITOA_PROCEDURALS_PATH=`ftobslash ${SITOA_PROCEDURALS}`
	################################################################################################################
	fi

	local format="%s ${green}%11s${nc} %s $(switch.color $suppsitoa)%s${nc}\n"
	printf "$format" "Softimage >" "${SVERSION}" "||" "SITOA $(switch ${suppsitoa} "" "${toa_version[0]}")"

else
	unset XSI_HOME
	sversion
fi
}

xsipref() {
	echo "data_management.workgroup_appl_path = `ftobslash $1`" > ${XSI_USER_PREF}/workgroup.xsipref
}

#---------------------////
# Function:
#---------------------////
s() { xsi.bat & }

#--------------------------------------------------------------------------------------------------////
# INITIAL:
#--------------------------------------------------------------------------------------------------////
export ADSK_HOME="C:/Program Files/Autodesk"
ssetenv
