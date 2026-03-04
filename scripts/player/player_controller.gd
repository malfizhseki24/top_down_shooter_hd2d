## PlayerController.gd
## Handles player movement in top-down view using WASD inputs.
## Movement occurs on the X-Z plane with collision-based physics.
## Sprite faces the mouse cursor for twin-stick shooter mechanics.
## Shooting mechanics allow firing arrows toward mouse cursor.
## Dash mechanic provides quick evasion with i-frames.

extends CharacterBody3D
class_name PlayerController

## Movement speed in units per second.
## Adjust this value in the Inspector for game balancing.
@export var movement_speed: float = 5.0

## Arrow scene to instantiate when shooting.
@export var arrow_scene: PackedScene

## Cooldown time between shots in seconds.
@export var shoot_cooldown: float = 0.4

## Dash speed in units per second.
@export var dash_speed: float = 15.0

## Dash duration in seconds.
@export var dash_duration: float = 0.2

## Dash cooldown in seconds.
@export var dash_cooldown: float = 0.5

@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var gun_marker: Node3D = $GunMarker
@onready var hurtbox: HurtboxComponent = $Hurtbox
@onready var health: HealthComponent = $HealthComponent

var _camera: Camera3D
var _cooldown_timer: float = 0.0

# Dash state machine
enum State { NORMAL, DASHING }
var current_state: State = State.NORMAL
var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _dash_direction: Vector3 = Vector3.FORWARD
var _last_movement_direction: Vector3 = Vector3.FORWARD


func _ready() -> void:
	add_to_group("players")
	_camera = get_viewport().get_camera_3d()

	# Connect to animation finished signal
	animated_sprite.animation_finished.connect(_on_animation_finished)

	# Connect hurtbox to health component
	if hurtbox and health:
		hurtbox.damage_received.connect(_on_hurtbox_damage_received)
		health.died.connect(_on_player_died)


func _physics_process(delta: float) -> void:
	# Update cooldown timers
	if _cooldown_timer > 0:
		_cooldown_timer -= delta
	if _dash_cooldown_timer > 0:
		_dash_cooldown_timer -= delta

	# Handle state machine
	match current_state:
		State.NORMAL:
			_handle_normal_movement(delta)
		State.DASHING:
			_handle_dash(delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_shoot()
	elif event.is_action_pressed("dash"):
		_try_dash()


func _on_animation_finished() -> void:
	# Return to appropriate animation after attack finishes
	if animated_sprite.animation == &"attacking":
		# Reset speed scale
		animated_sprite.speed_scale = 1.0
		# Play appropriate animation based on movement (directly, not via _update_animation)
		var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
		if direction == Vector3.ZERO:
			animated_sprite.play(&"idle")
		else:
			animated_sprite.play(&"running")


## NORMAL STATE HANDERS

func _handle_normal_movement(delta: float) -> void:
	# Read WASD input as a 2D vector
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Convert to 3D direction on the X-Z plane (top-down)
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

	# Track last movement direction for dash
	if direction != Vector3.ZERO:
		_last_movement_direction = direction

	# Apply velocity for movement
	velocity.x = direction.x * movement_speed
	velocity.z = direction.z * movement_speed

	# Update animation based on movement
	_update_animation(direction)

	# Update sprite orientation based on mouse aim
	_update_sprite_orientation()

	# Move with collision handling
	move_and_slide()


## DASHING STATE HANDERS

func _handle_dash(delta: float) -> void:
	# Update dash timer
	_dash_timer -= delta

	# Apply dash velocity
	velocity.x = _dash_direction.x * dash_speed
	velocity.z = _dash_direction.z * dash_speed

	# Move with collision handling
	move_and_slide()

	# End dash when timer expires
	if _dash_timer <= 0:
		_end_dash()


## DASH FUNCTIONS

func _try_dash() -> void:
	# Check if already dashing or cooldown not ready
	if current_state != State.NORMAL:
		return
	if _dash_cooldown_timer > 0:
		return

	_start_dash()


func _start_dash() -> void:
	current_state = State.DASHING
	_dash_timer = dash_duration
	_dash_cooldown_timer = dash_cooldown

	# Determine dash direction
	if _last_movement_direction != Vector3.ZERO:
		# Use last movement direction
		_dash_direction = _last_movement_direction
	else:
		# Use facing direction (based on sprite flip)
		_dash_direction = Vector3.RIGHT if not animated_sprite.flip_h else Vector3.LEFT

	# Enable i-frames (disable hurtbox)
	hurtbox.set_deferred("monitoring", false)
	hurtbox.set_deferred("monitorable", false)

	# Also enable invulnerability on health component for extra safety
	if health:
		health.is_invulnerable = true

	# Play dash animation at 8x speed to fit the short dash duration
	# (8 frames / 5 FPS = 1.6s, but dash is 0.2s, so need 8x speed)
	animated_sprite.speed_scale = 8.0
	animated_sprite.play(&"dash")


func _end_dash() -> void:
	current_state = State.NORMAL

	# Disable i-frames (re-enable hurtbox)
	hurtbox.set_deferred("monitoring", true)
	hurtbox.set_deferred("monitorable", true)

	# Disable invulnerability on health component
	if health:
		health.is_invulnerable = false

	# Reset animation speed scale
	animated_sprite.speed_scale = 1.0

	# Return to appropriate animation based on movement
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction == Vector3.ZERO:
		animated_sprite.play(&"idle")
	else:
		animated_sprite.play(&"running")


## HELPER FUNCTIONS

func _update_animation(direction: Vector3) -> void:
	# Don't interrupt attack or dash animation
	if animated_sprite.animation == &"attacking" or animated_sprite.animation == &"dash":
		return

	# Switch between idle and running based on movement
	if direction == Vector3.ZERO:
		if animated_sprite.animation != &"idle":
			animated_sprite.play(&"idle")
	else:
		if animated_sprite.animation != &"running":
			animated_sprite.play(&"running")


func _update_sprite_orientation() -> void:
	# Flip sprite based on mouse aim direction
	var aim_dir := _get_aim_direction()
	if aim_dir.x < 0:
		animated_sprite.flip_h = true
	elif aim_dir.x > 0:
		animated_sprite.flip_h = false


func _get_mouse_world_position() -> Vector3:
	# Convert mouse screen position to world position on a plane at arrow spawn height
	if _camera == null:
		return global_position

	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := _camera.project_ray_origin(mouse_pos)
	var ray_dir := _camera.project_ray_normal(mouse_pos)

	# Intersect with plane at arrow spawn height (not Y=0)
	# This ensures accurate direction toward cursor
	var arrow_height := gun_marker.global_position.y
	var plane := Plane(Vector3.UP, Vector3(0, arrow_height, 0))
	var intersection: Variant = plane.intersects_ray(ray_origin, ray_dir)

	# Return intersection or player position as fallback
	return intersection if intersection != null else global_position


func _get_aim_direction() -> Vector3:
	# Get direction from player to mouse world position
	var mouse_world_pos := _get_mouse_world_position()
	var aim_dir := (mouse_world_pos - global_position).normalized()
	aim_dir.y = 0  # Keep on X-Z plane
	return aim_dir


func _shoot() -> void:
	# Check cooldown
	if _cooldown_timer > 0:
		return

	# Play attack animation (restart if already playing)
	animated_sprite.play(&"attacking")
	animated_sprite.speed_scale = 2.0  # Play at 2x speed for faster attack

	# Acquire arrow from pool
	var arrow: Arrow = ObjectPool.acquire("Arrow")

	# Check if arrow was acquired successfully
	if arrow == null:
		push_warning("Failed to acquire arrow from ObjectPool")
		return

	# Add to scene tree if not already added
	if not arrow.is_inside_tree():
		get_tree().current_scene.add_child(arrow)

	# Set arrow position at gun marker
	arrow.global_position = gun_marker.global_position

	# Get target position and ensure Y matches arrow position
	# This prevents arrow from tilting up/down
	var target_pos := _get_mouse_world_position()
	var look_target := target_pos
	look_target.y = arrow.global_position.y

	# Rotate arrow to face the cursor
	arrow.look_at(look_target, Vector3.UP)

	# Add 90° Y offset because arrow sprite points +X but look_at aligns -Z
	arrow.rotation.y += PI / 2

	# Calculate direction for movement
	var direction: Vector3 = (look_target - arrow.global_position).normalized()

	# Set arrow direction
	arrow.set_direction(direction)

	# Activate arrow after configuration
	arrow.activate()

	# Reset cooldown
	_cooldown_timer = shoot_cooldown


## HEALTH SYSTEM HANDLERS

func _on_hurtbox_damage_received(hitbox: HitboxComponent) -> void:
	# Delegate damage to HealthComponent
	if health:
		health.take_damage(hitbox.damage)


func _on_player_died() -> void:
	# For MVP: Print death message to console
	# (Death screen/game over will be added in Phase 4.5)
	print("Player died!")
	# TODO: Trigger game over screen, respawn, etc.
