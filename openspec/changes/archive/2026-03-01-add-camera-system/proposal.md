## Why

Phase 1.5 dari production pipeline - Implementasi camera system dengan smooth follow. Player sudah bisa move dan aim, sekarang perlu camera yang mengikuti player dengan smooth interpolation.

## Gameplay Impact

Camera mengikuti player dengan smooth damping:
- **Smooth Follow** - Camera mengikuti player dengan lerp interpolation
- **Top-Down View** - Camera di posisi tinggi dengan sudut 45-60 degree
- **Tunable Smoothing** - Smoothing speed dapat di-adjust di Inspector

## What Changes

### New Features
- **Camera Follow Script**: Script untuk smooth camera follow
- **Export Variables**: Smoothing speed dapat di-tune

### Technical Setup
- Camera3D sebagai sibling atau remote transform
- Lerp-based position smoothing
- Offset untuk top-down angle

## Game Systems

### New Systems
- `camera-system`: Camera yang smooth mengikuti player

### Modified Systems
- None

## Technical Considerations

### Scenes Affected
- `scenes/levels/test_player.tscn` (add camera script)

### Scripts Affected
- `scripts/camera/camera_follow.gd` (baru)

### Assets Needed
- None

## Playtesting Focus

- [ ] Camera mengikuti player saat bergerak
- [ ] Smooth interpolation (tidak jittery)
- [ ] Smoothing value dapat di-adjust
- [ ] Top-down view terjaga

## Risks

| Risk | Mitigation |
|------|------------|
| Camera jitter | Use _process instead of _physics_process |
| Too slow/fast | @export var untuk tuning |
| Z-fighting | Proper offset values |

## References

- GDD Section 6 - Phase 1.5 Camera System
- Godot 4 Docs - Camera3D, lerp()
