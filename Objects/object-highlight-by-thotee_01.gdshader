shader_type spatial;

render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

uniform vec3 albedo_color : source_color = vec3(1,1,1);
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap_anisotropic,repeat_enable;

uniform vec2 uv1_scale = vec2(1,1);
uniform vec2 uv1_offset = vec2(0,0);

uniform float highlight = 0.0;

uniform sampler2D highlight_texture : source_color,repeat_enable;
uniform vec4 highlight_color : source_color;
uniform float emission_power : hint_range(0.0, 5.0);


void vertex() {
    UV=UV*uv1_scale+uv1_offset;
}

void fragment() {
    vec2 base_uv = UV;
    vec3 albedo_tex = texture(texture_albedo,base_uv).rgb;
    
    vec2 highlight_uv = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).yx - MODEL_MATRIX[3].yx;
    highlight_uv.x += TIME * 0.4;
    highlight_uv.x *= 1.0;
    float highlight_mask = texture(highlight_texture,highlight_uv).r;
    
    ALBEDO = albedo_color * albedo_tex;
    EMISSION = highlight_color.rgb * highlight_mask * emission_power * highlight;
    SPECULAR = 0.5;
}