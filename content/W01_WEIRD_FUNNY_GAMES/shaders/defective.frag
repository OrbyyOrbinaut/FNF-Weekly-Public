//SHADERTOY PORT FIX
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define iChannel1 bitmap
#define iChannel2 bitmap
#define iChannel3 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
#define iChannelResolution bitmap
//SHADERTOY PORT FIX

const float pi = 3.14159265358979323846;
const float epsilon = 1e-6;

const float fringeExp = 2.3;
const float fringeScale = 0.005;
const float distortionExp = 2.0;
const float distortionScale = 0.2;

const float startAngle = 1.23456 + pi;	// tweak to get different fringe colouration
const float angleStep = pi * 2.0 / 3.0;	// space samples every 120 degrees

void mainImage( )
{
	vec2 baseUV = fragCoord.xy / iResolution.xy;
	vec2 fromCentre = baseUV - vec2(0.5, 0.5);
	// correct for aspect ratio
	fromCentre.y *= iResolution.y / iResolution.x;
	float radius = length(fromCentre);
    fromCentre = radius > epsilon
        ? (fromCentre * (1.0 / radius))
        : vec2(0);
	
    float strength = 1.2;
    float rotation = 2.0 * pi;
    
	float fringing = fringeScale * pow(radius, fringeExp) * strength;
    float distortion = distortionScale * pow(radius, distortionExp) * strength;
    
    vec2 distortUV = baseUV - fromCentre * distortion;
	
	float angle;
	vec2 dir;
	
	angle = startAngle + rotation;
	dir = vec2(sin(angle), cos(angle));
	vec4 redPlane = texture(iChannel0,	distortUV + fringing * dir);
	angle += angleStep;
	dir = vec2(sin(angle), cos(angle));
	vec4 greenPlane = texture(iChannel0,	distortUV + fringing * dir);
	angle += angleStep;
	dir = vec2(sin(angle), cos(angle));
	vec4 bluePlane = texture(iChannel0,	distortUV + fringing * dir);
	
	fragColor = vec4(redPlane.r, greenPlane.g, bluePlane.b, 1.0);
}