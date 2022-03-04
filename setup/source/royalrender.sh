#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# ROYALRENDER Function:
#--------------------------------------------------------------------------------------------------////
rr.config() {
local dir=$WGPATH/royalrender/render_apps
if [ -d "${dir}" ]; then
  code \
  $dir/_setenv/all/houdini__inhouse.rrEnv \
  $dir/_setenv/all/arnold__inhouse.rrEnv \
  $dir/_setenv/all/blender__inhouse.rrEnv \
  $dir/_setenv/all/fusion__inhouse.rrEnv \
  $dir/_config/3D00__3D_global__inhouse.inc \
  $dir/_config/A40__Redshift_StdA__inhouse.inc \
  $dir/_config/A40__Redshift_StdA_tiled__inhouse.inc \
  $dir/_config/A80__Arnold_StdA_HtoA__inhouse.inc \
  $dir/_config/A80__Arnold_StdA__inhouse.inc \
  $dir/_config/A80__Arnold_StdA_DeNoice__inhouse.inc \
  $dir/_config/3D19__Blender__inhouse.inc \
  $dir/_config/3D19__Blender_Cycles__inhouse.inc \
  $dir/_config/C10__Fusion80__inhouse.inc
else
  echo -e "[${red}${dir}${nc}] >> drectory not found"
fi
}
