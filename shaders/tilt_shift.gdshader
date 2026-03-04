// Tilt-Shift + Vignette + Chromatic Aberration Effect
// Combines tilt-shift blur with vignette darkening and subtle color fringing

shader_type canvas_item;

// Tilt-Shift parameters
uniform float blur_amount : hint_range(0.0, 8.0) = 3.0;
uniform float focus_size : hint_range(0.1, 0.9) = 0.5;
uniform float focus_center : hint_range(0.0, 1.0) = 0.5;

// Vignette parameters
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.4;
uniform float vignette_stretch : hint_range(0.0, 2.0) = 0.5;

// Chromatic Aberration parameters
uniform float chromatic_aberration : hint_range(0.0, 5.0) = 0.0;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 uv = SCREEN_UV;

	// === TILT-SHIFT ===
	float dist_from_center = abs(uv.y - focus_center);
	float blur_zone = (1.0 - focus_size) / 2.0;

	vec4 color;
	if (dist_from_center > blur_zone) {
		float blur_intensity = blur_amount * ((dist_from_center - blur_zone) / blur_zone);
		color = textureLod(screen_texture, uv, blur_intensity);
	} else {
		color = texture(screen_texture, uv);
	}

	// === CHROMATIC ABERRATION ===
	if (chromatic_aberration > 0.0) {
		vec2 center = vec2(0.5, 0.5);
		vec2 dir = uv - center;
		float dist_ca = length(dir);
		vec2 offset = dir * dist_ca * chromatic_aberration * 0.002;

		float r = texture(screen_texture, uv + offset).r;
		float b = texture(screen_texture, uv - offset).b;
		color.r = r;
		color.b = b;
	}

	// === VIGNETTE ===
	// Calculate distance from center of screen
	vec2 center = vec2(0.5, 0.5);
	float dist = length(uv - center);

	// Apply vignette (darken edges)
	float vignette = 1.0 - smoothstep(0.3, 0.8 + vignette_stretch, dist * vignette_intensity * 2.0);
	color.rgb *= vignette;

	COLOR = color;
}
