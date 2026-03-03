# Tasks: add-shooting-mechanics

## Implementation Order

Tasks are ordered for incremental, testable progress. Each task builds on the previous.

---

### Task 1: Create arrow scene structure

**Description**: Create the arrow.tscn scene file with proper node hierarchy.

**Files**:
- `scenes/effects/arrow.tscn` (create)

**Acceptance Criteria**:
- [x] Scene root is Area3D named "Arrow"
- [x] Contains Sprite3D child with billboard mode enabled
- [x] Contains CollisionShape3D child with SphereShape3D
- [x] Scene saved to `res://scenes/effects/arrow.tscn`

**Validation**: Open scene in Godot editor, verify node structure.

---

### Task 2: Create arrow movement script

**Description**: Implement arrow.gd with directional movement and lifetime.

**Files**:
- `scripts/effects/arrow.gd` (create)

**Acceptance Criteria**:
- [x] Script extends Area3D
- [x] `@export var speed: float` with default 15.0
- [x] `@export var lifetime: float` with default 3.0
- [x] `set_direction(dir: Vector3)` function
- [x] Movement in `_physics_process(delta)`
- [x] Despawn via `queue_free()` after lifetime expires

**Validation**: Attach script to arrow scene, run scene, verify no errors.

---

### Task 3: Configure arrow collision layers

**Description**: Set collision layer and mask for player arrow hitbox behavior.

**Files**:
- `scenes/effects/arrow.tscn` (modify)

**Acceptance Criteria**:
- [x] `collision_layer = 8` (Layer 4: Player Bullet)
- [x] `collision_mask = 64` (Layer 7: Enemy Hurtbox)
- [x] CollisionShape3D radius is 0.15 units

**Validation**: Check Inspector values in Godot editor.

---

### Task 4: Add arrow placeholder sprite

**Description**: Add a visible placeholder sprite for the arrow.

**Files**:
- `scenes/effects/arrow.tscn` (modify)

**Acceptance Criteria**:
- [x] Sprite3D has a visible texture (can use icon.svg or create simple shape)
- [x] Billboard mode set to Y (1)
- [x] Arrow length ~0.4 units (proportional to player height of 0.6 units)
- [x] Arrow width ~0.08 units (slender projectile appearance)
- [x] Sprite positioned at arrow origin

**Validation**: Arrow visible when spawned, appears proportional to player size.

---

### Task 5: Create player combat script

**Description**: Implement player_combat.gd with shooting input handling.

**Files**:
- `scripts/player/player_controller.gd` (modify - integrated shooting)

**Acceptance Criteria**:
- [x] Script extends `PlayerController` (inheritance) OR
- [x] Script is a component attached to player node
- [x] `@export var arrow_scene: PackedScene`
- [x] `@export var shoot_cooldown: float` with default 0.15
- [x] `_input(event)` handles "shoot" action
- [x] `_shoot()` function instantiates and configures arrow
- [x] Cooldown prevents spam shooting

**Validation**: Print debug message when shoot button pressed.

---

### Task 6: Integrate combat script with player scene

**Description**: Attach player_combat.gd to player and configure arrow reference.

**Files**:
- `scenes/player/player.tscn` (modify)

**Acceptance Criteria**:
- [x] Player has combat script attached (or integrated)
- [x] Arrow scene assigned to `arrow_scene` export
- [x] GunMarker node referenced for spawn position

**Validation**: Player scene loads without errors.

---

### Task 7: Implement arrow direction from mouse position

**Description**: Calculate and set arrow direction toward mouse world position.

**Files**:
- `scripts/player/player_controller.gd` (modify)

**Acceptance Criteria**:
- [x] Reuse `_get_mouse_world_position()` logic
- [x] Direction calculated as (mouse_pos - gun_marker_pos).normalized()
- [x] Direction Y component set to 0
- [x] Arrow's `set_direction()` called with calculated direction

**Validation**: Arrows travel toward mouse cursor.

---

### Task 8: Playtest shooting mechanics

**Description**: Full integration test of shooting system.

**Acceptance Criteria**:
- [x] Left-click spawns arrow at player position
- [x] Arrows travel in straight line toward mouse
- [x] Arrows despawn after 3 seconds
- [x] Cooldown prevents rapid-fire
- [x] Arrow size proportional to player (~0.4 units long vs player 0.6 units tall)
- [x] No console errors or warnings
- [x] 60 FPS maintained
- [x] Sprite faces camera (billboard working)

**Validation**: Manual playtest in test_player.tscn or forest_01.tscn.

---

## Dependencies

```
Task 1 ─┬─> Task 2 ──> Task 3 ──> Task 4
        │
        └───────────────────────────────> Task 5 ──> Task 6 ──> Task 7 ──> Task 8
```

- Tasks 1-4 can be done in parallel with Task 5
- Task 6 requires Tasks 4 and 5 complete
- Task 7 requires Task 6 complete
- Task 8 requires all previous tasks

## Notes

- For MVP, we use simple `queue_free()` for arrow despawn. Object pooling comes in Phase 3.2.
- The combat script uses inheritance from PlayerController for simplicity. If composition is preferred, refactor after MVP.
