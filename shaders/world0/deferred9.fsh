#version 400 compatibility

/***********************************************/
/*          Copyright (C) 2023 Belmu           */
/*       GNU General Public License V3.0       */
/***********************************************/

in vec2 texCoords;

#define STAGE_FRAGMENT
#define WORLD_OVERWORLD

#define ATROUS_PASS_INDEX 4
#include "/programs/deferred/atrous_pass.glsl"
