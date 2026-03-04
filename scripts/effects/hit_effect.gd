## HitEffect.gd
## Short-lived particle burst spawned at arrow/bullet impact point.
## Self-destructs after particles finish.

extends Node3D
class_name HitEffect


func _ready() -> void:
	# Particle burst
	var particles := GPUParticles3D.new()
	particles.amount = 8
	particles.lifetime = 0.3
	particles.one_shot = true
	particles.emitting = true
	particles.local_coords = false

	var mat := ParticleProcessMaterial.new()
	mat.direction = Vector3(0, 1, 0)
	mat.spread = 180.0
	mat.initial_velocity_min = 3.0
	mat.initial_velocity_max = 6.0
	mat.gravity = Vector3(0, -5, 0)
	mat.scale_min = 0.5
	mat.scale_max = 1.0

	# Warm yellow → transparent
	var gradient := Gradient.new()
	gradient.set_color(0, Color(1, 0.9, 0.5, 1))
	gradient.set_color(1, Color(1, 0.5, 0.2, 0))
	var gradient_tex := GradientTexture1D.new()
	gradient_tex.gradient = gradient
	mat.color_ramp = gradient_tex

	particles.process_material = mat

	# Small sphere mesh per particle
	var mesh := SphereMesh.new()
	mesh.radius = 0.03
	mesh.height = 0.06
	var mesh_mat := StandardMaterial3D.new()
	mesh_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_mat.albedo_color = Color(1, 0.9, 0.5, 1)
	mesh_mat.emission_enabled = true
	mesh_mat.emission = Color(1, 0.8, 0.3, 1)
	mesh_mat.emission_energy_multiplier = 3.0
	mesh.material = mesh_mat
	particles.draw_pass_1 = mesh

	add_child(particles)

	# Brief light flash
	var light := OmniLight3D.new()
	light.light_color = Color(1, 0.9, 0.5)
	light.light_energy = 3.0
	light.omni_range = 2.0
	add_child(light)

	# Fade out light
	var tween := create_tween()
	tween.tween_property(light, "light_energy", 0.0, 0.2)

	# Self-destruct after particles finish
	get_tree().create_timer(0.5).timeout.connect(queue_free)
