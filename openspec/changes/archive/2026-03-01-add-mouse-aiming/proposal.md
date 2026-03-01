## Why

Phase 1.4 dari production pipeline - Implementasi mouse aiming system. Player sudah bisa bergerak dengan WASD, sekarang perlu menghadap ke arah mouse cursor untuk twin-stick shooter mechanic.

## Gameplay Impact

Player sprite menghadap ke arah mouse cursor:
- **Aiming** - Sprite selalu menghadap ke posisi mouse di world space
- **Flip H** - Sprite flip horizontal berdasarkan posisi mouse (bukan movement direction)
- **Twin-Stick Ready** - Persiapan untuk shooting mechanic di Phase 3

## What Changes

### New Features
- **Mouse World Position**: Konversi mouse screen position ke world position (X-Z plane)
- **Aim Direction**: Hitung direction dari player ke mouse world position
- **Sprite Flip by Aim**: Flip sprite berdasarkan aim direction, bukan movement direction

### Technical Setup
- Camera ray projection untuk mendapatkan world position
- Plane intersection untuk Y=0 (ground level)
- Update flip_h logic di player_controller.gd

## Game Systems

### New Systems
- `mouse-aiming`: Player sprite menghadap ke mouse cursor

### Modified Systems
- `player-movement`: Flip_h sekarang berdasarkan aim direction, bukan movement direction

## Technical Considerations

### Scenes Affected
- None (script-only change)

### Scripts Affected
- `scripts/player/player_controller.gd` (modify)

### Assets Needed
- None

## Playtesting Focus

- [ ] Sprite menghadap mouse cursor
- [ ] Sprite flip saat mouse di kiri player
- [ ] Sprite un-flip saat mouse di kanan player
- [ ] Works dengan kombinasi movement + aiming
- [ ] No jittering atau flickering

## Risks

| Risk | Mitigation |
|------|------------|
| Ray calculation salah | Test dengan debug draw, verify plane intersection |
| Jittering saat mouse di edge | Clamp values, smooth jika perlu |
| Conflicting flip logic | Hapus movement-based flip, gunakan aim-based saja |

## References

- GDD Section 6 - Phase 1.4 Mouse Aiming System
- Godot 4 Docs - Camera3D.project_ray_origin, Camera3D.project_ray_normal
- Godot 4 Docs - Plane.intersects_ray
