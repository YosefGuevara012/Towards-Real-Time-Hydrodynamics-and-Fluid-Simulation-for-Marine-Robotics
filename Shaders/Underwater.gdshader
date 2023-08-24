shader_type spatial;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec3 albedo : source_color;

uniform sampler2D water_normalmap : hint_normal;
uniform float wave_speed = 1.0;
uniform float wave_amplitude = 0.02;

void fragment() {
    vec2 uv = UV + vec2(TIME * wave_speed, TIME * wave_speed);
    vec3 normal = texture(water_normalmap, uv).xyz * 2.0 - 1.0;
    
    // Using normal to perturb the UV can simulate the distortion
    vec2 distorted_uv = UV + normal.xy * wave_amplitude;
    vec4 base_color = texture(SCREEN_TEXTURE, distorted_uv);
	
	ALBEDO = albedo;
}