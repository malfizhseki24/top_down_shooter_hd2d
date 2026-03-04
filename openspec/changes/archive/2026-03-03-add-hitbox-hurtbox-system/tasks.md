# Tasks: Add Hitbox/Hurtbox Collision System

## Implementation Order

### 1. Setup Component Directory Structure
- [x] Create `scenes/components/` directory
- [x] Create `scripts/components/` directory

### 2. Create HitboxComponent
- [x] Create `scripts/components/hitbox_component.gd`
  - Extend Area3D
  - Add `@export var damage: int = 1`
  - Add signal `hit_hurtbox(hurtbox: Node)`
  - Connect `area_entered` signal in _ready()
- [x] Create `scenes/components/hitbox_component.tscn`
  - Root: Area3D with script attached
  - Child: CollisionShape3D (placeholder sphere/box)
  - Set monitoring=true, monitorable=true

### 3. Create HurtboxComponent
- [x] Create `scripts/components/hurtbox_component.gd`
  - Extend Area3D
  - Add signal `damage_received(hitbox: Node)`
  - Add method `receive_damage(hitbox: Node)`
  - Connect `area_entered` to check for hitboxes
- [x] Create `scenes/components/hurtbox_component.tscn`
  - Root: Area3D with script attached
  - Child: CollisionShape3D (placeholder sphere/box)
  - Set monitoring=true, monitorable=true

### 4. Update Arrow World Collision
- [x] Modify `scenes/effects/arrow.tscn`
  - Update collision_mask from 64 to 65 (add Layer 1: World)
- [x] Modify `scripts/effects/arrow.gd`
  - Add `body_entered` signal connection in _ready()
  - Implement `_on_body_entered(body: Node)` to stop and despawn on world collision
  - Ensure collision with world triggers immediate despawn

### 5. Test Arrow World Collision
- [x] Run forest_01 scene
- [x] Shoot arrows at trees - verify they stop/despawn
- [x] Shoot arrows at rocks - verify they stop/despawn
- [x] Shoot arrows into open space - verify they travel full lifetime
- [x] Verify arrows do NOT hit player

### 6. Document Collision Layers
- [x] Update project.godot or create documentation for layer naming
- [x] Add layer name comments in code where collision is configured

## Dependencies
- Task 4 depends on existing arrow implementation
- Task 5 requires forest_01 level with collision-enabled geometry

## Parallelizable Work
- Tasks 2 and 3 can be done in parallel
- Task 6 can be done anytime after task 4

## Validation Checklist
- [x] Arrows despawn on tree collision
- [x] Arrows despawn on rock collision
- [x] Arrows do NOT despawn on player proximity
- [x] Arrows travel normally in open space
- [x] HitboxComponent scene instantiates without errors
- [x] HurtboxComponent scene instantiates without errors
- [x] No console errors when shooting
