# Game Project Context

## Game Overview
- **Title**: Project Kasuari (Working Title)
- **Genre**: Top-Down Action / Twin-Stick Shooter
- **Target Platform**: PC (Windows/Mac)
- **Art Style**: HD-2D (2D Pixel Art Sprites dalam lingkungan 3D Modular)
- **Target Audience**: Fans of action games, twin-stick shooters
- **Theme**: Papua folklore, legenda burung Kasuari

## Tech Stack
- **Engine**: Godot 4.6
- **Language**: GDScript
- **Render Engine**: Forward+
- **3D Assets**: Kenney Nature Kit (CC0)
- **Version Control**: Git

## Game Design Pillars
1. **Fast-paced Action**: Quick, responsive combat with satisfying feedback
2. **Mystical Atmosphere**: Hutan Papua yang rimbun dengan pencahayaan magis
3. **Visual Excellence**: HD-2D aesthetic dengan DoF, SSAO, dan shadows

## Core Mechanics
- **Movement**: WASD movement di 3D space (X dan Z axis)
- **Aiming**: Mouse cursor targeting (crosshair 2D to 3D via raycast)
- **Shooting**: Klik Kiri - menembak lurus ke arah kursor
- **Dashing**: Spasi - dash cepat dengan i-frames

## Visual Atmosphere
- Jamur bercahaya (bioluminescent)
- God rays menembus kanopi
- Partikel ambient (debu, serbuk bunga)

## Project Conventions

### Code Style (GDScript)
```gdscript
# Class naming: PascalCase
class_name PlayerController extends CharacterBody2D

# Functions: snake_case
func take_damage(amount: int) -> void:
    pass

# Variables: snake_case
var movement_speed: float = 200.0

# Exports: PascalCase for visibility in editor
@export var MaxHealth: int = 100
@export_range(0.1, 2.0) var DashCooldown: float = 0.5

# Constants: SCREAMING_SNAKE_CASE
const DEFAULT_SPEED := 200.0
const MAX_BULLETS := 50

# Signals: snake_case, descriptive
signal health_changed(new_health: int)
signal player_died()
signal weapon_changed(weapon: WeaponResource)

# Type hints always used
var current_weapon: WeaponResource
var enemies_in_range: Array[Node2D] = []
```

### Folder Structure
```
res://
├── scenes/
│   ├── player/
│   │   └── player.tscn          # CharacterBody3D + Sprite3D
│   ├── enemies/
│   │   └── enemy_base.tscn
│   ├── effects/
│   │   ├── bullet.tscn
│   │   ├── dash_effect.tscn
│   │   └── hit_effect.tscn
│   ├── ui/
│   │   ├── hud.tscn
│   │   └── crosshair.tscn
│   └── levels/
│       └── forest_01.tscn       # GridMap level
├── scripts/
│   ├── autoload/
│   │   ├── game.gd          # Game state manager
│   │   ├── events.gd        # Global event bus
│   │   └── object_pool.gd   # Bullet pooling
│   ├── player/
│   │   ├── player_controller.gd
│   │   ├── player_combat.gd
│   │   └── player_dash.gd
│   ├── enemies/
│   │   ├── enemy_base.gd
│   │   └── enemy_spawner.gd
│   └── utils/
│       └── math_utils.gd
├── assets/
│   ├── 3d/
│   │   └── kenney_nature_kit/   # Nature 3D assets
│   ├── sprites/
│   │   ├── player/              # 2D sprites (facing right)
│   │   └── enemies/
│   ├── audio/
│   │   ├── sfx/
│   │   └── music/
│   └── shaders/
└── resources/
    └── weapons/
```

### Node Naming
- PascalCase for all node names
- Descriptive names: `EnemySpawner` not `Node2D`
- Group related: `PlayerSprite`, `PlayerCollision`, `PlayerHitbox`
- Component suffix: `HealthComponent`, `MovementComponent`

### Signal Conventions
```gdscript
# Global events (autoload Events.gd)
signal enemy_spawned(enemy: Node2D)
signal enemy_killed(enemy: Node2D, position: Vector2)
signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal score_changed(new_score: int)

# Local signals (on owning node)
signal health_depleted()
signal damage_taken(amount: int)
```

### Architecture Patterns

**1. Player Node Structure (HD-2D)**
```gdscript
# Player scene composition
Player (CharacterBody3D)
├── Sprite3D (Y-Billboard mode)
├── CollisionShape3D
├── RayCast3D (mouse targeting)
├── GunMarker3D (bullet spawn point)
├── HitboxComponent (Area3D)
└── HurtboxComponent (Area3D)
```

**2. Enemy Node Structure**
```gdscript
Enemy (CharacterBody3D)
├── Sprite3D (Y-Billboard mode)
├── CollisionShape3D
├── HitboxComponent
├── HurtboxComponent
├── AIComponent
└── HealthComponent
```

**3. Autoload Singletons**
- `Game`: Game state, score, wave management
- `Events`: Global signal bus for decoupled communication
- `ObjectPool`: Bullet and effect pooling (3D)

**4. State Machine (for Player/Enemy states)**
```gdscript
enum State { IDLE, MOVE, DASH, ATTACK, HURT, DEAD }
var current_state: State = State.IDLE

func change_state(new_state: State) -> void:
    if current_state == new_state:
        return
    _exit_state(current_state)
    current_state = new_state
    _enter_state(new_state)
```

### Performance Guidelines
- **Object Pooling**: Required for bullets, particles, enemies
- **Limit _process()**: Use timers for periodic checks
- **Layer management**: Use physics layers efficiently
- **Visible culling**: Disable processing off-screen
- **Batch operations**: Group similar updates

### Testing Strategy
- Playtest each feature for "feel"
- Profile during intense action (many enemies/bullets)
- Test edge cases (0 health, max bullets, etc.)
- Verify wave transitions

## Game Systems

| System | Description | Status |
|--------|-------------|--------|
| Player Movement | WASD di 3D space (X/Z axis) | Pending |
| Mouse Aiming | Raycast targeting, crosshair | Pending |
| Player Combat | Shooting ke arah cursor | Pending |
| Player Dash | Spasi dash dengan i-frames | Pending |
| Health System | HP, damage, death, invuln frames | Pending |
| Enemy AI | Basic follow player | Pending |
| Enemy Spawning | Wave-based | Pending |
| UI/HUD | HP bar, crosshair | Pending |
| Object Pooling | Bullets, effects (3D) | Pending |
| Level/Environment | GridMap dengan Kenney assets | Pending |
| Post-Processing | DoF, SSAO, shadows, bloom | Pending |

## Important Constraints
- Target: 60 FPS with 50+ enemies on screen
- Memory: < 500MB RAM
- Input: Keyboard + Mouse (gamepad later)
- Resolution: 1920x1080 base, scalable

## External Dependencies
- None currently (may add plugins later)

## Definition of Done
- [ ] Feature matches spec requirements
- [ ] Code follows project conventions
- [ ] No console errors or warnings
- [ ] Playtested for game feel
- [ ] Performance acceptable (60 FPS)
- [ ] Visual/audio feedback present
- [ ] Connected to existing systems
