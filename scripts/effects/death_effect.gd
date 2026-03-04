## DeathEffect.gd
## Larger particle burst spawned at enemy death position.
## Self-destructs after particles finish.

extends Node3D
class_name DeathEffect


func _ready() -> void:
	# Larger particle burst
	var particles := GPUParticles3D.new()
	particles.amount = 24
	particles.lifetime = 0.5
	particles.one_shot = true
	particles.emitting = true
	particles.local_coords = false

	var mat := ParticleProcessMaterial.new()
	mat.direction = Vector3(0, 1, 0)
	mat.spread = 180.0
	mat.initial_velocity_min = 2.0
	mat.initial_velocity_max = 5.0
	mat.gravity = Vector3(0, -3, 0)
	mat.scale_min = 0.5
	mat.scale_max = 1.5

	# Purple → transparent (matches enemy theme)
	var gradient := Gradient.new()
	gradient.set_color(0, Color(0.8, 0.4, 1, 1))
	gradient.set_color(1, Color(0.4, 0.1, 0.6, 0))
	var gradient_tex := GradientTexture1D.new()
	gradient_tex.gradient = gradient
	mat.color_ramp = gradient_tex

	particles.process_material = mat

	# Sphere mesh per particle
	var mesh := SphereMesh.new()
	mesh.radius = 0.05
	mesh.height = 0.1
	var mesh_mat := StandardMaterial3D.new()
	mesh_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_mat.albedo_color = Color(0.8, 0.4, 1, 1)
	mesh_mat.emission_enabled = true
	mesh_mat.emission = Color(0.6, 0.2, 0.9, 1)
	mesh_mat.emission_energy_multiplier = 3.0
	mesh.material = mesh_mat
	particles.draw_pass_1 = mesh

	add_child(particles)

	# Bright flash
	var light := OmniLight3D.new()
	light.light_color = Color(0.7, 0.3, 1)
	light.light_energy = 5.0
	light.omni_range = 3.0
	add_child(light)

	# Fade out light
	var tween := create_tween()
	tween.tween_property(light, "light_energy", 0.0, 0.3)

	# Self-destruct after particles finish
	get_tree().create_timer(1.0).timeout.connect(queue_free)
