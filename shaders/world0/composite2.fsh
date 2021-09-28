#version 400 compatibility
#include "/programs/extensions.glsl"

/***********************************************/
/*       Copyright (C) Noble RT - 2021         */
/*   Belmu | GNU General Public License V3.0   */
/*                                             */
/* By downloading this content you have agreed */
/*     to the license and its terms of use.    */
/***********************************************/

varying vec2 texCoords;

#include "/settings.glsl"
#include "/programs/common.glsl"
#include "/lib/fragment/brdf.glsl"
#include "/lib/fragment/raytracer.glsl"
#include "/lib/fragment/ao.glsl"
#include "/lib/fragment/ptgi.glsl"

/*
const int colortex5Format = RGBA16F;
*/

void main() {
    vec3 globalIllumination = vec3(0.0);
    float ambientOcclusion = 1.0;

    #if GI == 1
        /* Downscaling Global Illumination */
        float inverseRes = 1.0 / GI_RESOLUTION;
        vec2 scaledUv = texCoords * inverseRes;
        
        if(clamp(texCoords, vec2(0.0), vec2(GI_RESOLUTION)) == texCoords && !isSky(scaledUv)) {
            vec3 positionAt = vec3(scaledUv, texture(depthtex0, scaledUv).r);
            globalIllumination = computePTGI(positionAt);
        }
    #else
        if(!isSky(texCoords)) {
            #if AO == 1
                vec3 viewPos = getViewPos(texCoords);
                vec3 normal = normalize(decodeNormal(texture(colortex1, texCoords).xy));
            
                #if AO_TYPE == 0
                    ambientOcclusion = computeSSAO(viewPos, normal);
                #else
                    ambientOcclusion = computeRTAO(viewPos, normal);
                #endif
            #endif
        }
    #endif

    /*DRAWBUFFERS:5*/
    gl_FragData[0] = vec4(globalIllumination, ambientOcclusion);
}

