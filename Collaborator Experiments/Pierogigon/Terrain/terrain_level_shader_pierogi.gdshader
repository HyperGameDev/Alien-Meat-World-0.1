shader_type spatial;

uniform sampler2D mask_texture;
uniform sampler2D noise_texture;
//uniform vec2 random_offset;
uniform sampler2D gradient_texture_1: source_color;
uniform vec4 albedo_a:source_color = vec4(1.0f);
uniform vec4 albedo_b:source_color = vec4(1.0f);

uniform float noise_size: hint_range(0.0, 10.0, 0.1) = 5.0;
uniform float noise_strength: hint_range(0.0, 1.0, 0.05) = 1.0;
uniform float dirtiness: hint_range(0.1, 1.0) = 0.96;
uniform float blue_value_ratio: hint_range(0.0, 3.0) = 2.0;


void fragment() {

	float mask_value_red = texture(mask_texture, UV).r;
	float mask_value_blue = texture(mask_texture, UV).b;
	float noise_value = texture(noise_texture, UV * noise_size + random_offset).r;

	//greyscale values have r==g==b, so it doesnt matter which i pick. i did "r" to get a float.
	
	float mask_noise_combo = noise_value * (mask_value_red + blue_value_ratio * mask_value_blue) / 2.0 * noise_strength;
	float uv_factor = dirtiness * (1.0 - clamp(mask_noise_combo + 0.01, 0.0, 0.9));
	
	vec3 gradient_color_1 = texture(gradient_texture_1, vec2(uv_factor)).rgb;
	
	ALBEDO = gradient_color_1.rgb;

}