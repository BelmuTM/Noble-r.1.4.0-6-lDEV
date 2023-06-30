/***********************************************/
/*          Copyright (C) 2023 Belmu           */
/*       GNU General Public License V3.0       */
/***********************************************/

#if AO == 1 || GI == 1
     const float ambientOcclusionLevel = 0.0;
#else
     const float ambientOcclusionLevel = 1.0;
#endif

/*
const int shadowcolor0Format = RGBA16F;
const int shadowcolor1Format = RGBA8;

const int colortex0Format  = RGBA16F;   // Main
const int colortex1Format  = RGBA32UI;  // Gbuffer Data
const int colortex2Format  = RGBA8F;    // Reflections
const int colortex3Format  = RGBA16F;   // Geometric Normals, Shadowmap, Bloom
const int colortex4Format  = RGBA16F;   // Deferred
const int colortex5Format  = RGBA32F;   // Irradiance, Clouds Shadows
const int colortex6Format  = RGBA8F;    // Atmosphere
const int colortex7Format  = RGBA16F;   // Clouds
const int colortex8Format  = RGBA16F;   // History
const int colortex9Format  = RGB16F;    // Direct GI
const int colortex10Format = RGBA16F;   // Indirect GI
const int colortex11Format = RGBA16F;   // Moments
const int colortex12Format = RGBA8F;    // Fog scattering
const int colortex13Format = RGBA8F;    // Fog transmittance
const int colortex15Format = RGBA16F;   // Gbuffer Data

const bool colortex0Clear  = false;
const bool colortex4Clear  = false;
const bool colortex6Clear  = false;
const bool colortex7Clear  = false;
const bool colortex8Clear  = false;
const bool colortex9Clear  = false;
const bool colortex11Clear = false;
const bool colortex10Clear = false;
*/
