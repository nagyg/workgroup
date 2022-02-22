#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# repo rsync:
#--------------------------------------------------------------------------------------------------////
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
	local PASSFILE="--password-file=$(cygdrive "$WGPATH/setup/cwrsync/etc/rsyncd.passwd")"
	local REMOTEHOST="melon@nagyg.ddns.net::workgroup"

 	for i in "${@}"; do
	 	rsync -a ${PASSFILE} ${REMOTEHOST}/${i}/.repoignore "$(cygdrive "$WGPATH/${i}/")"
		if [ -f "${WGPATH}/${i}/.repoignore" ]; then
 			rsync -avhz ${PASSFILE} --exclude-from="$(cygdrive "$WGPATH/${i}/.repoignore")" ${REMOTEHOST}/${i} "$(cygdrive "$WGPATH/")"
			echo -e "[${green}${REMOTEHOST}/${i}${nc}] >> [$WGPATH/${i}]"
		else
			echo -e "[${red}${REMOTEHOST}/${i}${nc}] >> .repoignore not found"
		fi
 	done
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
alias update.sidefx='update sidefx'
alias update.solidangle='update solidangle'
alias update.redshift='update redshift'

## GRAVEYARD ##
alias update.softimage='update softimage'

#ignore: softimage
alias update.all='update addons adobe blackmagic blender djv ffmpeg fonts luts opencolorio project redshift sidefx solidangle'