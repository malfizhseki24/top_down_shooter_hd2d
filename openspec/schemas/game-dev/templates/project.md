# Game Project Context

## Game Overview
- **Title**: [Game Title]
- **Genre**: [e.g., Top-Down Shooter, RPG, Platformer]
- **Target Platform**: [e.g., PC, Mobile, Console, Web]
- **Art Style**: [e.g., HD-2D, Pixel Art, 3D Stylized]
- **Target Audience**: [e.g., Casual, Hardcore, All Ages]

## Tech Stack
- **Engine**: Godot 4.6
- **Language**: GDScript / C#
- **Render Engine**: Forward+ / Mobile / Compatibility
- **Version Control**: Git

## Game Design Pillars
1. [Core pillar 1 - e.g., "Fast-paced action"]
2. [Core pillar 2 - e.g., "Strategic depth"]
3. [Core pillar 3 - e.g., "Visually stunning"]

## Core Mechanics
- [Mechanic 1]: [Brief description]
- [Mechanic 2]: [Brief description]
- [Mechanic 3]: [Brief description]

## Project Conventions

### Code Style (GDScript)
```gdscript
# Class naming: PascalCase
class_name PlayerController

# Functions: snake_case
func take_damage(amount: int) -> void:
    pass

# Variables: snake_case for locals, PascalCase for exports
var movement_speed: float = 100.0
@export var MaxHealth: int = 100

# Constants: SCREAMING_SNAKE_CASE
const DEFAULT_SPEED := 200.0

# Signals: past_tense or on_ prefix
signal health_changed(new_health: int)
signal on_player_died()
```

### Folder Structure
```
res://
├── scenes/           # .tscn files organized by feature
│   ├── player/
│   ├── enemies/
│   ├── ui/
│   └── levels/
├── scripts/          # .gd files
│   ├── autoload/     # Singletons/Autoloads
│   ├── components/   # Reusable components
│   └── utils/        # Utility functions
├── assets/
│   ├── sprites/
│   ├── audio/
│   ├── fonts/
│   └── shaders/
├── resources/        # .tres files
└── addons/           # Plugins
```

### Node Naming
- Use PascalCase for node names
- Group related nodes with prefixes (e.g., `PlayerSprite`, `PlayerCollision`)
- Use descriptive names: `EnemySpawner` not `Node2D`

### Signal Conventions
- Emit from the owner, connect in parent or via editor
- Pass minimal data needed
- Document expected parameters in comments

### Architecture Patterns
- **Composition over Inheritance**: Use components for reusable behavior
- **Autoloads**: Use for global state (Game, Save, Audio, Events)
- **State Machine**: Use for complex state (Player states, Enemy AI)
- **Observer Pattern**: Use signals for decoupled communication

### Performance Guidelines
- Use object pooling for frequently spawned objects
- Batch similar operations
- Profile before optimizing
- Use `@export` for designer-tunable values
- Avoid `_process()` for infrequent checks - use timers or signals

### Testing Strategy
- Manual playtesting for gameplay feel
- Unit tests for utility functions (GDUnit4)
- Integration tests for systems
- Performance profiling for critical paths

## Game Systems
| System | Description | Status |
|--------|-------------|--------|
| Player | Movement, combat, health | [Status] |
| Enemies | AI, spawning, drops | [Status] |
| Weapons | Shooting, upgrades | [Status] |
| UI | HUD, menus, notifications | [Status] |
| Audio | Music, SFX, ambience | [Status] |
| Save/Load | Progress, settings | [Status] |

## Important Constraints
- Target framerate: [e.g., 60 FPS on minimum specs]
- Memory budget: [e.g., < 500MB RAM]
- Build size target: [e.g., < 100MB]
- Mobile considerations: [Touch controls, battery, etc.]

## External Dependencies
- [Asset libraries, plugins, external tools]

## Definition of Done
- [ ] Feature implemented according to spec
- [ ] Code follows project conventions
- [ ] No console errors or warnings
- [ ] Tested in-editor
- [ ] Playtested for feel
- [ ] Performance acceptable
- [ ] Documented if complex
