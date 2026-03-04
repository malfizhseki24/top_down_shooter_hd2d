shader_type spatial;
render_mode blend_add, unshaded, cull_disabled, shadows_disabled;

uniform sampler2D sprite_texture : source_color, filter_nearest;
uniform vec4 rim_color : source_color = vec4(1.0, 0.95, 0.85, 1.0);
uniform float rim_intensity : hint_range(0.0, 2.0) = 0.5;
uniform float rim_width : hint_range(0.5, 4.0) = 1.5;

void fragment() {
	vec2 pixel = rim_width / vec2(textureSize(sprite_texture, 0));

	float alpha = texture(sprite_texture, UV).a;
	if (alpha < 0.5) {
		discard;
	}

	// Sample 4 cardinal neighbors for edge detection
	float n_r = texture(sprite_texture, UV + vec2( pixel.x, 0.0)).a;
	float n_l = texture(sprite_texture, UV + vec2(-pixel.x, 0.0)).a;
	float n_u = texture(sprite_texture, UV + vec2(0.0, -pixel.y)).a;
	float n_d = texture(sprite_texture, UV + vec2(0.0,  pixel.y)).a;

	// Count transparent neighbors (1.0 = neighbor is transparent = we're at edge)
	float edge = 0.0;
	edge += step(n_r, 0.5);
	edge += step(n_l, 0.5);
	edge += step(n_u, 0.5);
	edge += step(n_d, 0.5);

	// Upper-left bias: top and left edges get extra glow (sun direction)
	float bias = 0.0;
	bias += step(n_u, 0.5) * 0.3;
	bias += step(n_l, 0.5) * 0.3;

	edge = clamp((edge + bias) / 2.0, 0.0, 1.0);

	if (edge < 0.01) {
		discard;
	}

	ALBEDO = rim_color.rgb;
	ALPHA = edge * rim_intensity;
}
