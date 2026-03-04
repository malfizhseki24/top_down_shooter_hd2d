# Design: Player Dash Mechanic

## Engine Version
**Godot 4.x** (tested with Godot 4.6)

## Overview
Implements a dash mechanic that allows the player to quickly evade in their movement direction while being invulnerable.

## State Machine Design

```
┌─────────┐     Space + cooldown ready     ┌─────────┐
│ NORMAL  │ ─────────────────────────────► │ DASHING │
└─────────┘                                 └─────────┘
     ▲                                           │
     │              dash_timer expired           │
     └───────────────────────────────────────────┘
```

## Animation Analysis

From `player_frames.tres`:
- **Animation**: "dash"
- **Frames**: 8 frames
- **Speed**: 5.0 FPS
- **Duration**: 8 / 5.0 = 1.6 seconds
- **Loop**: true

**Recommendation**: Dash gameplay duration should be ~0.2-0.3s for responsive feel. Animation can continue playing after dash ends, or we stop it early.

## Configuration Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dash_speed` | float | 15.0 | Speed during dash (units/sec) |
| `dash_duration` | float | 0.2 | How long the dash lasts (seconds) |
| `dash_cooldown` | float | 0.5 | Time before next dash available |

## Hurtbox I-Frames

The player already has a Hurtbox Area3D node:
```
Player
└── Hurtbox (Area3D)
    ├── collision_layer = 32 (PlayerHurtbox)
    └── collision_mask = 16 (EnemyProjectile)
```

To enable i-frames during dash:
```gdscript
# Start dash - disable hurtbox
$Hurtbox.set_deferred("monitoring", false)
$Hurtbox.set_deferred("monitorable", false)

# End dash - re-enable hurtbox
$Hurtbox.set_deferred("monitoring", true)
$Hurtbox.set_deferred("monitorable", true)
```

## Dash Direction Logic

1. **Priority 1**: Current movement input direction (WASD)
2. **Priority 2**: Last movement direction
3. **Priority 3**: Facing direction (based on mouse aim / sprite flip)

For simplicity, use facing direction when no movement input:
- `flip_h == false` → dash right (+X)
- `flip_h == true` → dash left (-X)

## Implementation Approach

```gdscript
# State enum
enum State { NORMAL, DASHING }
var current_state: State = State.NORMAL

# Dash parameters
@export var dash_speed: float = 15.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 0.5

# Dash state variables
var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _dash_direction: Vector3 = Vector3.RIGHT

# Node reference
@onready var hurtbox: Area3D = $Hurtbox

func _physics_process(delta: float) -> void:
    # Update cooldown
    if _dash_cooldown_timer > 0:
        _dash_cooldown_timer -= delta

    match current_state:
        State.NORMAL:
            _handle_normal_state(delta)
        State.DASHING:
            _handle_dashing_state(delta)

func _handle_dashing_state(delta: float) -> void:
    # Move in dash direction
    velocity = _dash_direction * dash_speed
    move_and_slide()

    # Update dash timer
    _dash_timer -= delta
    if _dash_timer <= 0:
        _end_dash()

func _start_dash() -> void:
    current_state = State.DASHING
    _dash_timer = dash_duration
    _dash_cooldown_timer = dash_cooldown

    # Determine dash direction
    var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if input_dir != Vector2.ZERO:
        _dash_direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
    else:
        # Use facing direction
        _dash_direction = Vector3.RIGHT if not animated_sprite.flip_h else Vector3.LEFT

    # Enable i-frames
    hurtbox.set_deferred("monitoring", false)
    hurtbox.set_deferred("monitorable", false)

    # Play dash animation
    animated_sprite.play("dash")

func _end_dash() -> void:
    current_state = State.NORMAL

    # Disable i-frames
    hurtbox.set_deferred("monitoring", true)
    hurtbox.set_deferred("monitorable", true)

    # Return to appropriate animation
    var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if input_dir == Vector2.ZERO:
        animated_sprite.play("idle")
    else:
        animated_sprite.play("running")
```

## File Changes

### Modified Files
- `scripts/player/player_controller.gd` - Add dash state machine and logic

### No New Files Required
- Animation already exists in player_frames.tres
- Hurtbox already exists in player.tscn
- Input mapping already configured

## Testing Strategy

1. **Dash Movement**: Verify player moves quickly in expected direction
2. **Dash Cooldown**: Verify cannot spam dash
3. **I-Frames**: Verify player doesn't take damage during dash
4. **Animation**: Verify dash animation plays correctly
5. **Direction**: Verify dash direction when standing still uses facing direction
6. **Direction**: Verify dash direction when moving uses movement direction
