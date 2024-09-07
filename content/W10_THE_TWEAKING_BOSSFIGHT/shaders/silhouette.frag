#pragma header

uniform vec3 col;
uniform float amount;

void main() {
	vec4 orig = flixel_texture2D(bitmap, openfl_TextureCoordv);
	gl_FragColor = vec4(mix(orig.rgb, mix(vec3(0.0, 0.0, 0.0), col, orig.a), amount), orig.a);
}