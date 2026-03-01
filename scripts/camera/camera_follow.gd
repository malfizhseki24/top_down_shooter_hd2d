## CameraFollow.gd
## Smooth camera follow script for top-down view.
## Camera follows a target with configurable smoothing and offset.

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


func _ready() -> void:
	# Auto-find player if no target assigned
	if target == null:
		var player := get_tree().get_first_node_in_group("players")
		if player != null and player is Node3D:
			target = player as Node3D
		else:
			# Fallback: find by class name
			var nodes := get_tree().get_nodes_in_group("players")
			for node in nodes:
				if node is Node3D:
					target = node as Node3D
					break


func _process(delta: float) -> void:
	if target == null:
		return

	# Calculate target position with offset
	var target_pos := target.global_position + offset

	# Smooth interpolation to target position
	global_position = global_position.lerp(target_pos, smoothing_speed * delta)
