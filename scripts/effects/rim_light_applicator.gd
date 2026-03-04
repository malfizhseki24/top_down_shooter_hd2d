## RimLightApplicator
## Static helper to apply rim light shader as material_overlay on AnimatedSprite3D.
## Automatically syncs the sprite texture to the shader on frame/animation changes.

class_name RimLightApplicator

const RIM_SHADER := preload("res://shaders/rim_light.gdshader")


static func apply(sprite: AnimatedSprite3D, color: Color = Color(1.0, 0.95, 0.85), rim_intensity: float = 0.5) -> void:
	var mat := ShaderMaterial.new()
	mat.shader = RIM_SHADER
	mat.set_shader_parameter("rim_color", color)
	mat.set_shader_parameter("rim_intensity", rim_intensity)
	sprite.material_overlay = mat

	var sync_texture := func() -> void:
		if sprite.sprite_frames:
			var tex := sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
			mat.set_shader_parameter("sprite_texture", tex)

	sprite.frame_changed.connect(sync_texture)
	sprite.animation_changed.connect(sync_texture)
	# Initial sync
	sync_texture.call()
