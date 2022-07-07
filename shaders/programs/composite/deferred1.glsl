/***********************************************/
/*        Copyright (C) NobleRT - 2022         */
/*   Belmu | GNU General Public License V3.0   */
/*                                             */
/* By downloading this content you have agreed */
/*     to the license and its terms of use.    */
/***********************************************/

#include "/include/atmospherics/atmosphere.glsl"

#if defined STAGE_VERTEX

    out mat3[2] skyIlluminanceMat;
    out vec3 skyMultScatterIllum;

    void main() {
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
        texCoords   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

        skyIlluminanceMat = sampleSkyIlluminance(skyMultScatterIllum);
    }

#elif defined STAGE_FRAGMENT

    /* RENDERTARGETS: 3,0,6,10,15 */

    layout (location = 0) out vec4 shadowmap;
    layout (location = 1) out vec3 sky;
    layout (location = 2) out vec3 skyIlluminance;
    layout (location = 3) out vec4 ao;
    layout (location = 4) out vec4 clouds;

    #include "/include/atmospherics/clouds.glsl"
    
    #include "/include/fragment/shadows.glsl"

    #include "/include/post/taa.glsl"

    in mat3[2] skyIlluminanceMat;
    in vec3 skyMultScatterIllum;

    float filterAO(sampler2D tex, vec2 coords, Material mat, float scale, float radius, float sigma, int steps) {
        float ao = 0.0, totalWeight = 0.0;

        for(int x = -steps; x <= steps; x++) {
            for(int y = -steps; y <= steps; y++) {
                vec2 offset         = vec2(x, y) * radius * pixelSize;
                vec2 sampleCoords   = (coords * scale) + offset;
                if(clamp01(sampleCoords) != sampleCoords) continue;

                Material sampleMat = getMaterial(coords + offset);

                float weight  = gaussianDistrib2D(vec2(x, y), sigma);
                      weight *= getDepthWeight(mat.depth0, sampleMat.depth0, 2.0);
                      weight *= getNormalWeight(mat.normal, sampleMat.normal, 8.0);
                      weight  = clamp01(weight);

                ao          += texture(tex, sampleCoords).a * weight;
                totalWeight += weight;
            }
        }
        return clamp01(ao * (1.0 / totalWeight));
    }

    void main() {
        vec3 viewPos = getViewPos0(texCoords);
        Material mat = getMaterial(texCoords);

        vec3 bentNormal = mat.normal;

        #if GI == 0
            #if AO == 1
                vec4 aoHistory = texture(colortex10, texCoords * AO_RESOLUTION);
                if(!all(equal(aoHistory.rgb, vec3(0.0)))) { 
                    bentNormal = aoHistory.rgb;
                    ao.rgb     = aoHistory.rgb;
                }

                #if AO_FILTER == 1
                    ao.a = filterAO(colortex10, texCoords, mat, AO_RESOLUTION, 0.5, 2.0, 4);
                #else
                    ao.a = aoHistory.a;
                #endif
            #endif
        #endif

        #ifdef WORLD_OVERWORLD
            /*    ------- SHADOW MAPPING -------    */
            float ssDepth = 0.0;
            shadowmap.rgb = shadowMap(viewPos, texture(colortex2, texCoords).rgb, ssDepth);
            shadowmap.a   = ssDepth;

            /*    ------- ATMOSPHERIC SCATTERING -------    */
            skyIlluminance.rgb = getSkyLight(bentNormal, skyIlluminanceMat);

            vec3 skyRay = normalize(unprojectSphere(texCoords * rcp(ATMOSPHERE_RESOLUTION)));
                 sky    = atmosphericScattering(skyRay, skyMultScatterIllum);

            /*    ------- VOLUMETRIC CLOUDS -------    */
            #if CLOUDS == 1
                vec2 cloudsCoords = texCoords * rcp(CLOUDS_RESOLUTION);
                
                clouds = vec4(0.0, 0.0, 0.0, 1.0);

                if(clamp01(cloudsCoords) == cloudsCoords) {
                    float depth;
                    vec3 cloudsRay = normalize(unprojectSphere(cloudsCoords));
                         clouds    = cloudsScattering(cloudsRay, depth);

                    /* Aerial Perspective */
                    const float cloudsMiddle = CLOUDS_ALTITUDE + (CLOUDS_THICKNESS * 0.5);
                    vec2 dists               = intersectSphere(atmosRayPos, cloudsRay, earthRad + cloudsMiddle);

                    if(dists.y >= 0.0) { 
                        float distToCloud = cameraPosition.y >= cloudsMiddle ? dists.x : dists.y;
                        clouds            = mix(vec4(0.0, 0.0, 0.0, 1.0), clouds, exp(-5e-5 * distToCloud));
                    }

                    vec3 prevPos    = reprojection(viewToScreen(normalize(viewPos) * depth));
                    vec4 prevClouds = texture(colortex15, prevPos.xy);

                    if(!all(equal(prevClouds, vec4(0.0)))) clouds = mix(clouds, prevClouds, 0.96);
                }
            #endif
        #endif
    }
#endif
