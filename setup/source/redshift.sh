#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# REDSHIFT environment:
#--------------------------------------------------------------------------------------------------////
rversions() {
	source "${RDIR}/$1/versions.sh"
}

rscan() {
	unset all_rversion
	local d i
	local redshift_dir="${RDIR}/"
	for d in "${redshift_dir}"* ; do
		if [ -f "$d/versions.sh" ]; then
			all_rversion+=(`echo ${d##${redshift_dir}}`)
		fi
	done
	# sort by version
	all_rversion=($(for i in "${all_rversion[@]}"; do echo "$i"; done | sort -Vr))
}

rlist() {
	local count=0
	local i
	rscan
	local format="%s ${blue}%8s${nc} %s %s\n"
	for i in "${all_rversion[@]}"; do
		local count=$((count+1))
		local redshift_support_hversion=$redshift_support_hversion
		rversions "${i}"
		printf "$format" "${count})" "${i}" \
		"|| ${redshift_support_hversion[@]}"
	done
}

rversion() {
	rscan
if [ ${#all_rversion[@]} != 0 ]; then
	echo ==========================================================================
	echo -e " List exist ${blue}Redshift${nc} in [${RDIR}] directory."
	echo
	rlist
	echo
	createmenu "${all_rversion[@]}"
	echo
	rsetenv
	hsetenv 2> /dev/null
	edit.profile "RVERSION" "$RVERSION"
	echo ==========================================================================
else
	local format="${red}%s %14s${nc}\n"
	printf "$format" "Redshift   >" "Not found ||"
fi
}

rsetenv() {
if [ -d "${RDIR}/${RVERSION}" ] && [ -n "${RVERSION}" ]; then

	rversions "${RVERSION}"

	if [ -z "${HVERSION}" ]; then suppredshift=0; else
		case ${redshift_support_hversion[@]} in  *${HVERSION}*) suppredshift=1 ;; *) suppredshift=0 ;; esac
		htor_path="${RDIR}/${RVERSION}"
	fi

	local format="%s ${green}%11s${nc} %s ${green}%s${nc}\n"
	printf "$format" "Redshift   >" "${RVERSION}" "||"

else
	suppredshift=0
	rversion
fi
}

#--------------------------------------------------------------------------------------------------////
# INITIAL:
#--------------------------------------------------------------------------------------------------////
if [ -z "${RDIR}" ]; then
	export RDIR="${WGPATH}/redshift"
fi

rsetenv