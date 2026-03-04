# Tasks: Add Basic Enemy

## Implementation Order

### 1. Create Sprite Folder Structure
- [x] Create `assets/sprites/enemies/` folder
- [x] Create `assets/sprites/enemies/basic/` folder
- [x] Create `assets/sprites/enemies/basic/idle/` folder for spritesheet

### 2. Create Enemy Frames Resource
- [x] Create `resources/enemy_frames.tres` SpriteFrames resource
- [x] Add placeholder "idle" animation (can use single 64x64 colored square)
- [x] Configure animation speed (12 FPS to match player)

### 3. Create Enemy Scene
- [x] Create `scenes/enemies/enemy_base.tscn` with CharacterBody3D root
- [x] Add AnimatedSprite3D with Y-Billboard mode
- [x] Assign enemy_frames.tres to AnimatedSprite3D
- [x] Add CollisionShape3D (Cylinder, radius=0.25, height=0.5)
- [x] Add HurtboxComponent as child scene
- [x] Configure collision_layer=4 (Enemy) and collision_mask=5 (World+Player)

### 4. Create Enemy Script
- [x] Create `scripts/enemies/enemy_base.gd`
- [x] Add `@export var move_speed: float = 3.0`
- [x] Add `@export var max_health: int = 3`
- [x] Add `signal died`
- [x] Implement `_ready()` to find player and connect hurtbox signal
- [x] Implement `_physics_process()` with follow-player AI
- [x] Implement sprite flip based on velocity.x
- [x] Implement `_on_hurtbox_damage_received()` to handle damage
- [x] Implement death (emit signal, queue_free)

### 5. Configure Hurtbox
- [x] Set Hurtbox collision_layer to 64 (EnemyHurtbox)
- [x] Set Hurtbox collision_mask to 8 (PlayerProjectile)
- [x] Connect `damage_received` signal to enemy script

### 6. Add Enemy Spawner (Bonus)
- [x] Create `scripts/enemies/enemy_spawner.gd`
- [x] Add EnemySpawner to forest_01.tscn
- [x] Add 4 spawn points at corners of arena
- [x] Configure spawner: enemy_scene, spawn_interval=3.0, max_enemies=5

### 7. Test Enemy Mechanics
- [ ] Run forest_01 scene
- [ ] Test enemy spawns automatically
- [ ] Test enemy follows player
- [ ] Test sprite flips when moving left/right
- [ ] Test arrow hits enemy (damage received)
- [ ] Test enemy dies after 3 hits (default health)
- [ ] Test enemy collides with world geometry
- [ ] Test max_enemies limit (no more than 5 at once)
- [ ] Verify no console errors
