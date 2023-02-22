#version 400 compatibility

/***********************************************/
/*          Copyright (C) 2023 Belmu           */
/*       GNU General Public License V3.0       */
/***********************************************/

out vec2 texCoords;

#define STAGE_VERTEX
#define WORLD_NETHER

#include "/include/common.glsl"
#include "/programs/deferred/deferred2.glsl"
