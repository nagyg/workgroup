#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# OpenColorIO:
#--------------------------------------------------------------------------------------------------////
export OCIO="$(cygpath -w "${WGPATH}/opencolorio/redshift_3_0/config.ocio")"

ocio.converter () {
    local in=`realpath .`
    builtin cd "${WGPATH}/opencolorio/OCIOConverter"
    "${WGPATH}/opencolorio/OCIOConverter/OCIOConverter.exe" &
    builtin cd "$in"
}
