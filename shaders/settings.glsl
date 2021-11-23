/***********************************************/
/*       Copyright (C) Noble RT - 2021         */
/*   Belmu | GNU General Public License V3.0   */
/*                                             */
/* By downloading this content you have agreed */
/*     to the license and its terms of use.    */
/***********************************************/

#define OVERWORLD 0
#define NETHER   -1

#define STAGE_VERTEX   0
#define STAGE_FRAGMENT 1

#define ABOUT 0 // [0 1]

/*------------------ MATH ------------------*/
#define REC_709 vec3(0.2126, 0.7152, 0.0722)
#define EPS 1e-4

#define QUARTER_PI 0.78539816
#define HALF_PI    1.57079632
#define PI         3.14159265
#define TAU        6.28318530
#define INV_PI     0.31830988

#define GOLDEN_RATIO 1.61803398
#define GOLDEN_ANGLE 2.39996322

/*------------------ OPTIFINE CONSTANTS ------------------*/
const float sunPathRotation      = -40.0; // [-85.0 -80.0 -75.0 -70.0 -65.0 -60.0 -55.0 -50.0 -45.0 -40.0 -35.0 -30.0 -25.0 -20.0 -15.0 -10.0 -5.0 0.0 5.0 10.0 15.0 20.0 25.0 30.0 35.0 40.0 45.0 50.0 55.0 60.0 65.0 70.0 75.0 80.0 85.0]
const int noiseTextureResolution =   256;

const int shadowMapResolution =  3072; // [512 1024 2048 3072 4096 6144]
const float shadowDistance    = 256.0; // [64.0 128.0 256.0 512.0 1024.0]

/*------------------ LIGHTING ------------------*/
const float rainAmbientDarkness = 0.3;

#define BLOCKLIGHT_TEMPERATURE 5600 // [1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400 2500 2600 2700 2800 2900 3000 3100 3200 3300 3400 3500 3600 3700 3800 3900 4000 4100 4200 4300 4400 4500 4600 4700 4800 4900 5000 5100 5200 5300 5400 5500 5600 5700 5800 5900 6000 6100 6200 6300 6400 6500 6600 6700 6800 6900 7000 7100 7200 7300 7400 7500 7600 7700 7800 7900 8000 8100 8200 8300 8400 8500 8600 8700 8800 8900 9000 9100 9200 9300 9400 9500 9600 9700 9800 9900 10000 10100 10200 10300 10400 10500 10600 10700 10800 10900 11000 11100 11200 11300 11400 11500 11600 11700 11800 11900 12000 12100 12200 12300 12400 12500 12600 12700 12800 12900 13000 13100 13200 13300 13400 13500 13600 13700 13800 13900 14000 14100 14200 14300 14400 14500 14600 14700 14800 14900 15000 15100 15200 15300 15400 15500 15600 15700 15800 15900 16000 16100 16200 16300 16400 16500 16600 16700 16800 16900 17000 17100 17200 17300 17400 17500 17600 17700 17800 17900 18000 18100 18200 18300 18400 18500 18600 18700 18800 18900 19000 19100 19200 19300 19400 19500 19600 19700 19800 19900 20000 20100 20200 20300 20400 20500 20600 20700 20800 20900 21000 21100 21200 21300 21400 21500 21600 21700 21800 21900 22000 22100 22200 22300 22400 22500 22600 22700 22800 22900 23000 23100 23200 23300 23400 23500 23600 23700 23800 23900 24000 24100 24200 24300 24400 24500 24600 24700 24800 24900 25000 25100 25200 25300 25400 25500 25600 25700 25800 25900 26000 26100 26200 26300 26400 26500 26600 26700 26800 26900 27000 27100 27200 27300 27400 27500 27600 27700 27800 27900 28000 28100 28200 28300 28400 28500 28600 28700 28800 28900 29000 29100 29200 29300 29400 29500 29600 29700 29800 29900 30000 30100 30200 30300 30400 30500 30600 30700 30800 30900 31000 31100 31200 31300 31400 31500 31600 31700 31800 31900 32000 32100 32200 32300 32400 32500 32600 32700 32800 32900 33000 33100 33200 33300 33400 33500 33600 33700 33800 33900 34000 34100 34200 34300 34400 34500 34600 34700 34800 34900 35000 35100 35200 35300 35400 35500 35600 35700 35800 35900 36000 36100 36200 36300 36400 36500 36600 36700 36800 36900 37000 37100 37200 37300 37400 37500 37600 37700 37800 37900 38000 38100 38200 38300 38400 38500 38600 38700 38800 38900 39000 39100 39200 39300 39400 39500 39600 39700 39800 39900 40000 40100 40200 40300 40400 40500 40600 40700 40800 40900 41000 41100 41200 41300 41400 41500 41600 41700 41800 41900 42000 42100 42200 42300 42400 42500 42600 42700 42800 42900 43000 43100 43200 43300 43400 43500 43600 43700 43800 43900 44000 44100 44200 44300 44400 44500 44600 44700 44800 44900 45000 45100 45200 45300 45400 45500 45600 45700 45800 45900 46000 46100 46200 46300 46400 46500 46600 46700 46800 46900 47000 47100 47200 47300 47400 47500 47600 47700 47800 47900 48000 48100 48200 48300 48400 48500 48600 48700 48800 48900 49000 49100 49200 49300 49400 49500 49600 49700 49800 49900 50000]
#define BLOCKLIGHT_MULTIPLIER   2.0
#define BLOCKLIGHT_EXPONENT     5.0

#define SUN_INTENSITY    22.0
#define SUN_COLOR        vec3(1.0, 0.97, 0.94)
#define SUN_ILLUMINANCE  (SUN_INTENSITY * SUN_COLOR)
#define MOON_ILLUMINANCE vec3(0.05)

#define SPECULAR    1 // [0 1]
#define WHITE_WORLD 0 // [0 1]

/*------------------ AMBIENT OCCLUSION ------------------*/
#define AO        1 // [0 1]
#define AO_TYPE   0 // [0 1]
#define AO_FILTER 1 // [0 1]

#define SSAO_SAMPLES    8 // [4 8 12 16 20]
#define SSAO_RADIUS   0.5
#define SSAO_STRENGTH 1.5

#define RTAO_SAMPLES 3 // [3 16]
#define RTAO_STEPS  16

/*------------------ SHADOWS ------------------*/
#define SHADOWS         1 // [0 1]
#define SOFT_SHADOWS    1 // [0 1]
#define CONTACT_SHADOWS 0

#define SHADOW_SAMPLES   3 // [1 2 3 4 5 6]
#define DISTORT_FACTOR 0.9
#define SHADOW_BIAS    0.8

// Soft Shadows
#define PCSS_SAMPLES            24 // [24 64]
#define LIGHT_SIZE           100.0
#define BLOCKER_SEARCH_RADIUS 12.0
#define BLOCKER_SEARCH_SAMPLES  20 // [20 64]

/*------------------ RAY TRACING ------------------*/
#define BINARY_REFINEMENT 1 // [0 1]
#define BINARY_COUNT      4 // [4 6 12]
#define BINARY_DECREASE 0.5

#define RAY_STEP_LENGTH 1.7

/*------------------ GLOBAL ILLUMINATION ------------------*/
#define GI        0 // [0 1]
#define GI_FILTER 0 // [0 1]

#define GI_SAMPLES 1 // [1 2 3]
#define GI_BOUNCES 4 // [1 2 3 4 5 6 7 8]
#define GI_STEPS  40 // [40 128]
#define GI_RESOLUTION 1.00 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

#define GI_TEMPORAL_ACCUMULATION     1 // [0 1]
#define ACCUMULATION_VELOCITY_WEIGHT 0 //[0 1]

/*------------------ REFLECTIONS | REFRACTIONS ------------------*/
#define SSR        1 // [0 1]
#define SSR_TYPE   1 // [0 1]
#define REFRACTION 1 // [0 1]

const float hardCodedRoughness = 0.0; // 0.0 = OFF
#define ATTENUATION_FACTOR 0.325

#define SKY_FALLBACK     1
#define SSR_REPROJECTION 1 // [0 1]

#define PREFILTER_SAMPLES    3 // [3 12]
#define ROUGH_REFLECT_STEPS 20 // [20 64]
#define ROUGH_REFLECT_RES 0.80 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

#define SIMPLE_REFLECT_STEPS 64
#define REFRACT_STEPS        56

/*------------------ ATMOSPHERICS ------------------*/
#define ATMOSPHERE_RESOLUTION 0.25 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define SCATTER_STEPS           16 // [8 12 16 20 24 28 32 36]
#define TRANSMITTANCE_STEPS      8 // [8 12 16 20 24 28 32 36]

#define VL        0 // [0 1]
#define VL_FILTER 1 // [0 1]
#define VL_STEPS int(SCATTER_STEPS * 0.5)

#define RAIN_FOG 1 // [0 1]

#define STARS_AMOUNT     0.10 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define STARS_BRIGHTNESS 0.30 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

/*------------------ WATER ------------------*/
#define ANIMATED_WATER 1 // [0 1]

// PBR
#define WATER_ABSORPTION_COEFFICIENTS vec3(1.0, 0.2, 0.13)

#define WAVE_STEEPNESS 2.00 // [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.55 1.60 1.65 1.70 1.75 1.80 1.85 1.90 1.95 2.00]
#define WAVE_AMPLITUDE 0.04 // [0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20]
#define WAVE_LENGTH    2.00 // [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.55 1.60 1.65 1.70 1.75 1.80 1.85 1.90 1.95 2.00]
#define WAVE_SPEED     0.20 // [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// POST-EFFECTS
#define WATER_FOAM               1 // [0 1]
#define FOAM_BRIGHTNESS       0.50 // [0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.10 1.20 1.30 1.40 1.50 1.60 1.70 1.80 1.90 2.00]
#define FOAM_FALLOFF_DISTANCE 0.75
#define FOAM_EDGE_FALLOFF      0.4
#define FOAM_FALLOFF_BIAS      0.1

#define UNDERWATER_DISTORTION         1 // [0 1]
#define WATER_DISTORTION_SPEED     0.65
#define WATER_DISTORTION_AMPLITUDE 0.40 // [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

#define WATER_CAUSTICS             1 // [0 1]
#define WATER_CAUSTICS_STRENGTH 5.00 // [1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00 4.25 4.50 4.75 5.00 5.25 5.50 5.75 6.00 6.25 6.50 6.75 7.00 7.25 7.50 7.75 8.00 8.25 8.50 8.75 9.00 9.25 9.50 9.75 10.00]
#define WATER_CAUSTICS_SPEED    10.0

/*------------------ CAMERA ------------------*/
#define TAA               1 // [0 1]
#define TAA_STRENGTH  0.900 // [0.800 0.812 0.825 0.837 0.850 0.862 0.875 0.887 0.900 0.912 0.925 0.937 0.950 0.962 0.975 0.987]
#define NEIGHBORHOOD_SIZE 1 // [1 2 3]

#define TAA_VELOCITY_WEIGHT 0 // [0 1]
#define TAA_LUMA_MIN 0.15

#define PURKINJE 0 // [0 1]

#define DOF           0 // [0 1]
#define DOF_RADIUS 20.0 // [5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0 17.0 18.0 19.0 20.0 21.0 22.0 23.0 24.0 25.0 26.0 27.0 28.0 29.0 30.0 31.0 32.0 33.0 34.0 35.0 36.0 37.0 38.0 39.0 40.0]

#define BLOOM                  1 // [0 1]
#define BLOOM_STRENGTH      1.00 // [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.55 1.60 1.65 1.70 1.75 1.80 1.85 1.90 1.95 2.00]
#define BLOOM_LUMA_THRESHOLD 0.5

#define VIGNETTE             0 // [0 1]
#define VIGNETTE_STRENGTH 0.25 // [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50]

#define CHROMATIC_ABERRATION   0 // [0 1]
#define ABERRATION_STRENGTH 1.50 // [0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00]

#define FOCAL        7.0 // [1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0 17.0 18.0 19.0 20.0]
#define APERTURE     4.0 // [1.0 1.2 1.4 2.0 2.8 4.0 5.6 8.0 11.0 16.0 22.0 32.0]
#define ISO          200 // [50 100 200 400 800 1600 3200 6400 12800 25600 51200]
#define SHUTTER_SPEED 60 // [4 5 6 8 10 15 20 30 40 50 60 80 100 125 160 200 250 320 400 500 640 800 1000 1250 1600 2000 2500 3200 4000]

const float K =  12.5; // Light meter calibration
const float S = 100.0; // Sensor sensitivity

#define EXPOSURE 1 // [0 1]

/*------------------ COLOR CORRECTION ------------------*/
#define TONEMAP 3 // [-1 0 1 2 3]
#define LUT     0 // [0 1]

#define VIBRANCE   1.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.55 1.60 1.65 1.70 1.75 1.80 1.85 1.90 1.95 2.00]
#define SATURATION 1.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.55 1.60 1.65 1.70 1.75 1.80 1.85 1.90 1.95 2.00]
#define CONTRAST   1.00 // [0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50]
#define BRIGHTNESS 0.00 // [-0.25 -0.20 -0.15 -0.10 -0.05 0.00 0.05 0.10 0.15 0.20 0.25]

/*------------------ OTHER ------------------*/
#if AO == 1 || GI == 1
     const float ambientOcclusionLevel = 0.0;
#else
     const float ambientOcclusionLevel = 1.0;
#endif
