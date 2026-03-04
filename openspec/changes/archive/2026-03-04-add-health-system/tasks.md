# Implementation Tasks: Add Health System

## Task Breakdown

### 1. Create HealthComponent Script
- [x] Create `scripts/components/health_component.gd`
- [x] Define class_name HealthComponent extends Node
- [x] Add `@export var max_health: int = 3`
- [x] Add `var is_invulnerable: bool = false`
- [x] Add `var _current_health: int` (internal state)
- [x] Implement `_ready()` to initialize _current_health from max_health
- [x] Implement `take_damage(amount: int) -> void`
  - Check is_invulnerable, return early if true
  - Store old_health
  - Clamp _current_health to [0, max_health]
  - Emit health_changed if health changed
  - Emit died if health reached 0 (and wasn't already 0)
- [x] Implement `heal(amount: int) -> void`
  - Store old_health
  - Increase _current_health
  - Clamp to max_health
  - Emit health_changed if health changed
- [x] Implement `get_health_percent() -> float`
  - Return _current_health / float(max_health)
- [x] Add signals: `health_changed(new_health: int, old_health: int)` and `died()`
- [x] Add inline documentation (comments)
- [x] **Test**: Create test scene, verify signals emit correctly

### 2. Create HealthComponent Scene
- [x] Create `scenes/components/health_component.tscn`
- [x] Root node: HealthComponent (inherits from script above)
- [x] Set max_health = 3 (default)
- [x] Save scene
- [x] **Test**: Can instantiate scene in editor without errors

### 3. Refactor Enemy to Use HealthComponent
- [x] Open `scenes/enemies/enemy_base.tscn`
- [x] Add HealthComponent as child node (instance health_component.tscn)
- [x] Open `scripts/enemies/enemy_base.gd`
- [x] Remove `var _current_health: int` inline variable
- [x] Remove health initialization from `_ready()`
- [x] Add `@onready var health: HealthComponent = $HealthComponent`
- [x] Update `_ready()` to:
  - Connect `health.died` to new `_on_died()` function
  - Keep hurtbox.damage_received connection
- [x] Update `_on_hurtbox_damage_received()`:
  - Replace inline damage logic with `health.take_damage(hitbox.damage)`
- [x] Add new `_on_died()` function:
  - Emit existing `died` signal (for backward compatibility)
  - Call `queue_free()`
- [x] Remove dead code related to inline health
- [x] **Test**: Spawn enemy, shoot with arrows, verify damage and death still work
- [x] **Test**: Verify enemy died signal still emits (for future wave system)

### 4. Add HealthComponent to Player
- [x] Open `scenes/player/player.tscn`
- [x] Add HurtboxComponent as child (if not already present)
  - Configure collision_layer = 32 (PlayerHurtbox, bit 6)
  - Configure collision_mask = 0 (hurtboxes don't detect)
- [x] Add HealthComponent as child node
  - Set max_health = 10 (player has more health than enemies)
- [x] Open `scripts/player/player_controller.gd`
- [x] Add `@onready var health: HealthComponent = $HealthComponent`
- [x] Add `@onready var hurtbox: HurtboxComponent = $Hurtbox`
- [x] Update `_ready()`:
  - Connect `hurtbox.damage_received` to new `_on_hurtbox_damage_received()`
  - Connect `health.died` to new `_on_player_died()`
- [x] Implement `_on_hurtbox_damage_received(hitbox: HitboxComponent)`:
  - Call `health.take_damage(hitbox.damage)`
- [x] Implement `_on_player_died()`:
  - For MVP: Just print "Player died" to console
  - (Death screen/game over will be added in Phase 4.5)
- [x] **Test**: Spawn player, use debug to call take_damage, verify health decreases
- [x] **Test**: Verify health.died signal emits when health reaches 0

### 5. Update Player Dash for I-Frames Integration (Optional)
- [x] Open `scripts/player/player_dash.gd` (or player_controller.gd if dash is inline)
- [x] In dash start logic, add `health.is_invulnerable = true`
- [x] In dash end logic, add `health.is_invulnerable = false`
- [x] **Test**: Dash through enemy projectiles, verify no damage taken
- [x] **Note**: This is optional - current implementation disables hurtbox monitoring, which is sufficient

### 6. Integration Testing
- [x] Playtest forest_01 level
- [x] Spawn enemies, shoot arrows at them
- [x] Verify enemies take damage and die correctly
- [x] Verify enemy death still triggers queue_free()
- [x] Debug test: Force damage player, verify health decreases
- [x] Verify player doesn't die to own arrows (collision layer check)
- [x] Verify player can still dash with i-frames (if implemented)

### 7. Documentation & Cleanup
- [x] Add HealthComponent to project documentation (if exists)
- [x] Ensure all health-related code follows project conventions (snake_case, typed)
- [x] Remove any debug prints or test code
- [x] Verify no console errors or warnings in clean run
- [x] Update GDD checklist if applicable

## Validation Checklist

After all tasks complete, verify:

- [x] HealthComponent script exists at `scripts/components/health_component.gd`
- [x] HealthComponent scene exists at `scenes/components/health_component.tscn`
- [x] Enemy uses HealthComponent (no inline health variables)
- [x] Player has HealthComponent attached
- [x] Player has HurtboxComponent attached and configured
- [x] Enemy combat behavior unchanged (arrows still kill enemies)
- [x] Player can take damage (test via debug or enemy projectiles if available)
- [x] health_changed signal works (test with debug print)
- [x] died signal works (test with debug print)
- [x] is_invulnerable blocks damage (if implemented with dash)
- [x] heal() method works (test with debug print)
- [x] get_health_percent() returns correct value
- [x] No performance regression (check FPS during combat)

## Dependencies

- **Blocked by**: None (can start immediately)
- **Blocks**: UI health bars (Phase 4.4), death screen (Phase 4.5)

## Estimated Effort

- **Simple**: 2-3 hours for experienced Godot developer
- **With Testing**: 3-4 hours including playtest and validation

## Parallel Work Opportunities

- Task 1-2 (HealthComponent creation) can be done independently
- Task 3 (enemy refactor) and Task 4 (player integration) can be done in parallel after Task 1-2
- Task 5 (dash i-frames) can be skipped or deferred
- Task 6-7 should be sequential after all implementation tasks

## Rollback Plan

If critical bugs are found:
1. Revert enemy_base.gd changes (restore inline health)
2. Remove HealthComponent from player scene
3. Delete health_component.gd and health_component.tscn
4. Game returns to previous working state (enemy combat only)

## Future Enhancements (Not in MVP)

- Visual health bars above entities
- Health regeneration over time
- Damage numbers floating text
- Screen shake on player damage
- Invulnerability flash effect
- Health pickup items
