## ObjectPool.gd
## Autoload singleton for object pooling to eliminate runtime allocation overhead.
## Pre-warms pools of reusable objects and provides acquire/release API.

extends Node

## Initial number of arrow instances to pre-allocate.
@export var initial_arrow_pool_size: int = 20

## Maximum pool size before expansion is blocked.
@export var max_pool_size: int = 100

## Allow pool to expand beyond initial size when exhausted.
@export var auto_expand: bool = true

## Arrow scene reference for prewarming and expansion.
@export var arrow_scene: PackedScene

# Internal pool storage: type -> Pool
var _pools: Dictionary = {}


## Internal Pool class for managing available/in-use objects.
class Pool extends RefCounted:
	var _scene: PackedScene
	var _available: Array[Node] = []
	var _in_use: Array[Node] = []
	var _max_size: int
	var _auto_expand: bool
	var _type: String


	func _init(type: String, scene: PackedScene, max_size: int, can_expand: bool) -> void:
		_type = type
		_scene = scene
		_max_size = max_size
		_auto_expand = can_expand


	## Pre-warm pool by creating instances upfront.
	func prewarm(count: int) -> void:
		for i in count:
			var instance: Node = _scene.instantiate()
			_available.append(instance)


	## Acquire an instance from the pool.
	## Returns null if pool is exhausted and cannot expand.
	func acquire() -> Node:
		# Purge any freed instances (e.g. after scene reload)
		_purge_freed()

		if _available.is_empty():
			if not _expand():
				push_error("ObjectPool: Pool '%s' exhausted and cannot expand" % _type)
				return null

		var node: Node = _available.pop_back()
		_in_use.append(node)
		return node


	## Release an instance back to the pool.
	func release(node: Node) -> void:
		if not is_instance_valid(node):
			return

		var idx := _in_use.find(node)
		if idx < 0:
			push_warning("ObjectPool: Attempted to release non-pooled object to '%s'" % _type)
			return

		_in_use.remove_at(idx)

		# Call reset if the node has that method
		if node.has_method("reset"):
			node.reset()

		_available.append(node)


	## Get total pool size (available + in-use).
	func get_total_size() -> int:
		return _available.size() + _in_use.size()


	## Remove freed instances from both available and in-use arrays.
	## This handles scene reloads where pooled nodes get freed.
	func _purge_freed() -> void:
		for i in range(_available.size() - 1, -1, -1):
			if not is_instance_valid(_available[i]):
				_available.remove_at(i)
		for i in range(_in_use.size() - 1, -1, -1):
			if not is_instance_valid(_in_use[i]):
				_in_use.remove_at(i)


	## Expand pool by creating one new instance.
	## Returns true if expansion succeeded.
	func _expand() -> bool:
		if not _auto_expand:
			return false

		var total: int = get_total_size()
		if total >= _max_size:
			push_error("ObjectPool: Pool '%s' reached max size of %d" % [_type, _max_size])
			return false

		push_warning("ObjectPool: Auto-expanding pool '%s' (size: %d)" % [_type, total + 1])
		var instance: Node = _scene.instantiate()
		_available.append(instance)
		return true


func _ready() -> void:
	# Load arrow scene if not assigned in inspector
	if arrow_scene == null:
		arrow_scene = load("res://scenes/effects/arrow.tscn")

	# Pre-warm arrow pool
	if arrow_scene:
		prewarm("Arrow", arrow_scene, initial_arrow_pool_size)
	else:
		push_error("ObjectPool: Failed to load arrow scene!")


## Pre-warm a pool with initial instances.
func prewarm(type: String, scene: PackedScene, count: int) -> void:
	if _pools.has(type):
		push_warning("ObjectPool: Pool '%s' already exists, skipping prewarm" % type)
		return

	var pool := Pool.new(type, scene, max_pool_size, auto_expand)
	pool.prewarm(count)
	_pools[type] = pool


## Acquire an instance from a pool.
## Returns null if pool doesn't exist or is exhausted.
func acquire(type: String) -> Node:
	if not _pools.has(type):
		push_error("ObjectPool: Pool '%s' does not exist" % type)
		return null

	return _pools[type].acquire()


## Release an instance back to its pool.
func release(type: String, node: Node) -> void:
	if not _pools.has(type):
		push_error("ObjectPool: Cannot release to non-existent pool '%s'" % type)
		return

	_pools[type].release(node)


## Get pool statistics for debugging.
func get_pool_stats(type: String) -> Dictionary:
	if not _pools.has(type):
		return {}

	var pool: Pool = _pools[type]
	return {
		"available": pool._available.size(),
		"in_use": pool._in_use.size(),
		"total": pool.get_total_size()
	}
