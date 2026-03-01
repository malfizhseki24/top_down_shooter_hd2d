## Why

Phase 1.3 dari production pipeline - Implementasi player movement system. Player scene sudah ada dengan AnimatedSprite3D, collision, dan GunMarker. Sekarang perlu menambahkan script untuk membaca input dan menggerakkan player di dunia 3D.

## Gameplay Impact

Player dapat bergerak menggunakan WASD di arena:
- **Movement** - Player bergerak smooth di plane X-Z (top-down)
- **Input Reading** - Menggunakan Input.get_vector() untuk 8-directional movement
- **Tunable Speed** - Movement speed dapat di-adjust di Inspector

## What Changes

### New Features
- **Player Controller Script**: GDScript yang extend CharacterBody3D untuk movement logic
- **Movement Speed Export**: Variable yang dapat di-tune di Inspector untuk balancing

### Technical Setup
- Script attached ke Player node (CharacterBody3D)
- Velocity calculation berdasarkan input direction
- move_and_slide() untuk smooth collision-based movement

## Game Systems

### New Systems
- `player-movement`: 8-directional movement system menggunakan CharacterBody3D

### Modified Systems
- `player-scene`: Player node sekarang memiliki script attached

## Technical Considerations

### Scenes Affected
- `scenes/player/player.tscn` (attach script)

### Scripts Affected
- `scripts/player/player_controller.gd` (baru)

### Assets Needed
- None (script-only)

## Playtesting Focus

- [ ] Player bergerak dengan WASD
- [ ] Movement smooth tanpa stuttering
- [ ] 8-directional movement bekerja (diagonal)
- [ ] Collision dengan ground/floor bekerja
- [ ] Movement speed dapat di-adjust di Inspector

## Risks

| Risk | Mitigation |
|------|------------|
| Input tidak responsive | Verify input map di project settings |
| Movement terlalu cepat/lambat | @export var untuk easy tuning |
| Collision issues | Test dengan floor collision, verify move_and_slide() |

## References

- GDD Section 6 - Phase 1.3 Player Movement System
- Godot 4 Docs - CharacterBody3D, move_and_slide()
