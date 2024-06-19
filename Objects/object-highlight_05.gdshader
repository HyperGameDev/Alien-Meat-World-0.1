shader_type spatial;
render_mode unshaded;

//the depth at which the outline shows

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform float minDepth = 0.0;
uniform float maxDepth = 1.0;

uniform float thickness : hint_range(0, 5.0, 1.0) = 3.0;
uniform vec4 colorOutline : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform float zNear = 0.1;
uniform float zFar = 15.0;

//moves the quad to the camera position (?)
void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

//linearises the depth sample
float linearDepth(float depthSample) {
	depthSample = 2.0 * depthSample - 1.0;
	float zLinear = 2.0 * zNear * zFar / (zFar + zNear - depthSample * (zFar - zNear));
	return zLinear;
}

void fragment() {
	vec4 originalColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	//width and height of the screen / 1.0
	vec2 texelSize = vec2(1.0 / VIEWPORT_SIZE.x, 1.0 / VIEWPORT_SIZE.y);
	
	//UV points
	float offsetPositive = +ceil(thickness * 0.5);
	float offsetNegative = -floor(thickness * 0.5);
	float left = texelSize.x * offsetNegative;
	float right = texelSize.x * offsetPositive;
	float top = texelSize.y * offsetNegative;
	float bottom = texelSize.y * offsetNegative;
	vec2 uv0 = SCREEN_UV + vec2(left, top);
	vec2 uv1 = SCREEN_UV + vec2(right, bottom);
	vec2 uv2 = SCREEN_UV + vec2(right, top);
	vec2 uv3 = SCREEN_UV + vec2(left, bottom);
	
	//depth textures
	float d0 = linearDepth(texture(DEPTH_TEXTURE, uv0).x);
	float d1 = linearDepth(texture(DEPTH_TEXTURE, uv1).x);
	float d2 = linearDepth(texture(DEPTH_TEXTURE, uv2).x);
	float d3 = linearDepth(texture(DEPTH_TEXTURE, uv3).x);
	
	float d = length(vec2(d1 - d0, d3 -d2));
	d = smoothstep(minDepth, maxDepth, d);
	vec4 output = vec4(d);
	
	//we use the mix() function to interpolate between
	// the original and outline color (UE's Shader Lerp)
	ALBEDO = mix(originalColor.rgb, colorOutline.rgb, d);
}