## 1. Create Player Controller Script

- [x] 1.1 Buat folder `scripts/player/` jika belum ada
- [x] 1.2 Buat file `scripts/player/player_controller.gd`
- [x] 1.3 Extend CharacterBody3D
- [x] 1.4 Tambah class_name PlayerController (optional)

## 2. Implement Movement Variables

- [x] 2.1 Tambah `@export var movement_speed: float = 5.0`
- [x] 2.2 Dokumentasi singkat di komentar

## 3. Implement Input Reading

- [x] 3.1 Buat func `_physics_process(delta: float) -> void`
- [x] 3.2 Implementasi `Input.get_vector("move_left", "move_right", "move_up", "move_down")`
- [x] 3.3 Convert Vector2 input ke Vector3 direction (X-Z plane)
- [x] 3.4 Normalize direction vector untuk consistent diagonal speed

## 4. Implement Velocity & Movement

- [x] 4.1 Set velocity.x dari direction.x * movement_speed
- [x] 4.2 Set velocity.z dari direction.z * movement_speed
- [x] 4.3 Call `move_and_slide()` di akhir _physics_process

## 5. Attach Script to Player Scene

- [x] 5.1 Buka `scenes/player/player.tscn`
- [x] 5.2 Assign script ke root Player node
- [x] 5.3 Verify script appears di Inspector

## 6. Verification

- [ ] 6.1 Run test scene (test_player.tscn)
- [ ] 6.2 Test WASD movement - player bergerak
- [ ] 6.3 Test diagonal movement - speed konsisten
- [ ] 6.4 Test collision dengan ground - player tidak fall through
- [ ] 6.5 Verify movement_speed dapat diubah di Inspector
- [ ] 6.6 Verify sprite flip_h saat bergerak kiri/kanan
- [ ] 6.7 Commit dengan message: "feat: Add player movement system with WASD controls"
