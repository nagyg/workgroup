#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# OpenColorIO:
#--------------------------------------------------------------------------------------------------////
export OCIO="$(cygpath -w "${WGPATH}/opencolorio/aces_1.0.3/config.ocio")"

ocio.converter () {
    local in=`realpath .`
    builtin cd "${WGPATH}/opencolorio/OCIOConverter"
    "${WGPATH}/opencolorio/OCIOConverter/OCIOConverter.exe" &
    builtin cd "$in"
}
