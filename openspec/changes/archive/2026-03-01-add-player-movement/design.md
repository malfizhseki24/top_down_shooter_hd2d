## Game Design Context

Phase 1.3 dari GDD Production Pipeline - Player Movement System. Ini adalah tahap implementasi movement logic setelah scene structure selesai di Phase 1.2.

## Design Goals

**Core Experience:**
Player dapat bergerak dengan smooth menggunakan WASD di arena top-down.

**Goals:**
- Responsive 8-directional movement
- Smooth collision-based movement
- Tunable movement speed untuk balancing
- Clean, minimal code structure

**Non-Goals:**
- Mouse aiming (Phase 1.4)
- Dash mechanic (Phase 3.5)
- Animation integration (later phase)

## Technical Design

### Script Architecture

```gdscript
# scripts/player/player_controller.gd
extends CharacterBody3D

@export var movement_speed: float = 5.0

func _physics_process(delta: float) -> void:
    # Read input
    var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

    # Convert to 3D direction (X-Z plane)
    var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

    # Apply velocity
    velocity.x = direction.x * movement_speed
    velocity.z = direction.z * movement_speed

    # Move with collision
    move_and_slide()
```

### Input Map (Already Configured in Phase 1.1)
```
move_up    : W
move_down  : S
move_left  : A
move_right : D
```

### Component Details

**CharacterBody3D (Player)**
- Script: `player_controller.gd`
- Uses default CharacterBody3D physics

**Movement Speed**
- Default: 5.0 units/second
- Adjustable via Inspector
- Can be modified during gameplay for speed powerups (future)

### Movement Flow

```
Input (WASD) → get_vector() → direction (Vector2)
                                    ↓
                     Vector3(direction.x, 0, direction.y)
                                    ↓
                     velocity = direction * speed
                                    ↓
                            move_and_slide()
```

### Coordinate System

**Top-Down View (X-Z Plane):**
- X-axis: Left/Right movement
- Z-axis: Forward/Backward movement
- Y-axis: Up/Down (not used for movement, player stays on ground)

**Input Mapping:**
- W (move_up) → -Z direction (forward in top-down)
- S (move_down) → +Z direction (backward)
- A (move_left) → -X direction
- D (move_right) → +X direction

## Implementation Notes

### CharacterBody3D Template

Godot 4 menggunakan template berbeda dari Godot 3. Tidak ada `is_on_floor()` check untuk top-down movement karena player tidak perlu gravity.

### Normalization

Direction vector di-normalize untuk memastikan diagonal movement tidak lebih cepat dari cardinal movement:
- Cardinal: speed × 1.0 = speed
- Diagonal (without normalize): speed × 1.414 = 1.4x faster
- Diagonal (with normalize): speed × 1.0 = speed

### Why move_and_slide()?

- Handles collision automatically
- Slides along walls instead of stopping
- Industry standard for character movement

## Risks / Trade-offs

| Risk | Impact | Mitigation |
|------|--------|------------|
| Input lag | Medium | Use _physics_process, not _process |
| Collision issues | Low | Test dengan environment |
| Speed balancing | Low | @export var untuk easy tuning |

## Open Questions

- [x] Gravity diperlukan? → Tidak, top-down movement tanpa gravity
- [x] Acceleration/deceleration? → MVP menggunakan instant velocity, bisa di-refine nanti
- [x] Animation switching? → Phase selanjutnya

## References

- GDD Section 6 - Phase 1.3 Player Movement System
- Godot 4 Docs - CharacterBody3D
- Godot 4 Docs - Input.get_vector()
