## EnemySpawner.gd
## Spawns enemies at configured intervals.
## Place in level scene and configure spawn points.

extends Node3D
class_name EnemySpawner

## Enemy scene to spawn.
@export var enemy_scene: PackedScene

## Time between spawns in seconds.
@export var spawn_interval: float = 3.0

## Maximum enemies alive at once.
@export var max_enemies: int = 5

## Whether to spawn on ready.
@export var spawn_on_start: bool = true

## Spawn points (child Marker3D nodes).
var _spawn_points: Array[Marker3D] = []
var _spawn_timer: float = 0.0
var _active_enemies: int = 0


func _ready() -> void:
	# Collect spawn points from children
	for child in get_children():
		if child is Marker3D:
			_spawn_points.append(child)

	if _spawn_points.is_empty():
		# Use self position as fallback spawn point
		var fallback := Marker3D.new()
		fallback.global_position = global_position
		add_child(fallback)
		_spawn_points.append(fallback)


func _process(delta: float) -> void:
	if not spawn_on_start:
		return

	if _active_enemies >= max_enemies:
		return

	_spawn_timer += delta
	if _spawn_timer >= spawn_interval:
		_spawn_timer = 0.0
		spawn_enemy()


func spawn_enemy() -> void:
	if enemy_scene == null:
		push_warning("EnemySpawner: No enemy_scene assigned")
		return

	if _spawn_points.is_empty():
		push_warning("EnemySpawner: No spawn points available")
		return

	# Pick random spawn point
	var spawn_point: Marker3D = _spawn_points.pick_random()

	# Instantiate enemy
	var enemy := enemy_scene.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = spawn_point.global_position

	# Connect to died signal to track active enemies
	if enemy.has_signal("died"):
		enemy.died.connect(_on_enemy_died)

	_active_enemies += 1

	# Emit event for HUD, score, wave system
	Events.enemy_spawned.emit(enemy)


func _on_enemy_died() -> void:
	_active_enemies -= 1
