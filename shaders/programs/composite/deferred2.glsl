/***********************************************/
/*        Copyright (C) NobleRT - 2022         */
/*   Belmu | GNU General Public License V3.0   */
/*                                             */
/* By downloading this content you have agreed */
/*     to the license and its terms of use.    */
/***********************************************/

/* RENDERTARGETS: 5,10,11,12 */

layout (location = 0) out vec4 color;
layout (location = 1) out vec4 history0;
layout (location = 2) out vec3 history1;
layout (location = 3) out vec4 moments;

#include "/include/fragment/brdf.glsl"

#include "/include/atmospherics/celestial.glsl"
#include "/include/atmospherics/atmosphere.glsl"

#include "/include/fragment/raytracer.glsl"
#include "/include/fragment/pathtracer.glsl"
#include "/include/fragment/shadows.glsl"

#include "/include/post/taa.glsl"

#if GI == 1 && GI_TEMPORAL_ACCUMULATION == 1

    void temporalAccumulation(Material mat, inout vec3 color, vec3 prevColor, vec3 prevPos, inout vec3 direct, inout vec3 indirect, inout vec3 moments, float frames) {
        float weight = clamp01(1.0 - (1.0 / max(frames, 1.0)));

        #if ACCUMULATION_VELOCITY_WEIGHT == 1
            weight *= hideGUI;
        #endif

        color      = mix(color, prevColor, weight);
        float luma = luminance(color);

        // Thanks SixthSurge#3922 for the help with moments
        vec2 prevMoments = texture(colortex12, prevPos.xy).xy;
        vec2 currMoments = vec2(luma, luma * luma);
             moments.xy  = mix(currMoments, prevMoments, weight);
             moments.z   = moments.y - moments.x * moments.x;

        vec3 prevColorDirect   = texture(colortex10, prevPos.xy).rgb;
        vec3 prevColorIndirect = texture(colortex11, prevPos.xy).rgb;

        direct   = max0(mix(direct,   prevColorDirect,   weight));
        indirect = max0(mix(indirect, prevColorIndirect, weight));
    }
#endif

float filterAO(sampler2D tex, vec2 coords, Material mat, float scale, float radius, float sigma, int steps) {
    float ao = 0.0, totalWeight = 0.0;

    for(int x = -steps; x <= steps; x++) {
        for(int y = -steps; y <= steps; y++) {
            vec2 offset         = vec2(x, y) * radius * pixelSize;
            vec2 sampleCoords   = (coords * scale) + offset;
            if(clamp01(sampleCoords) != sampleCoords) continue;

            Material sampleMat = getMaterial(coords + offset);

            float weight  = gaussianDistrib2D(vec2(x, y), sigma);
                  weight *= getDepthWeight(mat.depth1, sampleMat.depth1, 2.0);
                  weight *= getNormalWeight(mat.normal, sampleMat.normal, 8.0);
                  weight  = clamp01(weight);

            ao          += texture(tex, sampleCoords).a * weight;
            totalWeight += weight;
        }
    }
    return clamp01(ao * (1.0 / totalWeight));
}

void main() {
    vec2 tempCoords = texCoords;
    #if GI == 1
        tempCoords = texCoords * (1.0 / GI_RESOLUTION);
    #endif

    vec3 viewPos0 = getViewPos0(tempCoords);

    if(isSky(tempCoords)) {
        color.rgb = computeSky(viewPos0);
        return;
    }

    Material mat = getMaterial(tempCoords);

    vec3 prevPos   = reprojection(vec3(texCoords, mat.depth0));
    vec4 prevColor = texture(colortex5, prevPos.xy);

    float depthWeight  = getDepthWeight(mat.depth0, texture(colortex9, prevPos.xy).a, 2.0);
    float normalWeight = getNormalWeight(mat.normal, texture(colortex9, prevPos.xy).rgb * 2.0 - 1.0, 2.0);
    color.a            = (prevColor.a * depthWeight * normalWeight * float(clamp01(prevPos.xy) == prevPos.xy)) + 1.0;

    #if GI == 0
        if(!mat.isMetal) {
            vec3 skyIlluminance = vec3(0.0);
            vec4 shadowmap      = vec4(1.0, 1.0, 1.0, 0.0);

            #ifdef WORLD_OVERWORLD
                skyIlluminance = texture(colortex6, texCoords).rgb;
                shadowmap      = texture(colortex3, texCoords);
            #endif

            history0 = texture(colortex10, texCoords);

            float ao = 1.0;
            #if AO == 1
                ao = history0.a;
            #endif

            color.rgb = computeDiffuse(viewPos0, shadowDir, mat, shadowmap, sampleDirectIlluminance(), skyIlluminance, clamp01(ao));
        }
    #else

        if(clamp(texCoords, vec2(0.0), vec2(GI_RESOLUTION)) == texCoords) {
            pathTrace(color.rgb, vec3(tempCoords, mat.depth0), history0.rgb, history1);

            #if GI_TEMPORAL_ACCUMULATION == 1
                temporalAccumulation(mat, color.rgb, prevColor.rgb, prevPos, history0.rgb, history1, moments.rgb, color.a);
            #endif
        }
    #endif
}
