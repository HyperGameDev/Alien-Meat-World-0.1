shader_type spatial;

uniform sampler2D mask_texture;
uniform sampler2D noise_texture;
uniform sampler2D gradient_texture: source_color;
uniform vec4 albedo_a:source_color = vec4(1.0f);
uniform vec4 albedo_b:source_color = vec4(1.0f);

uniform float noise_size: hint_range(0.0, 10.0, 0.1) = 5.0;
uniform float noise_strength: hint_range(0.0, 1.0, 0.05) = 1.0;
uniform float dirtiness: hint_range(0.1, 1.0) = 0.96;


void fragment() {
	float mask_value = texture(mask_texture, UV).r;
	float noise_value = texture(noise_texture, UV * noise_size).r; 
	//greyscale values have r==g==b, so it doesnt matter which i pick. i did "r" to get a float.
	
	float mask_noise_combo = noise_value * mask_value * noise_strength;
	float uv_factor = dirtiness * (1.0 - (mask_noise_combo + 0.01));
	
	vec3 gradient_color = texture(gradient_texture, vec2(uv_factor)).rgb;
	
	vec3 final_color = mix(albedo_b, albedo_a, pow(mask_noise_combo, dirtiness)).rgb;
	
	ALBEDO = gradient_color;
}