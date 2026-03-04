## Wisp.gd
## Ranged enemy that maintains distance and shoots purple energy balls at the player.
## Uses distance-based AI: backs away when too close, approaches when too far,
## attacks when in range with a brief telegraph before firing.

extends EnemyBase
class_name Wisp

## Distance at which wisp stops approaching the player.
@export var preferred_distance: float = 8.0

## Distance at which wisp backs away if too close.
@export var min_distance: float = 4.0

## Time between shots in seconds.
@export_range(0.5, 3.0) var attack_cooldown: float = 1.5

## Speed of the bullet.
@export var bullet_speed: float = 10.0

## Damage dealt by bullet.
@export var bullet_damage: int = 1

const BULLET_SCENE := preload("res://scenes/effects/enemy_bullet.tscn")

var _attack_timer: float = 0.0
var _is_attack_on_cooldown: bool = false
var _is_telegraphing: bool = false
var _bob_time: float = 0.0
var _sprite_base_y: float = 0.5


func _ready() -> void:
	super._ready()
	# Override health for 2-hit kill (player arrow does 1 damage)
	max_health = 2
	if health:
		health.max_health = max_health

	# Store base sprite Y position for bobbing
	if animated_sprite:
		_sprite_base_y = animated_sprite.position.y

	# Randomize bob phase so enemies don't sync
	_bob_time = randf() * TAU


func _physics_process(delta: float) -> void:
	if _is_spawning or _is_dying:
		return

	# Floating bob animation
	_bob_time += delta * 2.0
	if animated_sprite:
		animated_sprite.position.y = _sprite_base_y + sin(_bob_time) * 0.08

	if _target_player == null:
		_find_player()
		return

	# Handle attack cooldown
	if _is_attack_on_cooldown:
		_attack_timer += delta
		if _attack_timer >= attack_cooldown:
			_is_attack_on_cooldown = false
			_attack_timer = 0.0

	# Decay knockback
	_knockback_velocity = _knockback_velocity.lerp(Vector3.ZERO, 10.0 * delta)

	# Get distance to player
	var distance_to_player := global_position.distance_to(_target_player.global_position)

	# Determine behavior based on distance and cooldown
	if _is_telegraphing:
		# Hold position during attack telegraph
		velocity = velocity.lerp(_knockback_velocity, acceleration * delta)
		move_and_slide()
	elif distance_to_player < min_distance:
		_back_away(delta)
	elif distance_to_player > preferred_distance:
		_approach_player(delta)
	elif not _is_attack_on_cooldown:
		_perform_attack()
	else:
		_hold_position(delta)


func _back_away(delta: float) -> void:
	if animated_sprite and animated_sprite.animation != &"idle":
		animated_sprite.play(&"idle")

	var direction := (global_position - _target_player.global_position).normalized()
	direction.y = 0
	var target_velocity := direction * move_speed + _knockback_velocity
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	move_and_slide()
	_update_sprite_flip()


func _approach_player(delta: float) -> void:
	if animated_sprite and animated_sprite.animation != &"idle":
		animated_sprite.play(&"idle")

	var direction := (_target_player.global_position - global_position).normalized()
	direction.y = 0
	var target_velocity := direction * move_speed + _knockback_velocity
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	move_and_slide()
	_update_sprite_flip()


func _perform_attack() -> void:
	if _is_telegraphing:
		return

	_is_telegraphing = true
	_update_sprite_flip()

	# Telegraph: flash/pulse sprite before shooting
	if animated_sprite:
		animated_sprite.play(&"attacking")
		var tween := create_tween()
		tween.tween_property(animated_sprite, "modulate", Color(2, 2, 2, 1), 0.15)
		tween.tween_property(animated_sprite, "modulate", Color.WHITE, 0.15)
		tween.tween_callback(_fire_bullet)
	else:
		_fire_bullet()


func _fire_bullet() -> void:
	_is_telegraphing = false
	_is_attack_on_cooldown = true
	_attack_timer = 0.0
	_shoot()


func _hold_position(delta: float) -> void:
	if animated_sprite and animated_sprite.animation != &"idle":
		animated_sprite.play(&"idle")

	# Gentle lateral drift so wisp doesn't feel static
	var drift_dir := Vector3(sin(_bob_time * 0.7), 0, cos(_bob_time * 0.5)) * 0.5
	var target_velocity := drift_dir + _knockback_velocity
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	move_and_slide()
	_update_sprite_flip()


func _update_sprite_flip() -> void:
	if animated_sprite and _target_player:
		animated_sprite.flip_h = _target_player.global_position.x < global_position.x


func _shoot() -> void:
	if _target_player == null:
		return

	# Calculate direction to player (on X-Z plane only)
	var direction := Vector3(
		_target_player.global_position.x - global_position.x,
		0,
		_target_player.global_position.z - global_position.z
	)

	if direction.length_squared() < 0.01:
		direction = Vector3.FORWARD
	else:
		direction = direction.normalized()

	# Spawn bullet in front of wisp to avoid self-collision
	var spawn_offset := direction * 1.0

	# Use scene instantiation
	var bullet := BULLET_SCENE.instantiate()
	bullet.speed = bullet_speed
	bullet.damage = bullet_damage
	bullet.set_direction(direction)

	var spawn_pos := global_position + spawn_offset
	spawn_pos.y = maxf(spawn_pos.y, 0.5)
	bullet.position = spawn_pos

	get_tree().root.add_child(bullet)

	# Rotate bullet to face direction
	var look_target := spawn_pos + direction * 10.0
	if not bullet.global_position.is_equal_approx(look_target):
		bullet.look_at(look_target)

	bullet.activate()
