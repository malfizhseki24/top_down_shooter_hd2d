# Design: add-shooting-mechanics

## Overview

This document describes the architectural design for the shooting mechanics system, following the HD-2D twin-stick shooter pattern established in the project.

## Arrow Node Structure

```
Arrow (Area3D)
├── Sprite3D (Y-Billboard mode)
└── CollisionShape3D (SphereShape3D, small radius)
```

### Arrow Sizing (relative to Player)

| Dimension | Arrow | Player | Ratio |
|-----------|-------|--------|-------|
| Length/Height | ~0.4 units | 0.6 units | ~67% |
| Width | ~0.08 units | 0.34 units | ~24% |

The arrow should appear as a slender projectile, roughly 2/3 the player's height but much narrower.

### Design Decisions

| Decision | Rationale |
|----------|-----------|
| **Area3D root** | Arrows need to detect overlaps with enemies (hurtboxes) without physics blocking. Area3D provides `body_entered` and `area_entered` signals. |
| **Sprite3D Y-Billboard** | Matches the HD-2D aesthetic used for player/enemies. Sprite always faces camera. |
| **SphereShape3D** | Simple spherical collision for projectile hit detection. Small radius (0.1-0.2 units) for precise hits. |
| **No RigidBody3D** | Arrows don't need physics simulation; they move in straight lines via script. |

## Collision Layer Configuration

Following GDD collision layer setup:

| Layer | Name | Usage |
|-------|------|-------|
| 4 | Player Bullet (Hitbox) | Player-fired projectiles |
| 7 | Enemy Hurtbox | Enemies receive damage |

Bullet collision settings:
- `collision_layer = 16` (Layer 4 = 2^4 = 16, binary: 10000)
- `collision_mask = 64` (Layer 7 = 2^7 = 128... wait, let me recalculate)

Actually, Godot layers are 1-indexed in the UI but 0-indexed in code:
- Layer 1 (bit 0): World
- Layer 2 (bit 1): Player
- Layer 3 (bit 2): Enemy
- Layer 4 (bit 3): Player Bullet → `collision_layer = 8` (2^3)
- Layer 7 (bit 6): Enemy Hurtbox → `collision_mask = 64` (2^6)

## Direction Calculation

The arrow direction is calculated when spawning:

```gdscript
# In player_combat.gd
func _shoot() -> void:
    var arrow := arrow_scene.instantiate()
    get_tree().current_scene.add_child(arrow)

    arrow.global_position = gun_marker.global_position

    var target_pos := _get_mouse_world_position()  # From parent class
    var direction := (target_pos - arrow.global_position).normalized()
    direction.y = 0  # Keep on X-Z plane

    arrow.set_direction(direction)
```

## Arrow Movement Pattern

```gdscript
# In arrow.gd
extends Area3D
class_name Arrow

@export var speed: float = 15.0
@export var lifetime: float = 3.0

var _direction: Vector3 = Vector3.FORWARD
var _lifetime_timer: float = 0.0

func _physics_process(delta: float) -> void:
    position += _direction * speed * delta

    _lifetime_timer += delta
    if _lifetime_timer >= lifetime:
        queue_free()

func set_direction(dir: Vector3) -> void:
    _direction = dir.normalized()
```

## Input Handling Strategy

Two options considered:

### Option A: `_input(event)` (Recommended)
- Catches all input events
- Good for action games where shooting should be responsive
- Button pressed = one bullet (semi-auto behavior by default)

### Option B: `_unhandled_input(event)`
- Only catches events not consumed by UI
- Better if we have UI buttons that should consume clicks

**Decision**: Use `_input(event)` for now. The crosshair UI doesn't consume clicks (it's just a visual). Can migrate to `_unhandled_input` if needed later.

## Scene Instantiation Pattern

For MVP (pre-object-pooling), we use direct instantiation:

```gdscript
var arrow_scene: PackedScene = preload("res://scenes/effects/arrow.tscn")

func _shoot() -> void:
    var arrow := arrow_scene.instantiate()
    get_tree().current_scene.add_child(arrow)
    # ... setup arrow
```

**Trade-off**: Simple but allocates memory per shot. Phase 3.2 will replace this with object pooling.

## Integration with Existing Systems

### Player Scene
- Uses existing `GunMarker` node for spawn position
- May extend or compose with `player_controller.gd`

### Mouse Aiming
- Reuses `_get_mouse_world_position()` logic
- Direction calculated from GunMarker to mouse world position

### Camera System
- No changes required
- Bullets are independent 3D objects

## File Locations

```
scenes/
└── effects/
    └── arrow.tscn           # Arrow scene

scripts/
└── effects/
    └── arrow.gd             # Arrow movement script
└── player/
    └── player_combat.gd     # Shooting logic (extends or composed)
```

## Performance Considerations

For MVP:
- Limit rapid-fire via cooldown timer (0.15-0.2 seconds between shots)
- Arrow lifetime of 3 seconds prevents accumulation
- `queue_free()` handles cleanup

Post-MVP (Phase 3.2):
- Object pooling eliminates instantiation overhead
- Pre-allocated arrow pool (50-100 arrows)
