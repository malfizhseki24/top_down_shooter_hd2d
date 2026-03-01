## Why

Phase 1.2 dari production pipeline - Membuat player scene sebagai fondasi untuk semua gameplay mechanics. Player scene adalah core entity yang akan receive movement, aiming, combat, dan dash systems di phase selanjutnya.

## Gameplay Impact

Player scene adalah representasi fisik pemain di dunia game:
- **Sprite3D** - Visual player dengan billboard mode untuk HD-2D aesthetic
- **CollisionShape3D** - Physics interaction dengan world dan enemies
- **GunMarker3D** - Spawn point untuk bullet saat menembak

## What Changes

### New Features
- **Player Scene**: CharacterBody3D dengan Sprite3D billboard, collision, dan gun marker
- **Placeholder Sprite**: Simple colored rectangle sebagai placeholder sebelum final art

### Technical Setup
- CharacterBody3D sebagai root node untuk physics movement
- Sprite3D dengan Y-Billboard mode untuk selalu menghadap kamera
- Cylinder collision shape untuk top-down collision
- Node3D marker untuk bullet spawn point

## Game Systems

### New Systems
- `player-scene`: Player scene structure dengan semua required components

### Modified Systems
- None (new scene)

## Technical Considerations

### Scenes Affected
- `scenes/player/player.tscn` (baru)

### Scripts Affected
- None (scene-only, scripts di Phase 1.3)

### Assets Needed
- Placeholder sprite (akan dibuat sebagai colored TextureRect atau menggunakan icon)

## Playtesting Focus

- [ ] Player scene dapat di-instance ke level
- [ ] Sprite visible dan menghadap kamera (billboard)
- [ ] Collision shape proporsional
- [ ] GunMarker di posisi yang benar

## Risks

| Risk | Mitigation |
|------|------------|
| Sprite scale tidak proporsional | Test dengan camera top-down, adjust scale |
| Collision terlalu besar/kecil | Visual debug collision shape |
| Billboard mode tidak natural | Verify Y-Billboard setting, check dari berbagai angle |
