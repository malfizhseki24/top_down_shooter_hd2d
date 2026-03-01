## 1. Add Camera Reference

- [x] 1.1 Tambah variable `var _camera: Camera3D` di player_controller.gd
- [x] 1.2 Cache camera di `_ready()` function

## 2. Implement Mouse World Position

- [x] 2.1 Buat func `_get_mouse_world_position() -> Vector3`
- [x] 2.2 Get mouse position dari viewport
- [x] 2.3 Get ray origin dan ray normal dari camera
- [x] 2.4 Create Plane(Vector3.UP, 0) untuk ground
- [x] 2.5 Return plane.intersects_ray(ray_origin, ray_dir)

## 3. Implement Aim Direction

- [x] 3.1 Buat func `_get_aim_direction() -> Vector3`
- [x] 3.2 Call `_get_mouse_world_position()`
- [x] 3.3 Calculate direction dari player ke mouse position
- [x] 3.4 Normalize dan zero-out Y component
- [x] 3.5 Handle null return dari plane intersection

## 4. Update Sprite Flip Logic

- [x] 4.1 Remove movement-based flip_h logic dari `_update_animation()`
- [x] 4.2 Tambah aim-based flip_h logic
- [x] 4.3 Call flip logic di `_physics_process()` (setiap frame, tidak hanya saat moving)

## 5. Verification

- [ ] 5.1 Run test scene (test_player.tscn)
- [ ] 5.2 Verify sprite menghadap mouse saat diam
- [ ] 5.3 Verify sprite menghadap mouse saat bergerak
- [ ] 5.4 Verify flip saat mouse di kiri player
- [ ] 5.5 Verify un-flip saat mouse di kanan player
- [ ] 5.6 Test edge case: mouse di luar window
- [ ] 5.7 Commit dengan message: "feat: Add mouse aiming system for player sprite orientation"
