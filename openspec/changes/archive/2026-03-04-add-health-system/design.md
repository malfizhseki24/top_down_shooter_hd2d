# Design: Health System

**Engine**: Godot 4.x (tested with Godot 4.6)

## Architecture Overview

The Health System introduces a reusable HealthComponent that follows the component-based architecture pattern used by HitboxComponent and HurtboxComponent.

```
┌─────────────────────────────────────────┐
│         Entity (Player/Enemy)           │
│  CharacterBody3D or other base node     │
├─────────────────────────────────────────┤
│  ┌──────────────────┐  ┌─────────────┐ │
│  │ HurtboxComponent │  │ HealthComp  │ │
│  │  (Area3D)        │  │  (Node)     │ │
│  │                  │  │             │ │
│  │ damage_received ─┼──► take_damage │ │
│  │     signal       │  │   method    │ │
│  └──────────────────┘  │             │ │
│                        │ health_     │ │
│                        │ changed ────┼─┼──► UI Health Bar
│                        │ died ───────┼─┼──► Game State
│                        └─────────────┘ │
└─────────────────────────────────────────┘
```

## Component Design

### HealthComponent Node Type

**Decision**: Use plain `Node` as base type (not Area3D or Node3D)

**Rationale**:
- Health is pure data/logic, no spatial presence needed
- Lighter weight than Node3D (no transform data)
- Consistent with component pattern (logic-only nodes)
- Easy to attach to any entity type (CharacterBody3D, RigidBody3D, etc.)

### Signal Flow

```
HitboxComponent.area_entered
    ↓
HurtboxComponent.receive_damage()
    ↓
HurtboxComponent.damage_received signal
    ↓
Entity._on_hurtbox_damage_received()
    ↓
HealthComponent.take_damage()
    ↓
HealthComponent.health_changed signal  →  UI/Effects
HealthComponent.died signal            →  Entity/GamState
```

**Why not connect HurtboxComponent directly to HealthComponent?**

The entity acts as a mediator to:
1. Control which health component to use (in case of multiple)
2. Add entity-specific logic (death handling, sound effects)
3. Keep components decoupled and reusable

However, for MVP simplicity, we allow direct connection:
```gdscript
# Simple approach (MVP)
hurtbox.damage_received.connect(health.take_damage)

# Mediated approach (future)
hurtbox.damage_received.connect(_on_damage_received)
func _on_damage_received(hitbox):
    health.take_damage(hitbox.damage)
    # Additional logic here
```

### Health Clamping

Health must always stay within valid bounds:
- Minimum: 0 (dead)
- Maximum: max_health (full health)

```gdscript
func take_damage(amount: int) -> void:
    var old_health := _current_health
    _current_health = clamp(_current_health - amount, 0, max_health)

    if old_health != _current_health:
        health_changed.emit(_current_health, old_health)

    if _current_health == 0 and old_health > 0:
        died.emit()
```

### Invulnerability Support

For i-frames during dash or damage cooldown:

```gdscript
var is_invulnerable: bool = false

func take_damage(amount: int) -> void:
    if is_invulnerable:
        return
    # ... rest of damage logic
```

This allows:
```gdscript
# During dash
health.is_invulnerable = true
# After dash
health.is_invulnerable = false
```

**Note**: For MVP, this is optional. The primary i-frames mechanism is disabling hurtbox monitoring (already implemented in player dash).

## Entity Integration

### Player Integration

```gdscript
# Player scene structure
Player (CharacterBody3D)
├── Sprite3D
├── CollisionShape3D
├── GunMarker3D
├── HurtboxComponent (Layer 6)
└── HealthComponent

# PlayerController.gd
@onready var health: HealthComponent = $HealthComponent

func _ready():
    health.died.connect(_on_player_died)
    hurtbox.damage_received.connect(_on_damage_received)

func _on_damage_received(hitbox: HitboxComponent):
    health.take_damage(hitbox.damage)

func _on_player_died():
    # Trigger game over, respawn, etc.
    Events.player_died.emit()
```

### Enemy Integration (Refactor)

```gdscript
# EnemyBase.gd - BEFORE (inline health)
var _current_health: int

func _ready():
    _current_health = max_health

func _on_hurtbox_damage_received(hitbox):
    _current_health -= hitbox.damage
    if _current_health <= 0:
        died.emit()
        queue_free()

# EnemyBase.gd - AFTER (component-based)
@export var max_health: int = 3  # Configure HealthComponent

@onready var health: HealthComponent = $HealthComponent

func _ready():
    health.max_health = max_health  # Sync config
    health.died.connect(_on_died)

func _on_hurtbox_damage_received(hitbox: HitboxComponent):
    health.take_damage(hitbox.damage)

func _on_died():
    died.emit()
    queue_free()
```

## API Reference

### Exposed Properties

```gdscript
@export var max_health: int = 3  # Configurable in Inspector
var is_invulnerable: bool = false  # Runtime toggle
```

### Public Methods

```gdscript
func take_damage(amount: int) -> void
func heal(amount: int) -> void
func get_health_percent() -> float  # Returns 0.0 to 1.0
```

### Signals

```gdscript
signal health_changed(new_health: int, old_health: int)
signal died()
```

## Testing Strategy

### Unit Test Scenarios

1. **Damage reduces health**: take_damage(1) on health 3 → health 2
2. **Health clamps to 0**: take_damage(10) on health 3 → health 0, died emitted
3. **Health clamps to max**: heal(10) on health 2 → health 3 (not 12)
4. **Invulnerability blocks damage**: is_invulnerable=true, take_damage(1) → no change
5. **Signals fire correctly**: health_changed emits on damage, died emits at 0

### Integration Test Scenarios

1. **Player takes damage**: Arrow hits player → health decreases
2. **Enemy takes damage**: Arrow hits enemy → health decreases
3. **Enemy dies**: Health reaches 0 → queue_free() called
4. **Player dies**: Health reaches 0 → died signal → game state

## Future Extensions (Out of Scope for MVP)

- **Health Regeneration**: `heal_per_second` property with timer
- **Damage Resistance**: `damage_multiplier` property (0.5 = half damage)
- **Armor/Shields**: Secondary health pool
- **Damage Types**: Fire, ice, physical resistances
- **Overheal**: Allow health > max_health temporarily
- **Health Bar Component**: Visual component that auto-connects to HealthComponent

## Performance Considerations

- HealthComponent is lightweight (single Node, no physics)
- Signal overhead is minimal (only on damage, not every frame)
- No _process() or _physics_process() needed
- Health state is just 2 integers (current_health, max_health)

## Alternatives Considered

### Alternative 1: Health as Resource (ResourceLoader)

**Pros**: Can share health configurations across entities
**Cons**: Over-engineering for MVP, signals are harder to manage
**Decision**: Rejected - use direct node for simplicity

### Alternative 2: Inline Health (Current State)

**Pros**: Simple, no extra nodes
**Cons**: Code duplication, hard to maintain, no reusability
**Decision**: Rejected - violates component architecture

### Alternative 3: Health as Autoload Singleton

**Pros**: Global health registry
**Cons**: Tight coupling, not scalable, hard to manage per-entity health
**Decision**: Rejected - component pattern is better

## Implementation Order

1. Create `health_component.gd` script with core logic
2. Create `health_component.tscn` scene
3. Add HealthComponent to enemy, refactor enemy_base.gd
4. Test enemy health in combat
5. Add HealthComponent to player scene
6. Connect player hurtbox to health
7. Test player taking damage
8. Validate all acceptance criteria
