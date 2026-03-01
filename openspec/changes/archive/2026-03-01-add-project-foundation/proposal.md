## Why

Project Kasuari membutuhkan fondasi arsitektur yang solid sebelum memulai development fitur gameplay. Setup yang benar di awal akan mencegah teknical debt dan memudahkan scaling di kemudian hari.

## Gameplay Impact

Tidak langsung visible ke player, tapi ini adalah fondasi untuk semua sistem game:
- **Game.gd** - Mengelola state game (menu, playing, paused, game over)
- **Events.gd** - Event bus global untuk komunikasi antar sistem yang decoupled

## What Changes

### New Features
- **Project Structure**: Folder hierarchy sesuai GDD untuk organisasi yang bersih
- **Autoload Singletons**: Game.gd dan Events.gd untuk global state management
- **Input Map**: Konfigurasi input untuk movement, dash, dan shoot
- **Project Settings**: Rendering configuration untuk HD-2D style

### Technical Setup
- Input mapping (WASD, Mouse, Space)
- Forward+ renderer configuration
- .gdignore untuk optimasi import assets

## Game Systems

### New Systems
- `project-architecture`: Folder structure, autoloads, input configuration, project settings

### Modified Systems
- None (initial setup)

## Technical Considerations

### Scenes Affected
- None (belum ada scene)

### Scripts Affected
- `scripts/autoload/game.gd` (baru)
- `scripts/autoload/events.gd` (baru)

### Assets Needed
- None

## Playtesting Focus

- [ ] Project dapat di-run tanpa error
- [ ] Autoloads terdaftar dan accessible
- [ ] Input map bekerja (debug print)

## Risks

| Risk | Mitigation |
|------|------------|
| Struktur folder berubah di tengah development | Ikuti GDD yang sudah finalized |
| Autoload naming conflict | Gunakan prefix yang jelas, document di project.md |
