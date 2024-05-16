shader_type spatial;

uniform sampler2D mask_texture;
uniform sampler2D noise_texture;
uniform vec2 random_offset;
uniform sampler2D gradient_texture_1: source_color;
uniform sampler2D gradient_texture_2: source_color;
uniform vec4 albedo_a:source_color = vec4(1.0f);
uniform vec4 albedo_b:source_color = vec4(1.0f);

uniform float noise_size: hint_range(0.0, 10.0, 0.1) = 5.0;
uniform float noise_strength: hint_range(0.0, 1.0, 0.05) = 1.0;
uniform float dirtiness: hint_range(0.1, 1.0) = 0.96;


void fragment() {
	float mask_value_1 = texture(mask_texture, UV).r;
	float mask_value_2 = texture(mask_texture, UV).b;
	float noise_value = texture(noise_texture, UV * noise_size + random_offset).r;
	//greyscale values have r==g==b, so it doesnt matter which i pick. i did "r" to get a float.
	
	float mask_noise_combo = noise_value * mask_value_1 * noise_strength;
	float uv_factor = dirtiness * (1.0 - (mask_noise_combo + 0.01));
	
	vec3 gradient_color_1 = texture(gradient_texture_1, vec2(uv_factor)).rgb;
	
	vec3 gradient_color_2 = texture(gradient_texture_2, vec2(uv_factor)).rgb;
	
	vec3 final_color = mix(albedo_b, albedo_a, pow(mask_noise_combo, dirtiness)).rgb;
	
	if (mask_value_1 >= mask_value_2)
		{ALBEDO = gradient_color_1.rgb;}
	else
		{ALBEDO = gradient_color_2.rgb;}
}