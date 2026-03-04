## HealthComponent.gd
## Reusable component for managing entity health.
## Attach to any entity that can take damage (player, enemies, NPCs).
## Emits signals for health changes and death for UI/game state integration.

extends Node
class_name HealthComponent

## Maximum health points. Configure in Inspector per entity.
@export var max_health: int = 3

## Toggle invulnerability (for i-frames during dash or damage cooldown).
var is_invulnerable: bool = false

## Emitted when health changes (damage or heal).
## Parameters: new_health, old_health
signal health_changed(new_health: int, old_health: int)

## Emitted when health reaches zero. Only fires once per entity lifetime.
signal died()

## Current health state (internal).
var _current_health: int
var _has_died: bool = false


func _ready() -> void:
	# Initialize health from max_health
	_current_health = max_health


## Apply damage to health. Respects invulnerability.
## Emits health_changed and died signals as appropriate.
func take_damage(amount: int) -> void:
	# Block damage if invulnerable
	if is_invulnerable:
		return

	# Store old health for signal
	var old_health := _current_health

	# Apply damage and clamp to valid range
	_current_health = clamp(_current_health - amount, 0, max_health)

	# Emit health_changed if health actually changed
	if _current_health != old_health:
		health_changed.emit(_current_health, old_health)

	# Emit died signal if health reached 0 (only once)
	if _current_health == 0 and old_health > 0 and not _has_died:
		_has_died = true
		died.emit()


## Restore health. Clamps to max_health.
## Emits health_changed signal.
func heal(amount: int) -> void:
	# Store old health for signal
	var old_health := _current_health

	# Apply healing and clamp to max
	_current_health = clamp(_current_health + amount, 0, max_health)

	# Emit health_changed if health actually changed
	if _current_health != old_health:
		health_changed.emit(_current_health, old_health)


## Get current health as percentage (0.0 to 1.0).
## Useful for UI health bars.
func get_health_percent() -> float:
	if max_health == 0:
		return 0.0
	return float(_current_health) / float(max_health)
