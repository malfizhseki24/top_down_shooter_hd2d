## Game Design Context

Phase 1.4 dari GDD Production Pipeline - Mouse Aiming System. Ini adalah tahap implementasi aiming logic untuk twin-stick shooter mechanic.

## Design Goals

**Core Experience:**
Player sprite selalu menghadap ke arah mouse cursor, terlepas dari direction of movement.

**Goals:**
- Mouse position di-convert dari screen space ke world space
- Sprite flip berdasarkan posisi mouse (kiri/kanan player)
- Decoupled dari movement - player bisa move ke satu arah sambil aim ke arah lain

**Non-Goals:**
- Shooting mechanic (Phase 3.1)
- Crosshair UI (Phase 1.6)
- Camera follow (Phase 1.5)

## Technical Design

### Mouse to World Position

```gdscript
func _get_mouse_world_position() -> Vector3:
    var camera := get_viewport().get_camera_3d()
    var mouse_pos := get_viewport().get_mouse_position()
    var ray_origin := camera.project_ray_origin(mouse_pos)
    var ray_dir := camera.project_ray_normal(mouse_pos)

    # Intersect with Y=0 plane (floor)
    var plane := Plane(Vector3.UP, 0)
    return plane.intersects_ray(ray_origin, ray_dir)
```

### Aim Direction Calculation

```gdscript
func _get_aim_direction() -> Vector3:
    var mouse_world_pos := _get_mouse_world_position()
    if mouse_world_pos == null:
        return Vector3.ZERO

    var aim_dir := (mouse_world_pos - global_position).normalized()
    aim_dir.y = 0  # Keep on X-Z plane
    return aim_dir
```

### Sprite Flip Logic

**Current (Movement-based):**
```gdscript
if direction.x < 0:
    animated_sprite.flip_h = true
elif direction.x > 0:
    animated_sprite.flip_h = false
```

**New (Aim-based):**
```gdscript
var aim_dir := _get_aim_direction()
if aim_dir.x < 0:
    animated_sprite.flip_h = true
elif aim_dir.x > 0:
    animated_sprite.flip_h = false
```

### Component Details

**Camera3D Requirements:**
- Must be in scene (already in test_player.tscn)
- project_ray_origin() returns ray starting point
- project_ray_normal() returns ray direction

**Plane Intersection:**
- Plane(Vector3.UP, 0) = Y=0 plane (ground)
- intersects_ray() returns intersection point or null

**Edge Cases:**
- Mouse outside viewport: clamp to viewport bounds
- Ray parallel to plane: returns null (handle gracefully)

## Implementation Notes

### Why Plane Instead of RayCast3D?

**Option A: RayCast3D Node**
- Requires physics body to collide with
- More setup (collision layers)
- Good for complex geometry

**Option B: Plane Intersection (Chosen)**
- Simple math, no physics needed
- Works with flat ground (Y=0)
- More performant
- Sufficient for top-down shooter

### Coordinate System Reminder

```
Top-Down View:
         -Z (forward/up on screen)
          |
    -X ---+--- +X (right)
          |
         +Z (backward/down on screen)

Mouse to the LEFT of player  → aim_dir.x < 0 → flip_h = true
Mouse to the RIGHT of player → aim_dir.x > 0 → flip_h = false
```

## Risks / Trade-offs

| Risk | Impact | Mitigation |
|------|--------|------------|
| Null return dari plane intersect | Medium | Handle null, default to last known direction |
| Camera not found | Low | Cache camera reference in _ready() |
| Performance (every frame) | Low | Plane intersection is fast |

## Open Questions

- [x] RayCast3D vs Plane intersection? → Plane intersection, simpler untuk flat ground
- [x] Cache camera reference? → Ya, di _ready()
- [x] Keep movement-based flip sebagai fallback? → Tidak, pure aim-based

## References

- GDD Section 6 - Phase 1.4 Mouse Aiming System
- Godot 4 Docs - Camera3D
- Godot 4 Docs - Plane
