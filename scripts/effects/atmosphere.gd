extends Node3D
class_name AtmosphereEffects

@export_group("Dust Particles")
@export var dust_enabled: bool = true
@export var dust_count: int = 80
@export var dust_lifetime: float = 10.0
@export var dust_area: Vector3 = Vector3(20, 3, 16)
@export var dust_velocity_min: float = 0.02
@export var dust_velocity_max: float = 0.08
@export var dust_size: float = 0.015
@export var dust_color: Color = Color(1.0, 1.0, 1.0, 0.6)

@export_group("Ground Fog")
@export var fog_enabled: bool = true
@export var fog_density: float = 0.008
@export var fog_height: float = 0.5
@export var fog_height_density: float = 0.08
@export var fog_color: Color = Color(0.65, 0.7, 0.55)

@export_group("Cloud Shadows")
@export var cloud_shadows_enabled: bool = true
@export var cloud_shadow_size: Vector3 = Vector3(80, 10, 80)
@export var cloud_shadow_intensity: float = 0.8
@export var cloud_scroll_speed: Vector2 = Vector2(0.4, 0.28)
@export var cloud_noise_frequency: float = 0.012

@export_group("Leaf Particles")
@export var leaf_enabled: bool = true
@export var leaf_count: int = 20
@export var leaf_lifetime: float = 10.0
@export var leaf_area: Vector3 = Vector3(20, 1, 16)
@export var leaf_spawn_height: float = 4.0
@export var leaf_color: Color = Color(0.5, 0.6, 0.3, 0.8)

@export_group("Dappled Light")
@export var dappled_light_enabled: bool = true
@export var dappled_light_size: Vector3 = Vector3(20, 10, 20)
@export var dappled_light_color: Color = Color(1, 0.95, 0.8, 0.3)
@export var dappled_scroll_speed: Vector2 = Vector2(0.1, 0.07)
@export var dappled_noise_frequency: float = 0.06

var _cloud_decal: Decal
var _dappled_decal: Decal

func _ready() -> void:
	if dust_enabled:
		_create_dust_particles()
	if fog_enabled:
		_setup_ground_fog()
	if cloud_shadows_enabled:
		_create_cloud_shadows()
	if leaf_enabled:
		_create_leaf_particles()
	if dappled_light_enabled:
		_create_dappled_light()

func _create_dust_particles() -> void:
	var particles := GPUParticles3D.new()
	particles.name = "DustParticles"
	particles.amount = dust_count
	particles.lifetime = dust_lifetime
	particles.local_coords = false
	particles.visibility_aabb = AABB(Vector3(-dust_area.x / 2, 0, -dust_area.z / 2), dust_area)

	var mat := ParticleProcessMaterial.new()
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	mat.emission_box_extents = dust_area / 2.0
	mat.direction = Vector3(0, 0, 0)
	mat.spread = 180.0
	mat.initial_velocity_min = 0.0
	mat.initial_velocity_max = 0.01
	mat.gravity = Vector3(0, 0, 0)
	mat.turbulence_enabled = true
	mat.turbulence_noise_strength = 0.3
	mat.turbulence_noise_speed_random = 0.2
	mat.turbulence_noise_scale = 8.0
	mat.turbulence_influence_min = 0.05
	mat.turbulence_influence_max = 0.15
	# Fade in then fade out over lifetime
	var alpha_curve := CurveTexture.new()
	var curve := Curve.new()
	curve.add_point(Vector2(0.0, 0.0))   # invisible at spawn
	curve.add_point(Vector2(0.15, 1.0))  # fade in
	curve.add_point(Vector2(0.7, 1.0))   # hold
	curve.add_point(Vector2(1.0, 0.0))   # fade out at death
	alpha_curve.curve = curve
	mat.alpha_curve = alpha_curve
	mat.scale_min = 0.8
	mat.scale_max = 1.2
	particles.process_material = mat

	var mesh := SphereMesh.new()
	mesh.radius = dust_size
	mesh.height = dust_size * 2.0
	mesh.radial_segments = 4
	mesh.rings = 2

	var mesh_mat := StandardMaterial3D.new()
	mesh_mat.albedo_color = dust_color
	mesh_mat.emission_enabled = true
	mesh_mat.emission = Color(1.0, 1.0, 1.0)
	mesh_mat.emission_energy_multiplier = 0.5
	mesh_mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	mesh_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_mat.vertex_color_use_as_albedo = true
	mesh.material = mesh_mat

	particles.draw_pass_1 = mesh
	add_child(particles)

func _setup_ground_fog() -> void:
	var world_env: WorldEnvironment
	for child in get_parent().get_children():
		if child is WorldEnvironment:
			world_env = child
			break

	if not world_env or not world_env.environment:
		push_warning("AtmosphereEffects: No WorldEnvironment found, skipping fog.")
		return

	var env := world_env.environment
	env.fog_enabled = true
	env.fog_light_color = fog_color
	env.fog_density = fog_density
	env.fog_height = fog_height
	env.fog_height_density = fog_height_density

func _create_cloud_shadows() -> void:
	_cloud_decal = Decal.new()
	_cloud_decal.name = "CloudShadowDecal"
	_cloud_decal.size = cloud_shadow_size
	_cloud_decal.position = Vector3(0, cloud_shadow_size.y / 2.0, 0)

	# Generate seamless FBM noise texture
	var noise := FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = cloud_noise_frequency
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = 4
	noise.fractal_lacunarity = 2.0
	noise.fractal_gain = 0.5

	# Map noise values to black with alpha via color ramp
	var gradient := Gradient.new()
	gradient.set_offset(0, 0.0)
	gradient.set_color(0, Color(0, 0, 0, 0))       # low noise = no shadow
	gradient.set_offset(1, 0.4)
	gradient.set_color(1, Color(0, 0, 0, 0))        # start transition
	gradient.add_point(0.5, Color(0, 0, 0, cloud_shadow_intensity))  # sharper ramp
	gradient.add_point(1.0, Color(0, 0, 0, cloud_shadow_intensity))

	var noise_tex := NoiseTexture2D.new()
	noise_tex.noise = noise
	noise_tex.width = 512
	noise_tex.height = 512
	noise_tex.seamless = true
	noise_tex.color_ramp = gradient

	_cloud_decal.texture_albedo = noise_tex
	_cloud_decal.modulate = Color(1.0, 1.0, 1.0, 1.0)
	_cloud_decal.albedo_mix = 1.0
	_cloud_decal.upper_fade = 0.3
	_cloud_decal.lower_fade = 0.3

	add_child(_cloud_decal)

func _create_leaf_particles() -> void:
	var particles := GPUParticles3D.new()
	particles.name = "LeafParticles"
	particles.amount = leaf_count
	particles.lifetime = leaf_lifetime
	particles.local_coords = false
	particles.visibility_aabb = AABB(
		Vector3(-leaf_area.x / 2, 0, -leaf_area.z / 2),
		Vector3(leaf_area.x, leaf_spawn_height + 2, leaf_area.z)
	)

	var mat := ParticleProcessMaterial.new()
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	mat.emission_box_extents = Vector3(leaf_area.x / 2.0, 0.5, leaf_area.z / 2.0)
	# Offset emission to canopy height
	mat.emission_shape_offset = Vector3(0, leaf_spawn_height, 0)
	mat.direction = Vector3(0, -1, 0)
	mat.spread = 30.0
	mat.initial_velocity_min = 0.1
	mat.initial_velocity_max = 0.3
	mat.gravity = Vector3(0.2, -1.0, 0.1)
	mat.angular_velocity_min = -30.0
	mat.angular_velocity_max = 30.0
	# Turbulence for natural sway
	mat.turbulence_enabled = true
	mat.turbulence_noise_strength = 0.5
	mat.turbulence_noise_speed_random = 0.3
	mat.turbulence_noise_scale = 6.0
	mat.turbulence_influence_min = 0.1
	mat.turbulence_influence_max = 0.3
	mat.scale_min = 0.6
	mat.scale_max = 1.2
	# Fade in/out
	var alpha_curve := CurveTexture.new()
	var curve := Curve.new()
	curve.add_point(Vector2(0.0, 0.0))
	curve.add_point(Vector2(0.1, 1.0))
	curve.add_point(Vector2(0.8, 1.0))
	curve.add_point(Vector2(1.0, 0.0))
	alpha_curve.curve = curve
	mat.alpha_curve = alpha_curve
	particles.process_material = mat

	# Small quad mesh for leaf shape
	var mesh := QuadMesh.new()
	mesh.size = Vector2(0.06, 0.04)

	var mesh_mat := StandardMaterial3D.new()
	mesh_mat.albedo_color = leaf_color
	mesh_mat.emission_enabled = true
	mesh_mat.emission = Color(leaf_color.r, leaf_color.g, leaf_color.b)
	mesh_mat.emission_energy_multiplier = 0.3
	mesh_mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	mesh_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_mat.vertex_color_use_as_albedo = true
	mesh.material = mesh_mat

	particles.draw_pass_1 = mesh
	add_child(particles)

func _create_dappled_light() -> void:
	_dappled_decal = Decal.new()
	_dappled_decal.name = "DappledLightDecal"
	_dappled_decal.size = dappled_light_size
	_dappled_decal.position = Vector3(0, dappled_light_size.y / 2.0, 0)

	# High-frequency cellular noise for light spots
	var noise := FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.frequency = dappled_noise_frequency
	noise.cellular_distance_function = FastNoiseLite.DISTANCE_EUCLIDEAN
	noise.cellular_return_type = FastNoiseLite.RETURN_DISTANCE
	noise.fractal_type = FastNoiseLite.FRACTAL_NONE

	# Map noise to bright spots via color ramp (inverted — bright where cells meet)
	var gradient := Gradient.new()
	gradient.set_offset(0, 0.0)
	gradient.set_color(0, Color(1, 1, 1, 0.6))   # cell centers = bright spots
	gradient.set_offset(1, 0.4)
	gradient.set_color(1, Color(1, 1, 1, 0.0))    # cell edges = transparent

	var noise_tex := NoiseTexture2D.new()
	noise_tex.noise = noise
	noise_tex.width = 256
	noise_tex.height = 256
	noise_tex.seamless = true
	noise_tex.color_ramp = gradient

	_dappled_decal.texture_albedo = noise_tex
	_dappled_decal.modulate = dappled_light_color
	_dappled_decal.albedo_mix = 1.0
	_dappled_decal.upper_fade = 0.5
	_dappled_decal.lower_fade = 0.5

	add_child(_dappled_decal)

func _process(delta: float) -> void:
	if _cloud_decal:
		_cloud_decal.position.x += cloud_scroll_speed.x * delta
		_cloud_decal.position.z += cloud_scroll_speed.y * delta
		# Wrap within half the decal size so it always covers the play area
		var half_x := cloud_shadow_size.x * 0.25
		var half_z := cloud_shadow_size.z * 0.25
		if _cloud_decal.position.x > half_x:
			_cloud_decal.position.x -= half_x * 2.0
		if _cloud_decal.position.z > half_z:
			_cloud_decal.position.z -= half_z * 2.0

	if _dappled_decal:
		_dappled_decal.position.x += dappled_scroll_speed.x * delta
		_dappled_decal.position.z += dappled_scroll_speed.y * delta
		var half_x := dappled_light_size.x * 0.25
		var half_z := dappled_light_size.z * 0.25
		if _dappled_decal.position.x > half_x:
			_dappled_decal.position.x -= half_x * 2.0
		if _dappled_decal.position.z > half_z:
			_dappled_decal.position.z -= half_z * 2.0
