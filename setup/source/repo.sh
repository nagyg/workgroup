#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# rsync repo:
#--------------------------------------------------------------------------------------------------////
# ${WGPATH}/sidefx/HSITE		[qLab/qLib](https://github.com/qLab/qLib)
# ${WGPATH}/sidefx/HSITE		[toadstorm/MOPS](https://github.com/toadstorm/MOPS)
# ${WGPATH}/sidefx/HSITE		[nagyg/mlnLib](https://github.com/nagyg/mlnLib)
# ${WGPATH}/addons/mtool		[crmabs/mtool](https://github.com/crmabs/mtool)
# ${WGPATH}/redshift/OSLShaders	[redshift3d/RedshiftOSLShaders](https://github.com/redshift3d/RedshiftOSLShaders)

pathadd "${WGPATH}/setup/cwrsync"

rsync() {
	export rsyncarg=$@

	local in=`pwd`
	( cd ; cwrsync.cmd )
	builtin cd "$in"

	unset rsyncarg
}

update() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of parameters"
else
	local i
	local PASSFILE="$(cygdrive "$WGPATH/setup/cwrsync/etc/rsyncd.passwd")"
	local REMOTEHOST="melon@nagyg.ddns.net::workgroup"
	local RSYNCOPTION="--password-file=${PASSFILE}"

	function rsync.loop {
		for i in "${@}"; do
	   		# first check sync .repoignore
	 		rsync --perms --no-p --no-g --chmod=ugo=rwX -rtvh ${RSYNCOPTION} ${REMOTEHOST}/${i}/.repoignore "$(cygdrive "$WGPATH/${i}/")"
			echo -e "[.repoignore] >> [$WGPATH/${i}]"

			if [ -f "${WGPATH}/${i}/.repoignore" ]; then
				# rsync
 				rsync --perms --no-p --no-g --chmod=ugo=rwX -rtvh ${RSYNCOPTION} --exclude-from="$(cygdrive "$WGPATH/${i}/.repoignore")" ${REMOTEHOST}/${i} "$(cygdrive "$WGPATH/")"
				echo -e "[${green}${REMOTEHOST}/${i}${nc}] >> [$WGPATH/${i}]"
			else
				echo -e "[${red}${REMOTEHOST}/${i}${nc}] >> .repoignore not found"
			fi
		done
	}

	if [ -f "${PASSFILE}" ]; then
		rsync.loop $@
	else
		echo -e "[${red}${PASSFILE}${nc}] >> rsync passwd file missing"
		unset PASSFILE RSYNCOPTION
		rsync.loop $@
	fi
fi
}

#------------------////
# alias:
#------------------////
alias update.addons='update addons'
alias update.adobe='update adobe'
alias update.blackmagic='update blackmagic fonts luts'
alias update.blender='update blender'
alias update.djv='update djv'
alias update.ffmpeg='update ffmpeg'
alias update.fonts='update fonts'
alias update.luts='update luts'
alias update.opencolorio='update opencolorio'
alias update.project='update project'
alias update.redshift='update redshift sidefx'
alias update.arnold='update arnold sidefx'
alias update.sidefx='update sidefx redshift arnold'

## ROYALRENDER ##
alias update.royalrender='update royalrender'

## GRAVEYARD ##
alias update.softimage='update softimage'

#ignore: royalrender, softimage
alias update.all='update addons adobe blackmagic blender djv ffmpeg fonts luts opencolorio project redshift arnold sidefx'
