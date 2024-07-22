#pragma header

uniform float splitCount;
uniform float x;
uniform float y;
uniform bool mirrored;

void main() {
    vec2 uv = openfl_TextureCoordv;
    uv *= splitCount;
    uv.x += x;
    uv.y += y;
    if(mirrored) uv.x = 1 - uv.x;

    gl_FragColor = flixel_texture2D(bitmap, fract(uv)); 
}