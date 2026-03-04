## EnemyBullet.gd
## Handles enemy projectile movement in top-down view.
## Bullets travel in a straight line and despawn after lifetime expires.
## Bullets deal damage via HitboxComponent and despawn on hit.

extends Area3D
class_name EnemyBullet

## Movement speed in units per second.
@export var speed: float = 10.0

## Time in seconds before bullet despawns.
@export var lifetime: float = 3.0

## Damage dealt on hit.
@export var damage: int = 1

@onready var hitbox: HitboxComponent = $Hitbox

var _direction: Vector3 = Vector3.FORWARD
var _lifetime_timer: float = 0.0
var _is_active: bool = false
var _spawn_grace: float = 0.0


func _ready() -> void:
	# Sync hitbox damage with bullet damage and connect signal
	if hitbox:
		hitbox.damage = damage
		hitbox.hit_hurtbox.connect(_on_hit_hurtbox)

	# Connect body entered for world geometry collision
	body_entered.connect(_on_body_entered)

	# Start disabled, activated after positioning
	monitoring = false
	monitorable = false

	# Add purple particle trail
	_setup_trail_particles()


func _physics_process(delta: float) -> void:
	if not _is_active:
		return

	if _spawn_grace > 0:
		_spawn_grace -= delta

	position += _direction * speed * delta

	_lifetime_timer += delta
	if _lifetime_timer >= lifetime:
		_despawn()


## Sets the direction the bullet will travel.
func set_direction(dir: Vector3) -> void:
	_direction = dir.normalized()


## Sets the bullet speed.
func set_speed(new_speed: float) -> void:
	speed = new_speed


## Resets bullet state for pool reuse.
func reset() -> void:
	_lifetime_timer = 0.0
	_direction = Vector3.FORWARD
	_is_active = false


## Activates bullet when acquired from pool.
## Uses a brief grace period to prevent instant despawn from overlapping ground geometry.
func activate() -> void:
	_is_active = true
	_spawn_grace = 0.05
	monitoring = true
	monitorable = true


## Returns bullet to pool instead of freeing.
func _despawn() -> void:
	_is_active = false
	queue_free()


## Handles collision with world geometry.
## Ignores during spawn grace period to avoid instant despawn from ground overlap.
func _on_body_entered(_body: Node) -> void:
	if not _is_active or _spawn_grace > 0:
		return
	_despawn()


## Handles hitting a player hurtbox.
func _on_hit_hurtbox(_hurtbox: HurtboxComponent) -> void:
	if not _is_active:
		return
	_despawn()


func _setup_trail_particles() -> void:
	var particles := GPUParticles3D.new()
	particles.amount = 12
	particles.lifetime = 0.3
	particles.emitting = true
	particles.local_coords = false

	var mat := ParticleProcessMaterial.new()
	mat.direction = Vector3.ZERO
	mat.spread = 180.0
	mat.initial_velocity_min = 0.0
	mat.initial_velocity_max = 0.3
	mat.gravity = Vector3.ZERO
	mat.scale_min = 0.5
	mat.scale_max = 1.0

	# Color ramp: purple to transparent
	var gradient := Gradient.new()
	gradient.set_color(0, Color(0.7, 0.2, 0.9, 0.8))
	gradient.set_color(1, Color(0.4, 0.1, 0.6, 0.0))
	var gradient_texture := GradientTexture1D.new()
	gradient_texture.gradient = gradient
	mat.color_ramp = gradient_texture

	particles.process_material = mat

	# Small sphere mesh for each particle
	var mesh := SphereMesh.new()
	mesh.radius = 0.04
	mesh.height = 0.08
	var mesh_mat := StandardMaterial3D.new()
	mesh_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_mat.albedo_color = Color(0.7, 0.2, 0.9, 0.8)
	mesh_mat.emission_enabled = true
	mesh_mat.emission = Color(0.6, 0.1, 0.9, 1)
	mesh_mat.emission_energy_multiplier = 3.0
	mesh.material = mesh_mat
	particles.draw_pass_1 = mesh

	add_child(particles)
