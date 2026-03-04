## HurtboxComponent.gd
## Area3D-based component for receiving damage from hitboxes.
## Attach this to entities that can take damage (player, enemies).
## Configure collision_layer for faction (player/enemy hurtbox).
## Hurtboxes are passive - they are detected by hitboxes, not vice versa.

extends Area3D
class_name HurtboxComponent

## Emitted when this hurtbox receives damage from a hitbox.
signal damage_received(hitbox: HitboxComponent)

## Reference to the owner entity (set by parent in _ready)
var owner_entity: Node = null


func _ready() -> void:
	# Get reference to parent entity
	owner_entity = get_parent()
	# Hurtboxes are passive - they don't need to detect areas
	# They are detected by hitboxes via area_entered on the hitbox side


## Called by HitboxComponent when damage is dealt.
## Emits damage_received signal for parent entity to handle.
func receive_damage(hitbox: HitboxComponent) -> void:
	damage_received.emit(hitbox)


## Enable or disable hurtbox detection (for i-frames).
## Set to false during dash or invulnerability periods.
func set_invulnerable(invulnerable: bool) -> void:
	set_deferred("monitoring", not invulnerable)
	set_deferred("monitorable", not invulnerable)
