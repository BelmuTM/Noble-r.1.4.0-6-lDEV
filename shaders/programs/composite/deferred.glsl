/***********************************************/
/*       Copyright (C) Noble RT - 2021         */
/*   Belmu | GNU General Public License V3.0   */
/*                                             */
/* By downloading this content you have agreed */
/*     to the license and its terms of use.    */
/***********************************************/

#include "/bufferSettings.glsl"

#if STAGE == STAGE_VERTEX

    out vec3 skyIlluminance;
    #include "/include/utility/math.glsl"

    void main() {
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
        texCoords   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

        skyIlluminance = vec3(0.0);

        #ifdef WORLD_OVERWORLD
            const ivec2 samples = ivec2(16, 8);

            for(int x = 0; x < samples.x; x++) {
                for(int y = 0; y < samples.y; y++) {
                    vec3 dir        = generateUnitVector(vec2(x, y) / samples);
                    skyIlluminance += texture(colortex6, projectSphere(dir) * ATMOSPHERE_RESOLUTION).rgb;
                }
            }
            skyIlluminance *= (1.0 / (samples.x * samples.y));
        #endif
    }

#elif STAGE == STAGE_FRAGMENT

    /* DRAWBUFFERS:367 */

    layout (location = 0) out vec4 shadowmap;
    layout (location = 1) out vec4 sky;
    layout (location = 2) out vec4 skyIllum;

    #include "/include/atmospherics/atmosphere.glsl"
    #include "/include/fragment/raytracer.glsl"
    #include "/include/fragment/ao.glsl"
    #include "/include/fragment/shadows.glsl"

    in vec3 skyIlluminance;

    void main() {
        vec3 viewPos = getViewPos0(texCoords);
        material mat = getMaterial(texCoords);
        skyIllum     = vec4(skyIlluminance, 1.0);

        #ifdef WORLD_OVERWORLD
            /*    ------- SHADOW MAPPING -------    */
            #if SHADOWS == 1
                shadowmap.rgb = shadowMap(viewPos);
            #endif

            /*    ------- ATMOSPHERIC SCATTERING -------    */
            if(clamp(texCoords, vec2(0.0), vec2(ATMOSPHERE_RESOLUTION + 1e-2)) == texCoords) {
                vec3 rayDir = unprojectSphere(texCoords * (1.0 / ATMOSPHERE_RESOLUTION));
                sky.rgb     = atmosphericScattering(atmosRayPos, normalize(rayDir), skyIlluminance);
                sky.a       = 1.0;
            }
        #endif

        float ambientOcclusion = 1.0;
        #if AO == 1
            if(!isSky(texCoords)) {
                #if AO_TYPE == 0
                    ambientOcclusion = computeSSAO(viewPos, mat.normal);
                #else
                    ambientOcclusion = computeRTAO(viewPos, mat.normal);
                #endif
            }
        #endif

        shadowmap.a = ambientOcclusion;
    }
#endif
