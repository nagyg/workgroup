#!/bin/bash
#---------------------------------------------------------////
# 0 # PRE
#---------------------------------------------------------////

#---------------------------------------------------------////
# 1 # WORKGROUP
#---------------------------------------------------------////
export WGPATH=//mlno/workgroup
export WGCACHE=/a
#-------------- Please do not edit this section ----------////
export JOB= # not in use

AVERSION=   # not in use
RVERSION=   # not in use
HVERSION=   # not in use
BVERSION=   # not in use
FVERSION=   # not in use
#----------------------- HOUDINI -------------------------////
export HDIR="$WGPATH/sidefx/apps"
#----- PACKAGES -----//
mlnlib=(      "true")
qlib=(        "true")
sidefxlabs=(  "false")
mops=(        "false")
axiom=(       "false")
megascans=(   "false")
groombear=(   "false")
#-------------------- BLACKMAGIC APPS --------------------////
export BMDIR="$WGPATH/blackmagic/apps"
#------------------------ SOURCE -------------------------////
source "${WGPATH}/setup/source/main.sh"
source "${WGPATH}/setup/source/project.sh"
source "${WGPATH}/setup/source/ffmpeg.sh"
source "${WGPATH}/setup/source/opencolorio.sh"
source "${WGPATH}/setup/source/djv.sh"
#source "${WGPATH}/setup/source/redshift.sh"
#source "${WGPATH}/setup/source/arnold.sh"
source "${WGPATH}/setup/source/houdini.sh"
#source "${WGPATH}/setup/source/blender.sh"
source "${WGPATH}/setup/source/blackmagic.sh"
#source "${WGPATH}/setup/source/royalrender.sh"
source "${WGPATH}/.licenses"

#----------------------- GRAVEYARD
#source "${WGPATH}/softimage/setup/softimage.sh"
#---------------------------------------------------------////
# 2 # POST
#---------------------------------------------------------////