# Proposal: add-object-pooling

## Why

The current shooting system creates new arrow instances via `instantiate()` and destroys them via `queue_free()` for every shot. This causes:
- Memory allocation overhead during gameplay
- Potential GC spikes during intense combat
- Performance degradation with many arrows on screen

Per GDD Phase 3.2, object pooling is required to maintain 60 FPS with 50+ projectiles on screen.

## What Changes

### Arrow Pooling System
Replace dynamic allocation with a pre-allocated pool of reusable arrow objects:

1. **Create ObjectPool Autoload Singleton**
   - Pre-instantiate arrows at game start
   - Provide `acquire()` and `release()` API
   - Auto-expand pool if needed (with warning)

2. **Modify Arrow Script**
   - Add `reset()` method for pool re-initialization
   - Replace `queue_free()` with pool release

3. **Update Player Controller**
   - Use `ObjectPool.acquire("Arrow")` instead of `instantiate()`
   - No other behavior changes

### Files
- `scripts/autoload/object_pool.gd` (create)
- `scripts/effects/arrow.gd` (modify - add reset method)
- `scripts/player/player_controller.gd` (modify - use pool)
- `project.godot` (modify - register autoload)

## Scope

**In Scope:**
- Arrow pooling only (MVP requirement)
- Pool configuration via exports
- Basic pool statistics (optional debug)

**Out of Scope:**
- Particle effect pooling (Phase 4)
- Enemy pooling
- Generic pool for all object types
