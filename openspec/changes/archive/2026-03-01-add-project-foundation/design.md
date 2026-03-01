## Game Design Context

Phase 1.1 dari production pipeline - Setup fondasi project sebelum development gameplay dimulai. Ini adalah "invisible work" yang critical untuk maintainability jangka panjang.

## Design Goals

**Core Experience:**
Developer experience yang smooth dengan struktur yang jelas dan tools yang siap pakai.

**Goals:**
- Struktur folder yang mudah navigasi
- Autoloads yang siap digunakan untuk global state
- Input system yang siap digunakan untuk gameplay
- Rendering yang optimal untuk HD-2D

**Non-Goals:**
- Gameplay implementation (Phase 1.2+)
- UI/UX (Phase 1.6+)
- Art assets (Phase 2+)

## Technical Design

### Folder Architecture
```
res://
├── scenes/
│   ├── player/           # Player-related scenes
│   ├── enemies/          # Enemy scenes
│   ├── effects/          # VFX scenes (particles, etc)
│   ├── ui/               # UI scenes
│   └── levels/           # Level scenes
├── scripts/
│   ├── autoload/         # Global singletons
│   ├── player/           # Player scripts
│   ├── enemies/          # Enemy scripts
│   └── utils/            # Utility functions
├── assets/
│   ├── 3d/               # 3D models (Kenney Nature Kit)
│   ├── sprites/          # 2D sprites
│   ├── audio/            # SFX and music
│   └── shaders/          # Shader files
└── resources/            # .tres resource files
```

### Autoload Design

**Game.gd - State Manager**
```gdscript
extends Node

enum State { MENU, PLAYING, PAUSED, GAME_OVER }
var current_state: State = State.MENU
var score: int = 0
var wave: int = 1

signal state_changed(new_state: State)
signal score_changed(new_score: int)

func change_state(new_state: State) -> void:
    if current_state == new_state:
        return
    current_state = new_state
    state_changed.emit(new_state)

func add_score(amount: int) -> void:
    score += amount
    score_changed.emit(score)

func reset_game() -> void:
    score = 0
    wave = 1
    current_state = State.MENU
```

**Events.gd - Global Event Bus**
```gdscript
extends Node

# Enemy events
signal enemy_spawned(enemy: Node)
signal enemy_killed(enemy: Node, position: Vector3)

# Player events
signal player_damaged(amount: int)
signal player_died()

# Game events
signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal score_changed(new_score: int)
```

### Input Map Configuration

| Action | Key/Mouse | Description |
|--------|-----------|-------------|
| `move_up` | W | Move player forward (north) |
| `move_down` | S | Move player backward (south) |
| `move_left` | A | Move player left (west) |
| `move_right` | D | Move player right (east) |
| `dash` | Space | Quick dodge with i-frames |
| `shoot` | Mouse Left | Fire projectile |

### Project Settings

**Rendering:**
- Method: Forward+
- Anti-Aliasing: MSAA 4x (optional)
- Shadow Atlas: 2048

**Display:**
- Window Size: 1920x1080
- Stretch Mode: canvas_items
- Stretch Aspect: keep

**Physics:**
- Ticks per second: 60
- Physics Jitter Fix: 0.5

## Implementation Notes

### .gdignore
File kosong bernama `.gdignore` di folder `assets/` mencegah Godot mem-scan folder tersebut untuk script. Ini mempercepat project scan dan mencegah false positives.

### Autoload Registration
Di Project Settings > Autoload:
1. Add `scripts/autoload/game.gd` → Name: `Game`
2. Add `scripts/autoload/events.gd` → Name: `Events`

### Input Map
Di Project Settings > Input Map:
1. Add each action name
2. Add corresponding key/mouse binding
3. Test dengan `Input.is_action_pressed()` di _process()

## Risks / Trade-offs

| Risk | Impact | Mitigation |
|------|--------|------------|
| Struktur berubah saat development | Medium | Stick to GDD, update docs jika perlu |
| Terlalu banyak autoloads | Low | Hanya buat yang benar-benar global |
| Input mapping tidak ergonomic | Low | Playtest dan iterate |

## Open Questions

- [x] Apakah perlu autoload untuk Audio? → Defer ke Phase 4
- [x] Apakah perlu autoload untuk ObjectPool? → Defer ke Phase 3

## References

- Godot 4 Best Practices - Project Organization
- GDD Section 6 - Production Pipeline Phase 1.1
