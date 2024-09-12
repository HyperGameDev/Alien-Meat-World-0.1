shader_type spatial;
render_mode unshaded;
render_mode fog_disabled;uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	ALBEDO = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
}



//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
