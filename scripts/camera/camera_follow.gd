## CameraFollow.gd
## Smooth camera follow script for top-down view.
## Camera follows a target with configurable smoothing and offset.
## Supports screen shake on combat events via Events bus.

extends Camera3D
class_name CameraFollow

## The target node to follow (usually the player).
## If null, will try to find a PlayerController in the scene.
@export var target: Node3D

## Smoothing speed for camera movement. Higher = faster follow.
@export var smoothing_speed: float = 5.0

## Offset from target position. Used for top-down angle.
## Default (0, 8, 6) places camera above and behind the target.
@export var offset: Vector3 = Vector3(0, 8, 6)

## How fast shake decays. Higher = faster recovery.
@export var shake_decay_speed: float = 8.0

@export_group("Hit Pause")
## Duration of hit pause on player damage (seconds, real-time).
@export var hit_pause_player_duration: float = 0.05
## Duration of hit pause on enemy kill (seconds, real-time).
@export var hit_pause_kill_duration: float = 0.03

@export_group("Bounds")
## Enable camera bounds clamping to prevent showing areas outside the map.
@export var use_bounds: bool = false
## West (X min) and North (Z min) world-space boundaries.
@export var bounds_min: Vector3 = Vector3(-10, 0, -7)
## East (X max) and South (Z max) world-space boundaries.
@export var bounds_max: Vector3 = Vector3(10, 0, 8)

var _shake_amount: float = 0.0
var _hit_pause_active: bool = false


func _ready() -> void:
	# Defer target search to ensure all nodes are ready
	_find_target.call_deferred()

	# Connect to combat events for screen shake
	Events.player_damaged.connect(_on_player_damaged)
	Events.enemy_killed.connect(_on_enemy_killed)
	Events.player_shot.connect(_on_player_shot)
	Events.player_dashed.connect(_on_player_dashed)


func _find_target() -> void:
	# Auto-find player if no target assigned
	if target == null:
		var player := get_tree().get_first_node_in_group("players")
		if player != null and player is Node3D:
			target = player as Node3D
		else:
			# Fallback: search all nodes in group
			var nodes := get_tree().get_nodes_in_group("players")
			for node in nodes:
				if node is Node3D:
					target = node as Node3D
					break

	if target == null:
		push_error("CameraFollow: No target found! Make sure player is in 'players' group.")


func _process(delta: float) -> void:
	if target == null:
		return

	# Calculate target position with offset
	var target_pos := target.global_position + offset

	# Smooth interpolation to target position
	global_position = global_position.lerp(target_pos, smoothing_speed * delta)

	# Clamp to bounds so viewport edges never exceed map limits
	if use_bounds:
		_apply_bounds()

	# Apply screen shake
	if _shake_amount > 0:
		var shake_offset := Vector3(
			randf_range(-_shake_amount, _shake_amount),
			randf_range(-_shake_amount, _shake_amount) * 0.5,
			randf_range(-_shake_amount, _shake_amount)
		)
		global_position += shake_offset
		_shake_amount = lerpf(_shake_amount, 0.0, shake_decay_speed * delta)
		if _shake_amount < 0.001:
			_shake_amount = 0.0


## Apply screen shake with given intensity. Takes the max of current and new.
func shake(intensity: float) -> void:
	_shake_amount = maxf(_shake_amount, intensity)


func _on_player_damaged(_amount: int) -> void:
	_apply_hit_pause(hit_pause_player_duration, 0.0)
	shake(0.15)


func _on_enemy_killed(_enemy: Node, _position: Vector3) -> void:
	_apply_hit_pause(hit_pause_kill_duration, 0.05)
	shake(0.05)


func _on_player_shot() -> void:
	shake(0.03)


func _on_player_dashed() -> void:
	shake(0.04)


func _apply_bounds() -> void:
	var aspect := get_viewport().get_visible_rect().size.aspect()
	var half_w := (size / 2.0) * aspect

	# The 45° tilt means the viewport center is NOT at the player position on the ground.
	# The camera at (x, y, z) looks at ground point (x, 0, z - y) due to the 45° angle.
	# The viewport extends half_d in each Z direction from that ground center.
	var half_d := (size / 2.0) / sin(deg_to_rad(45.0))

	# Clamp X: viewport half-width from camera center
	var x_min := bounds_min.x + half_w
	var x_max := bounds_max.x - half_w
	if x_min < x_max:
		global_position.x = clampf(global_position.x, x_min, x_max)
	else:
		global_position.x = (bounds_min.x + bounds_max.x) / 2.0

	# Clamp Z: the 45° camera at height Y looks at ground Z = cam_z - cam_y.
	# Viewport top on ground = (cam_z - cam_y) - half_d  → must be >= bounds_min.z
	# Viewport bottom on ground = (cam_z - cam_y) + half_d → must be <= bounds_max.z
	var cam_y := global_position.y
	var z_min := bounds_min.z + cam_y + half_d
	var z_max := bounds_max.z + cam_y - half_d
	if z_min < z_max:
		global_position.z = clampf(global_position.z, z_min, z_max)
	else:
		global_position.z = (z_min + z_max) / 2.0


## Freeze the game briefly for impact emphasis.
## duration_sec is real-time seconds, scale is the Engine.time_scale during the pause.
func _apply_hit_pause(duration_sec: float, scale: float) -> void:
	if _hit_pause_active:
		return
	_hit_pause_active = true
	Engine.time_scale = scale

	# Use a real-time timer that ticks even when time_scale is 0
	get_tree().create_timer(duration_sec, true, false, true).timeout.connect(_end_hit_pause)


func _end_hit_pause() -> void:
	Engine.time_scale = 1.0
	_hit_pause_active = false
