## Arrow.gd
## Handles arrow projectile movement in top-down view.
## Arrows travel in a straight line and return to pool after lifetime expires.
## Arrows stop on collision with world geometry (trees, rocks, walls).
## Arrows deal damage via HitboxComponent and despawn on hit.

extends Area3D
class_name Arrow

## Movement speed in units per second.
@export var speed: float = 15.0

## Time in seconds before arrow despawns.
@export var lifetime: float = 3.0

const HIT_EFFECT_SCENE := preload("res://scenes/effects/hit_effect.tscn")

@onready var hitbox: HitboxComponent = $Hitbox

var _direction: Vector3 = Vector3.FORWARD
var _lifetime_timer: float = 0.0
var _is_active: bool = false


func _ready() -> void:
	# Connect to detect collision with world geometry (Layer 1)
	body_entered.connect(_on_body_entered)

	# Connect hitbox to despawn arrow when it hits an enemy
	if hitbox:
		hitbox.hit_hurtbox.connect(_on_hit_hurtbox)


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


## Handles collision with world geometry (trees, rocks, walls).
## Arrow stops and despawns immediately on impact.
func _on_body_entered(_body: Node) -> void:
	if not _is_active:
		return
	_spawn_hit_effect()
	_despawn()


## Handles hitting an enemy hurtbox.
## Arrow despawns after dealing damage.
func _on_hit_hurtbox(_hurtbox: HurtboxComponent) -> void:
	if not _is_active:
		return
	_spawn_hit_effect()
	_despawn()


## Spawn hit particle effect at impact point.
func _spawn_hit_effect() -> void:
	var effect := HIT_EFFECT_SCENE.instantiate()
	effect.position = global_position
	get_tree().current_scene.add_child(effect)
