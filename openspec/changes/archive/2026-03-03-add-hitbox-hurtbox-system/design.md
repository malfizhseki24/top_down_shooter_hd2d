# Design: Hitbox/Hurtbox Collision System

## Engine Version
**Godot 4.x** (tested with Godot 4.6)

## Overview
This design covers the implementation of a standardized collision system for damage detection and arrow world collision behavior.

## Collision Layer Architecture

Following GDD specification:

| Layer | Name | Purpose | Bit Value |
|-------|------|---------|-----------|
| 1 | World | Static geometry (trees, rocks, walls) | 1 |
| 2 | Player | Player physics body | 2 |
| 3 | Enemy | Enemy physics bodies | 4 |
| 4 | PlayerProjectile | Player bullets/arrows | 8 |
| 5 | EnemyProjectile | Enemy bullets | 16 |
| 6 | PlayerHurtbox | Player damage receiver | 32 |
| 7 | EnemyHurtbox | Enemy damage receiver | 64 |

## Component Design

### HitboxComponent (Area3D)
**Purpose**: Deals damage to hurtboxes

```
HitboxComponent (Area3D)
├── CollisionShape3D
└── Script: hitbox_component.gd
```

**Configuration**:
- `collision_layer`: Depends on owner (4 for player projectile, 16 for enemy projectile)
- `collision_mask`: Match target hurtbox layer (64 for player->enemy, 32 for enemy->player)
- `damage`: int = 1

**Signals**:
- `hit_hurtbox(hurtbox: HurtboxComponent)` - Emitted when hitting a valid target

### HurtboxComponent (Area3D)
**Purpose**: Receives damage from hitboxes

```
HurtboxComponent (Area3D)
├── CollisionShape3D
└── Script: hurtbox_component.gd
```

**Configuration**:
- `collision_layer`: Depends on owner (32 for player, 64 for enemy)
- `collision_mask`: None (hurtboxes don't detect, they are detected)
- `monitoring`: true (default)
- `monitorable`: true (default)

**Signals**:
- `damage_received(hitbox: HitboxComponent)` - Emitted when hit by a hitbox

## Arrow World Collision Design

### Current State
- Arrow is Area3D with:
  - `collision_layer = 8` (Layer 4: PlayerProjectile)
  - `collision_mask = 64` (Layer 7: EnemyHurtbox)

### Proposed Change
Add Layer 1 (World) to arrow's collision_mask to detect static geometry:

- `collision_layer = 8` (unchanged)
- `collision_mask = 65` (Layer 1 + Layer 7 = 1 + 64)

### Behavior on World Collision
When arrow's `body_entered` signal fires with world geometry:
1. Stop arrow movement immediately
2. Optionally play impact effect (future)
3. Return arrow to pool after short delay (or immediately)

### Implementation Approach
```gdscript
# In arrow.gd
func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
    if not _is_active:
        return
    # Arrow hit world geometry - stop and despawn
    _despawn()
```

## Damage Flow Diagram

```
[Player shoots]
      │
      ▼
[Arrow spawns] ──────► collision_layer=8 (PlayerProjectile)
      │
      ▼
[Arrow moves]
      │
      ├─────► Hits EnemyHurtbox (Layer 7) ──► area_entered signal
      │                                           │
      │                                           ▼
      │                                    Arrow._on_area_entered()
      │                                           │
      │                                           ▼
      │                                    Emit damage to enemy
      │                                    Despawn arrow
      │
      └─────► Hits World (Layer 1) ──► body_entered signal
                                                │
                                                ▼
                                         Arrow._on_body_entered()
                                                │
                                                ▼
                                         Stop movement
                                         Despawn arrow
```

## File Changes

### New Files
- `scenes/components/hitbox_component.tscn` - Reusable hitbox scene
- `scripts/components/hitbox_component.gd` - Hitbox behavior
- `scenes/components/hurtbox_component.tscn` - Reusable hurtbox scene
- `scripts/components/hurtbox_component.gd` - Hurtbox behavior

### Modified Files
- `scripts/effects/arrow.gd` - Add world collision detection
- `scenes/effects/arrow.tscn` - Update collision_mask to include Layer 1

## Integration Points

### Future: Player Hurtbox
```
Player (CharacterBody3D)
├── HurtboxComponent
│   └── collision_layer = 32 (PlayerHurtbox)
```

### Future: Enemy Structure
```
Enemy (CharacterBody3D)
├── HurtboxComponent
│   └── collision_layer = 64 (EnemyHurtbox)
├── HealthComponent (Phase 3.4)
└── AI scripts
```

## Testing Strategy

1. **Arrow vs EnemyHurtbox**: Verify area_entered fires when arrow overlaps enemy hurtbox
2. **Arrow vs World**: Verify body_entered fires when arrow hits tree/rock
3. **Arrow vs Player**: Verify arrow does NOT hit player's own hurtbox
4. **Pool Integration**: Verify arrows return to pool correctly after collision
