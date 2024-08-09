/***********************************************/
/*          Copyright (C) 2024 Belmu           */
/*       GNU General Public License V3.0       */
/***********************************************/

//////////////////////////////////////////////////////////
/*--------------- MATRICES OPERATIONS ------------------*/
//////////////////////////////////////////////////////////

vec2 diagonal2(mat4 mat) { return vec2(mat[0].x, mat[1].y); 		   }
vec3 diagonal3(mat4 mat) { return vec3(mat[0].x, mat[1].y, mat[2].z);  }
vec4 diagonal4(mat4 mat) { return vec4(mat[0].x, mat[1].y, mat[2].zw); }

vec2 projectOrthogonal(mat4 mat, vec2 v) { return diagonal2(mat) * v + mat[3].xy;  }
vec3 projectOrthogonal(mat4 mat, vec3 v) { return diagonal3(mat) * v + mat[3].xyz; }
vec3 transform        (mat4 mat, vec3 v) { return mat3(mat)      * v + mat[3].xyz; }

//////////////////////////////////////////////////////////
/*--------------------- SHADOWS ------------------------*/
//////////////////////////////////////////////////////////

float getDistortionFactor(vec2 coords) {
	return cubeLength(coords) * SHADOW_DISTORTION + (1.0 - SHADOW_DISTORTION);
}

vec2 distortShadowSpace(vec2 coords) {
	return coords / getDistortionFactor(coords);
}

vec3 distortShadowSpace(vec3 position) {
	position.xy = distortShadowSpace(position.xy);
	position.z *= SHADOW_DEPTH_STRETCH;
	return position;
}

//////////////////////////////////////////////////////////
/*----------------- CLOUDS SHADOWS ---------------------*/
//////////////////////////////////////////////////////////

#if defined WORLD_OVERWORLD && CLOUDS_SHADOWS == 1 && CLOUDS_LAYER0_ENABLED == 1
    vec3 getCloudsShadowPosition(vec2 coords, vec3 rayPosition) {
        coords *= rcp(CLOUDS_SHADOWS_RESOLUTION);
        coords  = coords * 2.0 - 1.0;
        coords /= 1.0 - length(coords.xy);

        return transform(shadowModelViewInverse, vec3(coords * far, 1.0)) + rayPosition;
    }

    float getCloudsShadows(vec3 position) {
        position     = transform(shadowModelView, position) / far;
        position.xy /= 1.0 + length(position.xy);
        position.xy  = position.xy * 0.5 + 0.5;

        return texture(ILLUMINANCE_BUFFER, position.xy * CLOUDS_SHADOWS_RESOLUTION * texelSize).a;
    }
#endif

//////////////////////////////////////////////////////////
/*--------------- SPACE CONVERSIONS --------------------*/
//////////////////////////////////////////////////////////

vec3 screenToView(vec3 screenPosition, mat4 projectionInverse, bool unjitter) {
	screenPosition = screenPosition * 2.0 - 1.0;

    #if TAA == 1
        if(unjitter) screenPosition.xy -= taaOffsets[framemod] * texelSize;
    #endif

	return projectOrthogonal(projectionInverse, screenPosition) / (projectionInverse[2].w * screenPosition.z + projectionInverse[3].w);
}

vec3 viewToScreen(vec3 viewPosition, mat4 projection, bool unjitter) {
	vec3 ndcPosition = projectOrthogonal(projection, viewPosition) / -viewPosition.z;

    #if TAA == 1
        if(unjitter) ndcPosition.xy += taaOffsets[framemod] * texelSize;
    #endif

    return ndcPosition * 0.5 + 0.5;
}

vec3 sceneToView(vec3 scenePosition) {
	return transform(gbufferModelView, scenePosition);
}

vec3 viewToScene(vec3 viewPosition) {
	return transform(gbufferModelViewInverse, viewPosition);
}

mat3 constructViewTBN(vec3 viewNormal) {
	vec3 tangent = normalize(cross(gbufferModelViewInverse[1].xyz, viewNormal));
	return mat3(tangent, cross(tangent, viewNormal), viewNormal);
}

// https://wiki.shaderlabs.org/wiki/Shader_tricks#Linearizing_depth
float linearizeDepth(float depth, float nearPlane, float farPlane) {
    return (nearPlane * farPlane) / (depth * (nearPlane - farPlane) + farPlane);
}

//////////////////////////////////////////////////////////
/*------------------ REPROJECTION ----------------------*/
//////////////////////////////////////////////////////////

vec3 getVelocity(vec3 currPosition, mat4 projectionInverse) {
    vec3 cameraOffset = (cameraPosition - previousCameraPosition) * float(currPosition.z >= handDepth);

    mat4 previousProjection = gbufferPreviousProjection;

    #if defined DISTANT_HORIZONS
        if(currPosition.z >= 1.0) {
            previousProjection = dhPreviousProjection;
        }
    #endif

    vec3 prevPosition = transform(gbufferPreviousModelView, cameraOffset + viewToScene(screenToView(currPosition, projectionInverse, false)));
         prevPosition = (projectOrthogonal(previousProjection, prevPosition) / -prevPosition.z) * 0.5 + 0.5;

    return prevPosition - currPosition;
}

vec3 reproject(vec3 viewPosition, float distanceToFrag, vec3 offset) {
    vec3 scenePosition = normalize((gbufferModelViewInverse * vec4(viewPosition, 1.0)).xyz) * distanceToFrag;
    vec3 velocity      = previousCameraPosition - cameraPosition - offset;

    vec4 prevPosition = gbufferPreviousModelView  * vec4(scenePosition + velocity, 1.0);
         prevPosition = gbufferPreviousProjection * vec4(prevPosition.xyz, 1.0);
    return prevPosition.xyz / prevPosition.w * 0.5 + 0.5;
}

vec3 getClosestFragment(sampler2D depthTex, vec3 position) {
	vec3 closestFragment = position;
    vec3 currentFragment;
    const int size = 1;

    for(int x = -size; x <= size; x++) {
        for(int y = -size; y <= size; y++) {
            currentFragment.xy = position.xy + vec2(x, y) * texelSize;
            currentFragment.z  = texelFetch(depthTex, ivec2(currentFragment.xy * viewSize * RENDER_SCALE), 0).r;
            closestFragment    = currentFragment.z < closestFragment.z ? currentFragment : closestFragment;
        }
    }
    return closestFragment;
}
