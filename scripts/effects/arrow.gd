## Arrow.gd
## Handles arrow projectile movement in top-down view.
## Arrows travel in a straight line and return to pool after lifetime expires.

extends Area3D
class_name Arrow

## Movement speed in units per second.
@export var speed: float = 15.0

## Time in seconds before arrow despawns.
@export var lifetime: float = 3.0

var _direction: Vector3 = Vector3.FORWARD
var _lifetime_timer: float = 0.0
var _is_active: bool = false


func _physics_process(delta: float) -> void:
	if not _is_active:
		return

	position += _direction * speed * delta

	_lifetime_timer += delta
	if _lifetime_timer >= lifetime:
		_despawn()


## Sets the direction the arrow will travel.
## The direction is normalized internally.
## Note: Rotation is handled by look_at() in the shooter script.
func set_direction(dir: Vector3) -> void:
	_direction = dir.normalized()


## Resets arrow state for pool reuse.
## Called by ObjectPool when arrow is released back to pool.
func reset() -> void:
	_lifetime_timer = 0.0
	_direction = Vector3.FORWARD
	_is_active = false


## Activates arrow when acquired from pool.
func activate() -> void:
	_is_active = true


## Returns arrow to pool instead of freeing.
func _despawn() -> void:
	_is_active = false

	# Return to pool if available, otherwise fall back to queue_free
	if ObjectPool and ObjectPool.has_method("release"):
		ObjectPool.release("Arrow", self)
	else:
		queue_free()
