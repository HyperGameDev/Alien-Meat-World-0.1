shader_type spatial;

uniform sampler2D mask_texture:source_color;
uniform vec4 albedo_a:source_color = vec4(1.0f);
uniform vec4 albedo_b:source_color = vec4(1.0f);

void fragment() {
	vec3 mask = texture(mask_texture, UV).rgb;
	vec3 a = albedo_a.rgb;
	vec3 b = albedo_b.rgb;
	vec3 color = mix(a, b, mask);
	ALBEDO = color;
}