/***********************************************/
/*          Copyright (C) 2023 Belmu           */
/*       GNU General Public License V3.0       */
/***********************************************/

float windSpeed = mix(1.4, 3.0, wetness);
vec3  windDir   = windSpeed * frameTimeCounter * vec3(-0.2, 0.35, -1.0);

void wavingLeaves(inout vec3 worldPosition, float skyFalloff) {
	worldPosition += cameraPosition;

	float rng = 1.0 + FBM(worldPosition.xz * 0.7, 1, 1.0);

    vec3 offset  = sin(worldPosition * 1.4 + windDir * vec3(rng, 1.3, rng) * 2.0) * vec3(0.04, 0.06, 0.04);
		 offset *= skyFalloff;

	worldPosition += offset;
	worldPosition -= cameraPosition;
}

void wavingPlants(inout vec3 worldPosition, float skyFalloff, bool isTopVertex, bool isTopBlock) {
	worldPosition += cameraPosition;

	float rng = 1.0 + FBM(worldPosition.xz, 1, 1.5);

	vec2 offset  = sin(worldPosition.xz * 1.4 + windDir.xz * rng * 2.0) * 0.1 + vec2(0.06, -0.03);
		 offset *= (isTopBlock ? 1.0 : float(isTopVertex)) * skyFalloff;

	worldPosition.xz += offset;
	worldPosition    -= cameraPosition;
}

void hangingLantern(inout vec3 worldPosition, bool isBottomVertex) {
	worldPosition += cameraPosition;

	vec3 localOrigin   = worldPosition + at_midBlock / 64.0;
		 localOrigin.y = ceil(localOrigin.y);

	vec2 rng      = vec2(FBM(floor(worldPosition.xz + vec2(150.0)), 1, 5.0), FBM(floor(worldPosition.xz), 1, 10.0)) * 2.0 - 1.0;
	vec2 rotation = sincos(frameTimeCounter * 1.5) * vec2(7.0 * (rng.y * 2.0 + rng.x * 4.0), 10.0 * (rng.y * 6.0)) * 0.1;

	worldPosition -= localOrigin;
	worldPosition  = rotate(worldPosition, vec3(0.0, 0.0, 1.0), rotation.x);
	worldPosition  = rotate(worldPosition, vec3(1.0, 0.0, 1.0), rotation.y);
	worldPosition += localOrigin;

	worldPosition -= cameraPosition;

}

void animate(inout vec3 worldPosition, bool isTopVertex, float skyFalloff) {
	switch(blockId) {
		case LEAVES_ID:              wavingLeaves(worldPosition, skyFalloff                    ); break;
		case DOUBLE_PLANTS_LOWER_ID: wavingPlants(worldPosition, skyFalloff, isTopVertex, false); break;
		case DOUBLE_PLANTS_UPPER_ID: wavingPlants(worldPosition, skyFalloff, isTopVertex, true ); break;
		case PLANTS_ID:              wavingPlants(worldPosition, skyFalloff, isTopVertex, false); break;
		case HANGING_LANTERN_ID:     hangingLantern(worldPosition, !isTopVertex);                 break; 
		default: break;
	}
}
