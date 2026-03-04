## EnemyBase.gd
## Basic enemy that follows the player and can be damaged by arrows.
## Uses CharacterBody3D for physics and HurtboxComponent for damage.
## Includes polish: spawn animation, hit flash, knockback, i-frames, death effect.

extends CharacterBody3D
class_name EnemyBase

const DEATH_EFFECT_SCENE := preload("res://scenes/effects/death_effect.tscn")

## Movement speed toward player in units per second.
@export var move_speed: float = 3.0

## Maximum health points.
@export var max_health: int = 3

## Acceleration factor for smooth movement.
@export var acceleration: float = 10.0

## Knockback strength when hit.
@export var knockback_strength: float = 8.0

## Emitted when the enemy dies.
signal died

@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var hurtbox: HurtboxComponent = $Hurtbox
@onready var health: HealthComponent = $HealthComponent
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var _target_player: PlayerController = null
var _is_invulnerable: bool = false
var _knockback_velocity: Vector3 = Vector3.ZERO
var _is_spawning: bool = true
var _is_dying: bool = false
var _original_sprite_scale: Vector3 = Vector3.ONE


func _ready() -> void:
	add_to_group("enemies")

	# Store original sprite scale before spawn animation
	if animated_sprite:
		_original_sprite_scale = animated_sprite.scale

	# Configure health component from export variable
	if health:
		health.max_health = max_health
		health.died.connect(_on_died)

	# Connect hurtbox damage signal
	if hurtbox:
		hurtbox.damage_received.connect(_on_hurtbox_damage_received)

	# Find player in scene
	_find_player()

	# Play idle animation
	if animated_sprite:
		animated_sprite.play(&"idle")

	# Spawn animation: scale from 0 to full with overshoot
	_play_spawn_animation()


func _physics_process(delta: float) -> void:
	if _is_spawning or _is_dying:
		return

	# Decay knockback
	_knockback_velocity = _knockback_velocity.lerp(Vector3.ZERO, 10.0 * delta)

	# Try to find player if not found
	if _target_player == null:
		_find_player()

	if _target_player == null:
		velocity = velocity.lerp(Vector3.ZERO, acceleration * delta)
		move_and_slide()
		return

	# Calculate direction to player
	var direction := (_target_player.global_position - global_position).normalized()
	direction.y = 0  # Keep on X-Z plane

	# Smooth acceleration toward target velocity
	var target_velocity := direction * move_speed + _knockback_velocity
	velocity = velocity.lerp(target_velocity, acceleration * delta)

	# Move with collision
	move_and_slide()

	# Flip sprite based on movement direction
	if animated_sprite:
		if velocity.x < -0.1:
			animated_sprite.flip_h = true
		elif velocity.x > 0.1:
			animated_sprite.flip_h = false


func _find_player() -> void:
	var players := get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		_target_player = players[0] as PlayerController


func _on_hurtbox_damage_received(hitbox: HitboxComponent) -> void:
	if _is_invulnerable or _is_dying:
		return

	# Apply damage
	if health:
		health.take_damage(hitbox.damage)

	# Knockback away from hitbox source
	var knockback_dir := (global_position - hitbox.global_position).normalized()
	knockback_dir.y = 0
	_knockback_velocity = knockback_dir * knockback_strength

	# Hit flash + brief invulnerability
	_play_hit_flash()
	_start_invulnerability(0.2)


func _on_died() -> void:
	if _is_dying:
		return
	_is_dying = true

	# Emit signals
	died.emit()
	Events.enemy_killed.emit(self, global_position)

	# Disable collision and hurtbox immediately
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
	if hurtbox:
		hurtbox.set_invulnerable(true)

	# Spawn death particle effect
	var effect := DEATH_EFFECT_SCENE.instantiate()
	effect.position = global_position
	get_tree().current_scene.add_child(effect)

	# Death animation: flash white, then shrink + fade
	_play_death_animation()


func _play_spawn_animation() -> void:
	_is_spawning = true
	if hurtbox:
		hurtbox.set_invulnerable(true)

	if animated_sprite:
		animated_sprite.scale = Vector3.ZERO
		var tween := create_tween()
		tween.tween_property(animated_sprite, "scale", _original_sprite_scale * 1.1, 0.2) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(animated_sprite, "scale", _original_sprite_scale, 0.1) \
			.set_ease(Tween.EASE_IN_OUT)
		tween.tween_callback(_on_spawn_complete)
	else:
		_on_spawn_complete()


func _on_spawn_complete() -> void:
	_is_spawning = false
	if hurtbox:
		hurtbox.set_invulnerable(false)


func _play_hit_flash() -> void:
	if not animated_sprite:
		return
	var tween := create_tween()
	tween.tween_property(animated_sprite, "modulate", Color(3, 3, 3, 1), 0.05)
	tween.tween_property(animated_sprite, "modulate", Color.WHITE, 0.1)


func _start_invulnerability(duration: float) -> void:
	_is_invulnerable = true
	if hurtbox:
		hurtbox.set_invulnerable(true)
	get_tree().create_timer(duration).timeout.connect(_end_invulnerability)


func _end_invulnerability() -> void:
	_is_invulnerable = false
	if hurtbox and not _is_dying:
		hurtbox.set_invulnerable(false)


func _play_death_animation() -> void:
	if not animated_sprite:
		queue_free()
		return

	var tween := create_tween()
	# Flash white
	tween.tween_property(animated_sprite, "modulate", Color(3, 3, 3, 1), 0.05)
	# Shrink + fade out
	tween.tween_property(animated_sprite, "modulate", Color(1, 1, 1, 0), 0.25)
	tween.parallel().tween_property(animated_sprite, "scale", Vector3(0.01, 0.01, 0.01), 0.25) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(queue_free)
