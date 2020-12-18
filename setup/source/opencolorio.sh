#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# OpenColorIO:
#--------------------------------------------------------------------------------------------------////
# FUCK RSR VIEW UNC
if [ -d "/c/opencolorio" ]; then
    export OCIO="$(cygpath -w "/c/opencolorio/aces_1.0.3/config.ocio")"
else
    export OCIO="$(cygpath -w "${WGPATH}/opencolorio/aces_1.0.3/config.ocio")"
fi
