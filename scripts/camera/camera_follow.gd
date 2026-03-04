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

var _shake_amount: float = 0.0


func _ready() -> void:
	# Defer target search to ensure all nodes are ready
	_find_target.call_deferred()

	# Connect to combat events for screen shake
	Events.player_damaged.connect(_on_player_damaged)
	Events.enemy_killed.connect(_on_enemy_killed)


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
	shake(0.15)


func _on_enemy_killed(_enemy: Node, _position: Vector3) -> void:
	shake(0.05)
