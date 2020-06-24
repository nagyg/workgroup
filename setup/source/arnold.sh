#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# ARNOLD environment:
#--------------------------------------------------------------------------------------------------////
aversions() {
	source "${ADIR}/arnold/$1/versions.sh"
}

ascan() {
	unset all_aversion
	local d i
	local arnold_dir="${ADIR}/arnold/"
	for d in "${arnold_dir}"* ; do
		if [ -f "$d/versions.sh" ]; then
			all_aversion+=(`echo ${d##${arnold_dir}}`)
		fi
	done
	# sort by version
	all_aversion=($(for i in "${all_aversion[@]}"; do echo "$i"; done | sort -Vr))
}

alist() {
	local count=0
	local i
	ascan
	local format="%s ${blue}%8s${nc} %s %s ${yellow}%s${nc} %9s %s ${yellow}%s${nc} %s\n"
	for i in "${all_aversion[@]}"; do
		local count=$((count+1))
		local htoa_version=$htoa_version
		local arnold_support_hversion=$arnold_support_hversion
		aversions "${i}"
		printf "$format" "${count})" "${i}" \
		"|| ${arnold_support_hversion[@]}" "HTOA" "${htoa_version}"
	done
}

aversion() {
	ascan
if [ ${#all_aversion[@]} != 0 ]; then
	echo ==========================================================================
	echo -e " List exist ${blue}Arnold${nc} in [${ADIR}/arnold] directory."
	echo
	alist
	echo
	createmenu "${all_aversion[@]}"
	echo
	asetenv
	hsetenv 2> /dev/null
	edit.profile "AVERSION" "$AVERSION"
	echo ==========================================================================
else
	local format="${red}%s %14s${nc}\n"
	printf "$format" "Arnold     >" "Not found ||"
fi
}

asetenv() {
if [ -d "${ADIR}/arnold/${AVERSION}" ] && [ -n "${AVERSION}" ]; then

	aversions "${AVERSION}"

	pathremove "${ARNOLD_BINDIR}"
	export ARNOLD_BINDIR="${ADIR}/arnold/${AVERSION}/bin"
	pathadd "${ARNOLD_BINDIR}"

	if [ -z "${HVERSION}" ]; then supphtoa=0; else
		case ${arnold_support_hversion[@]} in  *${HVERSION}*) supphtoa=1 ;; *) supphtoa=0 ;; esac
		htoa_path="${ADIR}/htoa/${HVERSION}"
	fi

	local format="%s ${green}%11s${nc} %s ${green}%s${nc}\n"
	printf "$format" "Arnold     >" "${AVERSION}" "||"

else
	supphtoa=0
	aversion
fi
}

#--------------------------------------------------------------------------------------------------////
# INITIAL:
#--------------------------------------------------------------------------------------------------////
if [ -z "${ADIR}" ]; then
	export ADIR="${WGPATH}/solidangle"
fi

asetenv
