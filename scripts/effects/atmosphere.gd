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
@export var fog_density: float = 0.004
@export var fog_height: float = 0.3
@export var fog_height_density: float = 0.08
@export var fog_color: Color = Color(0.6, 0.7, 0.6)

@export_group("Cloud Shadows")
@export var cloud_shadows_enabled: bool = true
@export var cloud_shadow_size: Vector3 = Vector3(30, 10, 24)
@export var cloud_shadow_intensity: float = 0.8
@export var cloud_scroll_speed: Vector2 = Vector2(0.4, 0.28)
@export var cloud_noise_frequency: float = 0.012

var _cloud_decal: Decal

func _ready() -> void:
	if dust_enabled:
		_create_dust_particles()
	if fog_enabled:
		_setup_ground_fog()
	if cloud_shadows_enabled:
		_create_cloud_shadows()

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
	gradient.set_offset(1, 0.35)
	gradient.set_color(1, Color(0, 0, 0, 0))        # start transition
	gradient.add_point(0.55, Color(0, 0, 0, cloud_shadow_intensity))  # moderate ramp
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

func _process(delta: float) -> void:
	if _cloud_decal:
		_cloud_decal.position.x += cloud_scroll_speed.x * delta
		_cloud_decal.position.z += cloud_scroll_speed.y * delta
		# Wrap to avoid float precision issues
		if _cloud_decal.position.x > cloud_shadow_size.x:
			_cloud_decal.position.x -= cloud_shadow_size.x * 2.0
		if _cloud_decal.position.z > cloud_shadow_size.z:
			_cloud_decal.position.z -= cloud_shadow_size.z * 2.0
