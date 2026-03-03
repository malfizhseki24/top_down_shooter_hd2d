## PlayerController.gd
## Handles player movement in top-down view using WASD inputs.
## Movement occurs on the X-Z plane with collision-based physics.
## Sprite faces the mouse cursor for twin-stick shooter mechanics.
## Shooting mechanics allow firing arrows toward mouse cursor.

extends CharacterBody3D
class_name PlayerController

## Movement speed in units per second.
## Adjust this value in the Inspector for game balancing.
@export var movement_speed: float = 5.0

## Arrow scene to instantiate when shooting.
@export var arrow_scene: PackedScene

## Cooldown time between shots in seconds.
@export var shoot_cooldown: float = 0.4

@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var gun_marker: Node3D = $GunMarker

var _camera: Camera3D
var _cooldown_timer: float = 0.0


func _ready() -> void:
	add_to_group("players")
	_camera = get_viewport().get_camera_3d()

	# Connect to animation finished signal
	animated_sprite.animation_finished.connect(_on_animation_finished)


func _physics_process(delta: float) -> void:
	# Update cooldown timer
	if _cooldown_timer > 0:
		_cooldown_timer -= delta

	# Read WASD input as a 2D vector
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Convert to 3D direction on the X-Z plane (top-down)
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

	# Apply velocity for movement
	velocity.x = direction.x * movement_speed
	velocity.z = direction.z * movement_speed

	# Update animation based on movement
	_update_animation(direction)

	# Update sprite orientation based on mouse aim
	_update_sprite_orientation()

	# Move with collision handling
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_shoot()


func _on_animation_finished() -> void:
	# Return to appropriate animation after attack finishes
	if animated_sprite.animation == "attacking":
		# Reset speed scale
		animated_sprite.speed_scale = 1.0
		# Play appropriate animation based on movement (directly, not via _update_animation)
		var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
		if direction == Vector3.ZERO:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("running")


func _update_animation(direction: Vector3) -> void:
	# Don't interrupt attack animation
	if animated_sprite.animation == "attacking":
		return

	# Switch between idle and running based on movement
	if direction == Vector3.ZERO:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
	else:
		if animated_sprite.animation != "running":
			animated_sprite.play("running")


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
	animated_sprite.play("attacking")
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
