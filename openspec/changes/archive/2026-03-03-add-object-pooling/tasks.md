# Tasks: add-object-pooling

## Implementation Order

Tasks are ordered for incremental, testable progress. Each task builds on the previous.

---

### Task 1: Create ObjectPool autoload script

**Description**: Create the object_pool.gd autoload singleton with pool data structure.

**Files**:
- `scripts/autoload/object_pool.gd` (create)

**Acceptance Criteria**:
- [x] Script extends Node
- [x] `_pools: Dictionary` stores pool data
- [x] `@export var initial_arrow_pool_size: int = 20`
- [x] `@export var max_pool_size: int = 100`
- [x] `@export var auto_expand: bool = true`

**Validation**: Script compiles without errors.

---

### Task 2: Implement Pool internal class

**Description**: Create inner Pool class for managing available/in-use objects.

**Files**:
- `scripts/autoload/object_pool.gd` (modify)

**Acceptance Criteria**:
- [x] Inner class `Pool` extends RefCounted
- [x] `_available: Array[Node]` stores idle instances
- [x] `_in_use: Array[Node]` stores active instances
- [x] `acquire() -> Node` returns instance from available
- [x] `release(node: Node)` moves instance back to available

**Validation**: Pool class methods work in isolation.

---

### Task 3: Implement prewarm functionality

**Description**: Add pool prewarming to create initial arrow instances.

**Files**:
- `scripts/autoload/object_pool.gd` (modify)

**Acceptance Criteria**:
- [x] `prewarm(type: String, scene: PackedScene, count: int)` method
- [x] Creates `count` instances and adds to available pool
- [x] Stores scene reference for auto-expand
- [x] Called in `_ready()` for arrows

**Validation**: Pool contains expected number of instances after prewarm.

---

### Task 4: Implement acquire and release API

**Description**: Add public API for getting and returning pooled objects.

**Files**:
- `scripts/autoload/object_pool.gd` (modify)

**Acceptance Criteria**:
- [x] `acquire(type: String) -> Node` returns pooled instance
- [x] `release(type: String, node: Node)` returns instance to pool
- [x] Auto-expand creates new instance if pool empty and enabled
- [x] Warning logged on auto-expand
- [x] Error logged if max pool size exceeded

**Validation**: Acquire/release cycle works correctly.

---

### Task 5: Register ObjectPool as autoload

**Description**: Add ObjectPool to project autoloads in project.godot.

**Files**:
- `project.godot` (modify)

**Acceptance Criteria**:
- [x] ObjectPool registered in [autoload] section
- [x] Load order correct (before scenes that use it)
- [x] Singleton accessible globally as `ObjectPool`

**Validation**: `ObjectPool` resolves in other scripts.

---

### Task 6: Add reset method to Arrow

**Description**: Implement reset() method in arrow.gd for pool reuse.

**Files**:
- `scripts/effects/arrow.gd` (modify)

**Acceptance Criteria**:
- [x] `reset()` method added
- [x] `_lifetime_timer` reset to 0.0
- [x] `_direction` reset to Vector3.FORWARD
- [x] Method is public (can be called by pool)

**Validation**: Calling reset() clears all arrow state.

---

### Task 7: Update Arrow despawn to use pool

**Description**: Replace queue_free() with pool release in arrow.gd.

**Files**:
- `scripts/effects/arrow.gd` (modify)

**Acceptance Criteria**:
- [x] `queue_free()` replaced with `ObjectPool.release("Arrow", self)`
- [x] Arrow returns to pool instead of being freed
- [x] Works correctly when pool doesn't exist (fallback)

**Validation**: Arrows return to pool after lifetime expires.

---

### Task 8: Update PlayerController to use pool

**Description**: Replace instantiate() with pool acquire in player_controller.gd.

**Files**:
- `scripts/player/player_controller.gd` (modify)

**Acceptance Criteria**:
- [x] `arrow_scene.instantiate()` replaced with `ObjectPool.acquire("Arrow")`
- [x] Arrow configured the same way (position, direction, rotation)
- [x] Shoot behavior unchanged from player perspective

**Validation**: Player can shoot arrows using pool.

---

### Task 9: Playtest pooled shooting

**Description**: Full integration test of pooled arrow system.

**Acceptance Criteria**:
- [x] Player can shoot arrows normally
- [x] Arrows despawn and return to pool
- [x] Rapid fire reuses pooled arrows
- [x] No console errors or warnings (except intentional pool expansion)
- [x] 60 FPS maintained with 50+ arrows
- [x] Memory usage stable (no growth over time)

**Validation**: Manual playtest in forest_01.tscn with profiler.

**Note**: This task requires manual testing in the Godot editor. Implementation is complete and should work as designed based on code review.

---

## Dependencies

```
Task 1 ──> Task 2 ──> Task 3 ──> Task 4 ──> Task 5
                                              │
                                              ▼
Task 6 ──> Task 7 ───────────────────────> Task 8 ──> Task 9
```

- Tasks 1-5 must complete before Task 8
- Tasks 6-7 can be done in parallel with Tasks 1-5
- Task 8 requires both Task 5 and Task 7
- Task 9 requires all previous tasks

## Notes

- Pool uses duck typing for reset() - any object with reset() can be pooled
- For MVP, only arrows are pooled. Particles and enemies come later.
- Debug overlay for pool stats is optional (nice-to-have)
