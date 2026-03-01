# Tasks

## Setup
- [x] Buat folder `assets/sprites/ui/` untuk UI sprites
- [x] Buat simple crosshair sprite (PNG, 4-dot atau cross design)

## Scene Creation
- [x] Buat `scenes/ui/hud.tscn` dengan CanvasLayer root
- [x] Tambah TextureRect untuk crosshair di HUD
- [x] Set crosshair texture dan anchor ke center

## Script Implementation
- [x] Buat `scripts/ui/hud.gd` untuk HUD controller
- [x] Implementasi crosshair follow mouse position
- [x] Hide default mouse cursor saat HUD ready
- [x] Restore mouse cursor saat HUD exit (cleanup)

## Integration
- [x] Add HUD scene ke test_player.tscn sebagai child
- [ ] Test crosshair movement mengikuti mouse
- [ ] Verify crosshair tidak terhalang 3D objects

## Validation
- [ ] Playtest: Crosshair visible dan responsive
- [ ] Verify no console errors
