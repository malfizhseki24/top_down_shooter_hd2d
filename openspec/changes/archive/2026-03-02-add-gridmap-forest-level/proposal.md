# add-gridmap-forest-level

## Summary
Setup GridMap system dan buat test level `forest_01.tscn` menggunakan MeshLibrary yang sudah dibuat (nature_kit.meshlib). Ini adalah implementasi GDD Phase 2.2 (GridMap Setup) dan Phase 2.3 (Test Level Assembly).

## Why
GDD Phase 2.2 & 2.3 - Setelah MeshLibrary dibuat (add-kenney-nature-meshlib), langkah selanjutnya adalah:
1. Setup GridMap node dengan MeshLibrary yang sudah ada
2. Buat test level dengan terrain yang playable
3. Place environment assets (trees, rocks) untuk visual dan gameplay

Tanpa level yang proper, player tidak memiliki arena untuk bergerak dan testing gameplay.

## What Changes
- Buat scene `forest_01.tscn` sebagai level test arena
- Setup GridMap node dengan nature_kit.meshlib
- Paint ground tiles (30x30 grid minimum)
- Place trees di border sebagai visual boundary
- Place rocks untuk cover gameplay
- Tambah spawn point untuk player

## Scope
- GridMap node configuration (cell size, mesh library assignment)
- Ground painting dengan ground_grass, ground_dirt tiles
- Border decoration dengan tree assets
- Rock placement untuk cover
- Player spawn point (Marker3D)
- Basic collision testing

## Out of Scope
- Lighting setup (Phase 2.4)
- Post-processing (Phase 2.5)
- Enemy spawner placement
- Gameplay scripting

## Dependencies
- `add-kenney-nature-meshlib` - MeshLibrary harus sudah ada (✅ DONE)
- `nature_kit.meshlib` di `resources/mesh_libraries/`

## Related Specs
- `project-architecture` - Scene structure dan folder organization
- `player-scene` - Player spawn integration

## Acceptance Criteria
- [ ] GridMap node ada di `forest_01.tscn` dengan MeshLibrary assigned
- [ ] Ground area minimal 30x30 cells dapat diinjak player
- [ ] Border trees sebagai visual boundary
- [ ] Rocks tersebar untuk cover
- [ ] Player dapat spawn dan bergerak tanpa fall through ground
- [ ] Collision bekerja (player tidak bisa menembus trees/rocks dengan collision)
