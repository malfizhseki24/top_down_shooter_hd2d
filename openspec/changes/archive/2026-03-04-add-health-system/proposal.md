# Proposal: Add Health System

**Engine**: Godot 4.x (tested with Godot 4.6)

## Why

Implements GDD Phase 3.4 - Health System. Currently, health logic is duplicated inline in `enemy_base.gd`, making it impossible to reuse for the player and violating the component-based architecture. A reusable HealthComponent is required to:
- Enable the player to take damage and die
- Standardize health management across all entities (player, enemies, future NPCs)
- Decouple health logic from entity scripts
- Support invulnerability frames (i-frames) during dash
- Enable UI systems to display health bars via signals

## What Changes

- Create `scripts/components/health_component.gd` - Reusable health management component
- Create `scenes/components/health_component.tscn` - Component scene for drag-and-drop
- Refactor `enemy_base.gd` to use HealthComponent instead of inline health logic
- Add HealthComponent to player scene (`scenes/player/player.tscn`)
- Connect HurtboxComponent to HealthComponent via signals
- Emit `health_changed` and `died` signals for UI and game state integration

## Gameplay Impact

- **Player Mortality**: Player can now take damage and die, adding stakes to combat
- **Consistent Damage**: All entities use the same health system, ensuring predictable behavior
- **I-Frames Support**: HealthComponent can be temporarily disabled during dash or damage cooldown
- **UI Integration**: Signals enable HP bars and death screens to update reactively
- **Game Balance**: Configurable max_health allows per-entity tuning

## Scope

### In Scope

1. HealthComponent script with configurable max_health
2. `take_damage(amount)` function that reduces health
3. `health_changed(new_health: int, old_health: int)` signal
4. `died()` signal emitted when health reaches 0
5. Integration with HurtboxComponent's `damage_received` signal
6. Add HealthComponent to player scene
7. Refactor enemy_base.gd to use HealthComponent
8. Support for invulnerability state (can be toggled)
9. `heal(amount)` function for future health pickups

### Out of Scope

- Health regeneration over time (future feature)
- Health pickups (Phase 4)
- UI health bars (Phase 4.4 - HUD & UI)
- Death screen UI (Phase 4.5 - Game Loop Polish)
- Damage resistance/armor system
- Visual feedback for damage (Phase 4 - Polish & Juice)

## Technical Considerations

- HealthComponent should be a plain Node (not Area3D), attached as child to entity
- Entity scripts connect HurtboxComponent.damage_received to HealthComponent.take_damage
- HealthComponent stores current_health internally, initialized from max_health
- Prevent health from going below 0 (clamp to 0)
- Prevent healing above max_health (clamp to max_health)
- Emit signals even when health doesn't change (for UI feedback attempts)
- died() signal should only emit once per entity lifetime

## Dependencies

- Existing HurtboxComponent (`scenes/components/hurtbox_component.tscn`)
- Existing collision system (player hurtbox on Layer 6, enemy hurtbox on Layer 7)
- Player scene exists (`scenes/player/player.tscn`)
- Enemy scene exists (`scenes/enemies/enemy_base.tscn`)

## Migration Path

### Current State (Inline Health in Enemy)
```gdscript
# enemy_base.gd
var _current_health: int

func _ready():
    _current_health = max_health

func _on_hurtbox_damage_received(hitbox):
    _current_health -= hitbox.damage
    if _current_health <= 0:
        died.emit()
        queue_free()
```

### Future State (Component-Based Health)
```gdscript
# enemy_base.gd
@onready var health: HealthComponent = $HealthComponent

func _ready():
    health.died.connect(_on_died)

func _on_hurtbox_damage_received(hitbox):
    health.take_damage(hitbox.damage)

func _on_died():
    queue_free()
```

## Risks

- **Breaking Change**: Enemy health logic must be migrated carefully to avoid bugs
- **Signal Chains**: Multiple signal connections (hurtbox → health → entity) add complexity
- **Over-Engineering**: Keep component simple; don't add regeneration/resistance yet
- **Player Death**: Need to handle player death gracefully (respawn/game over) in future phases

## Acceptance Criteria

- [ ] HealthComponent exists and can be attached to any entity
- [ ] Player has HealthComponent and can take damage
- [ ] Enemy uses HealthComponent (refactored from inline health)
- [ ] health_changed signal fires on damage/heal
- [ ] died signal fires when health reaches 0
- [ ] Health clamps to [0, max_health] range
- [ ] No regression in enemy combat behavior
