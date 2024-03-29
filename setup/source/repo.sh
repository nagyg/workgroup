#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# rsync repo:
#--------------------------------------------------------------------------------------------------////
# ${WGPATH}/sidefx/HSITE			[qLab/qLib](https://github.com/qLab/qLib)
# ${WGPATH}/sidefx/HSITE			[toadstorm/MOPS](https://github.com/toadstorm/MOPS)
# ${WGPATH}/sidefx/HSITE			[nagyg/mlnLib](https://github.com/nagyg/mlnLib)
# ${WGPATH}/addons/mtool			[crmabs/mtool](https://github.com/crmabs/mtool)
# ${WGPATH}/redshift/OSLShaders		[redshift3d/RedshiftOSLShaders](https://github.com/redshift3d/RedshiftOSLShaders)

update() {
	if [ "$#" == 0 ]; then
		echo "bash: [$#]: illegal number of parameters"
	else
		local i
		local PASSFILE=$(cygpath -w "$WGPATH/setup/cwrsync/etc/rsyncd.passwd")
		local REMOTEHOST="melon@nagyg.ddns.net::workgroup"
		local RSYNCOPTION="--password-file=${PASSFILE}"

		function rsync.loop {
			for i in "${@}"; do
				# first check sync .repoignore
				mkdir -p "$WGPATH/${i}"
				rsync --no-p --no-g --chmod=ugo=rwX -avh ${RSYNCOPTION} $(cygdrive "${REMOTEHOST}/${i}/.repoignore") $(cygdrive "$WGPATH/${i}/")
				echo -e "[.repoignore] >> [$WGPATH/${i}]"

				if [ -f "${WGPATH}/${i}/.repoignore" ]; then
					# rsync
					rsync --no-p --no-g --chmod=ugo=rwX -avh ${RSYNCOPTION} --exclude-from=$(cygdrive "$WGPATH/${i}/.repoignore") $(cygdrive "${REMOTEHOST}/${i}/") $(cygdrive "$WGPATH/${i}")
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

#------------------------////
# alias:
#------------------------////
alias update.addons='update addons'
alias update.adobe='update adobe'
alias update.blackmagic='update blackmagic ffmpeg fonts luts opencolorio project'
alias update.blender='update blender redshift opencolorio project'
alias update.djv='update djv'
alias update.ffmpeg='update ffmpeg'
alias update.fonts='update fonts'
alias update.luts='update luts'
alias update.opencolorio='update opencolorio'
alias update.project='update project'
alias update.redshift='update redshift sidefx blender opencolorio project'
alias update.arnold='update arnold sidefx opencolorio project'
alias update.sidefx='update sidefx redshift arnold opencolorio project'

## ROYALRENDER ##
alias update.royalrender='update royalrender'

## GRAVEYARD ##
alias update.softimage='update softimage'

#ignore: royalrender, softimage
alias update.all='update addons adobe blackmagic blender djv ffmpeg fonts luts opencolorio project redshift arnold sidefx'
