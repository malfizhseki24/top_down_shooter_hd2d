## PlayerController.gd
## Handles player movement in top-down view using WASD inputs.
## Movement occurs on the X-Z plane with collision-based physics.
## Sprite faces the mouse cursor for twin-stick shooter mechanics.

extends CharacterBody3D
class_name PlayerController

## Movement speed in units per second.
## Adjust this value in the Inspector for game balancing.
@export var movement_speed: float = 5.0

@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D

var _camera: Camera3D


func _ready() -> void:
	add_to_group("players")
	_camera = get_viewport().get_camera_3d()


func _physics_process(_delta: float) -> void:
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


func _update_animation(direction: Vector3) -> void:
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
	# Convert mouse screen position to world position on Y=0 plane
	if _camera == null:
		return global_position

	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := _camera.project_ray_origin(mouse_pos)
	var ray_dir := _camera.project_ray_normal(mouse_pos)

	# Intersect with Y=0 plane (ground)
	var plane := Plane(Vector3.UP, 0)
	var intersection: Variant = plane.intersects_ray(ray_origin, ray_dir)

	# Return intersection or player position as fallback
	return intersection if intersection != null else global_position


func _get_aim_direction() -> Vector3:
	# Get direction from player to mouse world position
	var mouse_world_pos := _get_mouse_world_position()
	var aim_dir := (mouse_world_pos - global_position).normalized()
	aim_dir.y = 0  # Keep on X-Z plane
	return aim_dir
