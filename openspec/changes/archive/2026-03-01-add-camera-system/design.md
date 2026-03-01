## Game Design Context

Phase 1.5 dari GDD Production Pipeline - Camera System. Ini adalah tahap implementasi camera yang mengikuti player dengan smooth interpolation untuk top-down view.

## Design Goals

**Core Experience:**
Camera mengikuti player dengan smooth, cinematic feel.

**Goals:**
- Smooth follow dengan lerp interpolation
- Top-down angle yang konsisten
- Tunable smoothing untuk game feel
- Decoupled dari player node (reusable)

**Non-Goals:**
- Camera shake (Phase 4.2)
- Camera zoom (Phase 4.2)
- Multiple camera angles

## Technical Design

### Camera Architecture

**Option A: Camera sebagai child of Player**
- Simple setup
- Camera moves with player automatically
- No smoothing without script

**Option B: Camera sebagai sibling (separate node) - CHOSEN**
- More flexible
- Easier to implement smooth follow
- Reusable across levels

### Script Structure

```gdscript
# scripts/camera/camera_follow.gd
extends Camera3D

@export var target: Node3D
@export var smoothing_speed: float = 5.0
@export var offset: Vector3 = Vector3(0, 8, 6)

func _process(delta: float) -> void:
    if target == null:
        return

    var target_pos := target.global_position + offset
    global_position = global_position.lerp(target_pos, smoothing_speed * delta)
```

### Component Details

**Camera3D Settings:**
- Projection: Perspective (untuk depth feel) atau Orthographic (untuk classic look)
- Position: Offset dari player (tinggi + belakang)
- Rotation: Menghadap ke bawah (top-down)

**Offset Calculation:**
```
Offset = (0, 8, 6) berarti:
- Y = 8 units di atas player
- Z = 6 units di belakang player
- X = 0 (centered)

Dengan rotation -45 degree X, camera menghadap ke player dari atas.
```

**Smoothing:**
- `lerp(current, target, weight)` - weight = speed * delta
- Higher speed = faster follow (less lag)
- Lower speed = slower follow (more cinematic)

### Implementation Notes

### Why _process instead of _physics_process?

- Camera should update every frame for smooth visuals
- Player physics update in _physics_process (fixed timestep)
- Decoupling prevents jitter

### Lerp Formula

```gdscript
# Smooth interpolation
global_position = global_position.lerp(target_pos, smoothing_speed * delta)

# Equivalent to:
global_position = global_position + (target_pos - global_position) * smoothing_speed * delta
```

## Risks / Trade-offs

| Risk | Impact | Mitigation |
|------|--------|------------|
| Camera lag terlalu besar | Medium | Default smoothing 5.0, adjustable |
| Offset tidak match level | Low | Export offset variable |
| Rotation perlu adjustment | Low | Set di editor, script hanya follow position |

## Open Questions

- [x] Camera sebagai child atau sibling? → Sibling, lebih fleksibel
- [x] Perspective atau Orthographic? → Orthographic untuk classic top-down look
- [x] Rotation di script atau editor? → Editor, lebih mudah visualize

## References

- GDD Section 6 - Phase 1.5 Camera System
- Godot 4 Docs - Camera3D
