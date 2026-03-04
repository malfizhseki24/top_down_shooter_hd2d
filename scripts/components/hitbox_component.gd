## HitboxComponent.gd
## Area3D-based component for dealing damage to hurtboxes.
## Attach this to projectiles or attack hitboxes.
## Configure collision_layer for faction (player/enemy projectile)
## Configure collision_mask for target hurtbox layer.

extends Area3D
class_name HitboxComponent

## Damage dealt when hitting a hurtbox.
@export var damage: int = 1

## Emitted when this hitbox hits a valid hurtbox.
signal hit_hurtbox(hurtbox: HurtboxComponent)


func _ready() -> void:
	# Connect to detect overlaps with hurtboxes
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D) -> void:
	# Check if the area is a hurtbox
	var hurtbox := area as HurtboxComponent
	if hurtbox:
		hit_hurtbox.emit(hurtbox)
		# Let the hurtbox handle damage processing
		hurtbox.receive_damage(self)
