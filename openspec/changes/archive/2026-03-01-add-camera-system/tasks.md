## 1. Create Camera Script

- [x] 1.1 Buat folder `scripts/camera/` jika belum ada
- [x] 1.2 Buat file `scripts/camera/camera_follow.gd`
- [x] 1.3 Extend Camera3D
- [x] 1.4 Tambah `@export var target: Node3D`
- [x] 1.5 Tambah `@export var smoothing_speed: float = 5.0`
- [x] 1.6 Tambah `@export var offset: Vector3 = Vector3(0, 8, 6)`

## 2. Implement Smooth Follow

- [x] 2.1 Buat func `_process(delta: float) -> void`
- [x] 2.2 Check if target != null
- [x] 2.3 Calculate target position (target.global_position + offset)
- [x] 2.4 Lerp current position ke target position
- [x] 2.5 Apply ke global_position

## 3. Update Test Scene

- [x] 3.1 Buka `scenes/levels/test_player.tscn`
- [x] 3.2 Assign script ke Camera3D node
- [x] 3.3 Set target ke Player node (auto-find via group)
- [x] 3.4 Verify offset dan rotation sudah correct

## 4. Verification

- [ ] 4.1 Run test scene
- [ ] 4.2 Test camera follow saat player bergerak
- [ ] 4.3 Verify smooth interpolation (tidak jittery)
- [ ] 4.4 Test berbagai smoothing_speed values
- [ ] 4.5 Commit dengan message: "feat: Add smooth camera follow system"
