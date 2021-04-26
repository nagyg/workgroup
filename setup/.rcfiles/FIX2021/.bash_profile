#!/bin/bash
#---------------------------------------------------------////
# 0 # PRE
#---------------------------------------------------------////

#---------------------------------------------------------////
# 1 # WORKGROUP
#---------------------------------------------------------////
export WGPATH=//mlno/workgroup
#-------------- Please do not edit this section ----------////
export JOB= # not in use

AVERSION=   # not in use
RVERSION=   # not in use
HVERSION=   # not in use
FVERSION=   # not in use
#----------------------- HOUDINI -------------------------////
export HDIR="$WGPATH/sidefx/apps"
expreditor=(    "true" "1.4.7"      )
megascans=(     "false" "4.4"       )
modeler=(       "false" "2020.1.6"  )
groombear=(     "false" "1.2.29"    )
#-------------------- BLACKMAGIC APPS --------------------////
export BMDIR="$WGPATH/blackmagic/apps"
export DISKCACHE="/a/Fusion"
#------------------------ SOURCE -------------------------////
source "${WGPATH}/setup/source/main.sh"
source "${WGPATH}/setup/source/ffmpeg.sh"
source "${WGPATH}/setup/source/opencolorio.sh"
source "${WGPATH}/setup/source/djv.sh"
#source "${WGPATH}/setup/source/arnold.sh"
#source "${WGPATH}/setup/source/redshift.sh"
#source "${WGPATH}/setup/source/houdini.sh"
source "${WGPATH}/setup/source/blackmagic.sh"
source "${WGPATH}/setup/source/project.sh"
source "${WGPATH}/.licenses"

#----------------------- GRAVEYARD
#source "${WGPATH}/softimage/setup/softimage.sh"
#---------------------------------------------------------////
# 2 # POST
#---------------------------------------------------------////