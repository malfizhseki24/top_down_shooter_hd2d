# Design: Basic Enemy

## Engine Version
**Godot 4.x** (tested with Godot 4.6)

## Overview
Implements a basic enemy that follows the player and can be killed by arrows. Uses the same HD-2D pattern as the player with AnimatedSprite3D and Y-Billboard mode.

## Node Structure

```
Enemy (CharacterBody3D)
├── AnimatedSprite3D (Y-Billboard mode)
├── CollisionShape3D (Cylinder - physics body)
├── Hurtbox (Area3D - HurtboxComponent scene)
│   └── CollisionShape3D (Cylinder - hurtbox detection)
└── BlobShadow (Sprite3D - optional visual polish)
```

## Collision Configuration

| Node | collision_layer | collision_mask |
|------|-----------------|----------------|
| Enemy (CharacterBody3D) | 4 (Enemy) | 5 (World + Player) |
| Hurtbox (Area3D) | 64 (EnemyHurtbox) | 8 (PlayerProjectile) |

## Configuration Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `move_speed` | float | 3.0 | Movement speed toward player |
| `max_health` | int | 3 | Hits required to kill |

## AI Behavior

Simple follow-player logic:
```gdscript
func _physics_process(delta: float) -> void:
    if _target_player == null:
        _find_player()

    if _target_player:
        var direction := (_target_player.global_position - global_position).normalized()
        direction.y = 0  # Keep on X-Z plane

        velocity = direction * move_speed
        move_and_slide()

        # Flip sprite based on movement direction
        if velocity.x < 0:
            animated_sprite.flip_h = true
        elif velocity.x > 0:
            animated_sprite.flip_h = false
```

## Health System

For MVP simplicity, health is managed directly in enemy_base.gd:
- `var _current_health: int`
- `_take_damage(amount)` called when hurtbox receives damage
- Emit `died` signal and call `queue_free()` when health <= 0

Future consideration: Extract to HealthComponent for reusability.

## Animation

For MVP, enemy will have a single "idle" animation (or static frame).
- SpriteFrames resource: `enemy_frames.tres`
- Animation name: "idle"
- Can be expanded later with "walk", "hurt", "death" animations

## Sprite Folder Structure

```
assets/sprites/enemies/
└── basic/
    ├── idle/
    │   └── (spritesheet files here)
    └── (future animation folders)
```

## Death Handling

```gdscript
signal died

func _on_hurtbox_damage_received(hitbox: HitboxComponent) -> void:
    _current_health -= hitbox.damage
    if _current_health <= 0:
        died.emit()
        queue_free()
```

## Integration with Existing Systems

1. **Arrow Hitbox**: Already configured to detect Layer 7 (EnemyHurtbox)
2. **HurtboxComponent**: Already emits `damage_received` signal
3. **ObjectPool**: Not used for enemies in MVP (direct instantiate/queue_free)

## File Changes

### New Files
- `assets/sprites/enemies/basic/` - Folder for enemy spritesheets
- `scenes/enemies/enemy_base.tscn` - Enemy scene
- `scripts/enemies/enemy_base.gd` - Enemy AI script
- `resources/enemy_frames.tres` - SpriteFrames resource

### No Modified Files Required
- HurtboxComponent already exists and works for both player and enemies
- Arrow already detects EnemyHurtbox layer

## Testing Strategy

1. **Spawn Test**: Place enemy in forest_01 scene, verify it appears
2. **Follow Test**: Verify enemy moves toward player
3. **Damage Test**: Shoot enemy with arrows, verify health decreases
4. **Death Test**: Kill enemy, verify it despawns
5. **Collision Test**: Verify enemy doesn't walk through walls
6. **Sprite Flip Test**: Verify sprite flips based on movement direction
