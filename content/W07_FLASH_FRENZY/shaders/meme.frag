// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define round(a) floor(a + 0.5)
#define texture flixel_texture2D
#define iResolution openfl_TextureSize
uniform float iTime;
#define iChannel0 bitmap
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;

vec2 curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	//uv *= 1.1;	
	//uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
	//uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
	uv  = (uv / 2.0) + 0.5;
	//uv =  uv *0.92 + 0.04;
	return uv;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    //Curve
    vec2 uv = fragCoord.xy / iResolution.xy;
	uv = curve( uv );
    
    vec3 col;

    // Chromatic
    col.r = texture(iChannel0,vec2(uv.x+0.003,uv.y)).x;
    col.g = texture(iChannel0,vec2(uv.x+0.000,uv.y)).y;
    col.b = texture(iChannel0,vec2(uv.x-0.003,uv.y)).z;

    col *= step(0.0, uv.x) * step(0.0, uv.y);
    col *= 1.0 - step(1.0, uv.x) * 1.0 - step(1.0, uv.y);

    col *= 0.5 + 0.5*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y);
    col *= vec3(0.95,1.05,0.95);

    col *= 0.9+0.1*sin(10.0*iTime+uv.y*700.0);

    col *= 0.99+0.01*sin(110.0*iTime);

    fragColor = vec4(col,texture(iChannel0, uv).a);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}