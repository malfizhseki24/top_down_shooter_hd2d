## 1. Create Player Scene

- [x] 1.1 Buat scene baru dengan CharacterBody3D root, simpan sebagai `scenes/player/player.tscn`
- [x] 1.2 Rename root node menjadi `Player`

## 2. Create SpriteFrames Resource

- [x] 2.1 Buat SpriteFrames resource baru, simpan sebagai `resources/player_frames.tres`
- [x] 2.2 Tambah animasi "idle" ke SpriteFrames
- [x] 2.3 Load `kasuari_idle.png` dan add 16 frames (region: 64x64 each)
- [x] 2.4 Tambah animasi "running" ke SpriteFrames
- [x] 2.5 Load `kasuari_running.png` dan add 16 frames (region: 64x64 each)
- [x] 2.6 Tambah animasi "attacking" ke SpriteFrames
- [x] 2.7 Load `kasuari_attack.png` dan add 16 frames (region: 64x64 each)
- [x] 2.8 Set default animation ke "idle"
- [x] 2.9 Set animasi speed ke 12 FPS

## 3. Add AnimatedSprite3D

- [x] 3.1 Tambah AnimatedSprite3D sebagai child of Player
- [x] 3.2 Assign SpriteFrames resource (`player_frames.tres`)
- [x] 3.3 Set Billboard property ke `BILLBOARD_Y` (Mode: Y)
- [x] 3.4 Set Scale ke (0.5, 0.5, 0.5)
- [x] 3.5 Set Offset Y ke 0.5 (agar sprite di atas ground)
- [x] 3.6 Verify Centered = true
- [x] 3.7 Set Autoplay ke "idle"

## 4. Add CollisionShape3D

- [x] 4.1 Tambah CollisionShape3D sebagai child of Player
- [x] 4.2 Create new CylinderShape3D resource
- [x] 4.3 Set Radius = 0.3
- [x] 4.4 Set Height = 1.0
- [x] 4.5 Set Position Y = 0.5 (center cylinder di atas ground)

## 5. Add GunMarker

- [x] 5.1 Tambah Node3D sebagai child of Player
- [x] 5.2 Rename menjadi `GunMarker`
- [x] 5.3 Set Position ke (0, 0.5, 0)

## 6. Add Hurtbox (Preparation for Phase 3)

- [x] 6.1 Tambah Area3D sebagai child of Player
- [x] 6.2 Rename menjadi `Hurtbox`
- [x] 6.3 Tambah CollisionShape3D ke Hurtbox
- [x] 6.4 Set shape to CylinderShape3D (Radius: 0.35, Height: 1.0)
- [x] 6.5 Set collision_layer to bit 6 (Player Hurtbox)
- [x] 6.6 Set collision_mask to bit 5 (Enemy Bullet)

## 7. Configure Collision Layers

- [x] 7.1 Set Player (CharacterBody3D) collision_layer to bit 2 (Player)
- [x] 7.2 Set Player collision_mask to bit 1 (World) + bit 3 (Enemy)

## 8. Verification

- [x] 8.1 Instance player.tscn ke new scene untuk test
- [x] 8.2 Add Camera3D untuk verify billboard behavior
- [x] 8.3 Verify idle animation plays dan menghadap kamera
- [x] 8.4 Verify collision shape visible di debug view
- [x] 8.5 Verify GunMarker position correct
- [ ] 8.6 Test flip_h untuk arah kiri (script di Phase 1.3)
- [ ] 8.7 Commit dengan message: "feat: Add player scene with AnimatedSprite3D, collision, and Kasuari sprites"
