#!/bin/bash
#---------------------------------------------------------////
# 0 # PRE
#---------------------------------------------------------////

#---------------------------------------------------------////
# 1 # WORKGROUP
#---------------------------------------------------------////
export WGPATH=~/workgroup
#-------------- Please do not edit this section ----------////
export JOB=   # not in use

AVERSION=   # not in use
RVERSION=   # not in use
HVERSION=   # not in use
FVERSION=   # not in use
#----------------------- HOUDINI -------------------------////
export HDIR="/c/Program Files/Side Effects Software"
expreditor=(    "true" "1.3.3"     )
modeler=(       "false" "1.0.4"     )
groombear=(     "false" "1.1.36"    )
quadremesher=(  "true"             )
#------------------- BLACKMAGIC FUSION -------------------////
export BMDIR="/c/Program Files/Blackmagic Design"
#------------------------ SOURCE -------------------------////
source "${WGPATH}/setup/source/main.sh"
source "${WGPATH}/setup/source/vscode.sh"
#source "${WGPATH}/setup/source/ffmpeg.sh"
#source "${WGPATH}/setup/source/tweaksoftware.sh"
#source "${WGPATH}/setup/source/arnold.sh"
#source "${WGPATH}/setup/source/redshift.sh"
#source "${WGPATH}/setup/source/houdini.sh"
#source "${WGPATH}/setup/source/blackmagic.sh"
#source "${WGPATH}/setup/source/project.sh"
#source "${WGPATH}/licenses.sh"

## GRAVEYARD ##
#source "${WGPATH}/setup/source/graveyard/softimage.sh"
#---------------------------------------------------------////
# 2 # POST
#---------------------------------------------------------////