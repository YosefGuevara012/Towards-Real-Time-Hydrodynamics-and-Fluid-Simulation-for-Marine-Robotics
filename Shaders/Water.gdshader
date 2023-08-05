shader_type spatial;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec3 albedo: source_color;
uniform vec3 albedo2: source_color;
uniform vec4 color_deep : source_color;
uniform vec4 color_shallow : source_color;

uniform float metallic: hint_range(0.0, 1.0) = 0;
uniform float roughness: hint_range(0.0, 1.0) = 0.02;

uniform sampler2D texture_normal;
uniform sampler2D texture_normal2;

uniform sampler2D wave;
uniform sampler2D wave_bump;

uniform float wave_time = 0;
uniform vec2 wave_direction = vec2(2.0, 0.0);
uniform vec2 wave_direction2 = vec2(0.0, 0.1);
uniform float time_scale : hint_range(0.0, 0.2, 0.005) = 0.025;
uniform float wave_speed = 2.0;
uniform float noise_scale = 10.0;
uniform float height_scale = 0.15;

// Deep varaibles

uniform float beers_law = 2.0;
uniform float depth_offset = -0.75;

// Edge detection code

uniform float edge_scale = 0.3;
uniform float near = 1.0;
uniform float far = 100.0;
uniform vec3 edge_color : source_color;

//varing varaibles
varying float height;
varying vec3 world_pos;

float fresnel(float amount, vec3 normal, vec3 view){
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

float edge(float depth){
//	depth = 2.0 * depth - 1.0;
	return near * far / (far + depth * (near - far));
}


float waveheight(vec2 offset, int mode){
	float h1 = 0.0; // Wave1 texture height
	float h2 = 0.0; // Wave 2 texture height
	float hmix = 0.0;
	
	switch (mode){
		case 0: // Get the height wave 1
			h1 = texture(wave, (world_pos.xz + offset) / noise_scale + (TIME * wave_direction) * time_scale).r;
			return h1;
		case 1: // Get the height wave 2
			h2 = texture(wave, (world_pos.xz + offset) / noise_scale + (TIME * wave_direction2) * time_scale).r;
			return h2;
		case 2: // Get the average between both waves 
			h1 = texture(wave, (world_pos.xz + offset) / noise_scale + (TIME * wave_direction) * time_scale).r;
			h2 = texture(wave, (world_pos.xz + offset) / noise_scale + (TIME * wave_direction2) * time_scale).r;
			hmix = mix(h1, h2, 0.5);
			return hmix;
	}
	
	
}


void vertex(){
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float height_mix = waveheight(vec2(0.0,0.0),2);
	height = texture(wave, world_pos.xz / noise_scale + wave_time * wave_speed).r;
// VERTEX.y += height * height_scale;
    VERTEX.y += height_mix * height_scale;


	
}

void fragment() {
	// Depth variables and calc
	float depth_texture = texture(DEPTH_TEXTURE, SCREEN_UV).r * 2.0 - 1.0;
	float depth = PROJECTION_MATRIX[3][2] / (depth_texture + PROJECTION_MATRIX[2][2]);
	float depth_blend = exp((depth + VERTEX.z + depth_offset) * -beers_law);
	depth_blend = clamp(1.0 - depth_blend, 0.0, 1.0);
	float depth_blend_power = clamp(pow(depth_blend, 2.5) , 0.0, 1.0);
	
	vec3 screen_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, depth_blend_power * 2.5).rbg;
	vec3 depth_color = mix(color_shallow.rgb, color_deep.rgb, depth_blend_power);
	vec3 color = mix(screen_color * depth_color, depth_color * 0.25, depth_blend_power * 0.5);
	
	// uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
	
	// Deep edge calculations
	float z_depth = edge(texture(DEPTH_TEXTURE, SCREEN_UV).x);
	float z_pos = edge(FRAGCOORD.z);
	float z_dif = z_depth - z_pos;
	
	// Time calculations for wave(nomal map) movement
	
	vec2 time = (TIME * wave_direction) * time_scale; //Movement rate of first wave
	vec2 time2 = (TIME * wave_direction2) * time_scale; //Movement rate of first wave
	
	
	// Blend the normal maps into one
	// vec3 normal_blend= mix(texture(texture_normal, UV  + time ).rbg, texture(texture_normal2, UV + time2).rbg, 0.5);
	vec3 normal_blend= mix(texture(texture_normal, world_pos.xz  + time ).rbg, texture(texture_normal2, world_pos.xz + time2).rbg, 0.5);
	
	// Blend Wave1 and Wave2 maps
	vec3 wave_normal_blend = mix(texture(wave_bump, world_pos.xz / noise_scale + time).xyz,texture(wave_bump, world_pos.xz / noise_scale + time2).xyz,0.3);
	
	// calculate Fresnel effect
	float fresnel = fresnel(5.0, NORMAL, VIEW);
	vec3 surface_color = mix(albedo, albedo2, fresnel); // interpolates albedo values in fresnel
	
	vec3 depth_color_adj = mix(edge_color, color, step(edge_scale, z_dif));
	//ALBEDO = albedo;
	//ALBEDO = mix(surface_color, color, 0.75);
	ALBEDO = clamp(surface_color + depth_color_adj, vec3(0.0), vec3(1.0));
	METALLIC = metallic;
	ROUGHNESS = roughness;
	//NORMAL_MAP = normal_blend;
	NORMAL_MAP = mix(wave_normal_blend, normal_blend, 0.5);
	SPECULAR = wave_normal_blend.r;
}
