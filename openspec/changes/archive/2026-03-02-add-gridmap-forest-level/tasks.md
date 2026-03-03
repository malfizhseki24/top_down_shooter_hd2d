# Tasks: add-gridmap-forest-level

## Overview
Implementasi GDD Phase 2.2 (GridMap Setup) dan Phase 2.3 (Test Level Assembly).

---

## Phase 2.2: GridMap Setup

### Task 2.2.1: Create Level Scene
- [x] Buat scene baru: **Scene → New Scene → 3D Scene**
- [x] Rename root node menjadi `Forest01`
- [x] Save sebagai `scenes/levels/forest_01.tscn`

### Task 2.2.2: Add GridMap Node
- [x] Dengan scene terbuka, tambahkan node **GridMap**
- [x] GridMap menjadi child dari root `Forest01`

### Task 2.2.3: Assign MeshLibrary
- [x] Pilih GridMap node di Scene tree
- [x] Di Inspector, cari **Mesh Library** property
- [x] Klik dropdown → **Quick Load**
- [x] Pilih `resources/mesh_libraries/nature_kit.meshlib`
- [ ] Verifikasi palette muncul di panel bawah viewport (MANUAL)

### Task 2.2.4: Configure GridMap Settings
- [x] Di Inspector GridMap, set:
  - **Cell Size**: `Vector3(1, 1, 1)` (match Kenney asset scale)
  - **Cell Octant Size**: `8` (default, optimization)
  - **Cell Center X**: `true`
  - **Cell Center Y**: `true`
  - **Cell Center Z**: `true`

---

## Phase 2.3: Test Level Assembly

### Task 2.3.1: Paint Ground Layer ⚠️ MANUAL EDITOR TASK
- [ ] Di GridMap palette, pilih `ground_grass` (atau ground tile yang tersedia)
- [ ] Paint ground plane di Y=0
- [ ] Target: minimal 30x30 cells (X: -15 to 15, Z: -15 to 15)
- [ ] Alternatif: gunakan `ground_dirt` untuk variasi

**GridMap Painting Shortcuts:**
| Action | Shortcut |
|--------|----------|
| Place tile | Left Click |
| Delete tile | Shift + Left Click |
| Rotate tile | Q / E |

### Task 2.3.2: Place Border Trees ⚠️ MANUAL EDITOR TASK
- [ ] Pilih tree asset dari palette (e.g., `tree_pineTallA`)
- [ ] Place trees di sekitar border ground sebagai visual boundary
- [ ] Spacing: 2-3 cells antar tree
- [ ] Pastikan trees memiliki collision (jika ada di MeshLibrary)

### Task 2.3.3: Place Rock Cover ⚠️ MANUAL EDITOR TASK
- [ ] Pilih rock asset dari palette (e.g., `rock_largeA`, `rock_smallA`)
- [ ] Place rocks di area tengah arena untuk cover
- [ ] Distribusi: 5-10 rocks tersebar random
- [ ] Pastikan rocks tidak menghalangi player movement sepenuhnya

### Task 2.3.4: Add Player Spawn Point
- [x] Tambahkan **Marker3D** node ke scene
- [x] Rename menjadi `PlayerSpawn`
- [x] Position di tengah arena (approx `Vector3(0, 0.5, 0)`)
- [x] Pastikan spawn point berada di atas ground (Y=0 atau sedikit di atas)

### Task 2.3.5: Add Basic Lighting
- [x] Tambahkan **DirectionalLight3D** node
- [x] Position dan rotation untuk top-down lighting
- [x] Enable shadows: `Shadow Mode → Enabled`

### Task 2.3.6: Add Camera (or reuse from test_player)
- [x] Copy Camera3D settings dari `test_player.tscn`
- [x] Camera3D dengan CameraFollow script
- [x] Orthographic projection, size 8.0
- [x] Position offset untuk top-down view

### Task 2.3.7: Add WorldEnvironment
- [x] Tambahkan **WorldEnvironment** node
- [x] Basic environment dengan SSAO, Glow, Adjustments (placeholder untuk Phase 2.5)

---

## Validation

### Task 2.3.8: Test Player Movement ⚠️ MANUAL
- [x] Instance `player.tscn` ke dalam `forest_01.tscn`
- [x] Place player di `PlayerSpawn` position
- [ ] Run scene (F6)
- [ ] Test: Player dapat bergerak dengan WASD
- [ ] Test: Player tidak fall through ground (requires ground tiles)
- [ ] Test: Collision dengan trees/rocks bekerja

### Task 2.3.9: Visual Review ⚠️ MANUAL
- [ ] Ground coverage cukup (tidak ada hole)
- [ ] Border trees terlihat sebagai boundary
- [ ] Rocks visible dan tidak terlalu berantakan
- [ ] Lighting memberikan depth

---

## Summary Checklist

| Task | Status |
|------|--------|
| 2.2.1 Create Level Scene | [x] |
| 2.2.2 Add GridMap Node | [x] |
| 2.2.3 Assign MeshLibrary | [x] |
| 2.2.4 Configure GridMap | [x] |
| 2.3.1 Paint Ground | [ ] ⚠️ MANUAL |
| 2.3.2 Place Border Trees | [ ] ⚠️ MANUAL |
| 2.3.3 Place Rock Cover | [ ] ⚠️ MANUAL |
| 2.3.4 Add Spawn Point | [x] |
| 2.3.5 Add Lighting | [x] |
| 2.3.6 Add Camera | [x] |
| 2.3.7 Add WorldEnvironment | [x] |
| 2.3.8 Test Player | [ ] ⚠️ MANUAL |
| 2.3.9 Visual Review | [ ] ⚠️ MANUAL |

---

## Manual Steps Required

Buka `scenes/levels/forest_01.tscn` di Godot Editor dan lakukan:

1. **Paint Ground Tiles** (Task 2.3.1)
   - Pilih GridMap node
   - Di palette (bawah viewport), pilih ground tile
   - Paint minimal 30x30 cells di Y=0

2. **Place Border Trees** (Task 2.3.2)
   - Pilih tree dari palette
   - Place di border ground

3. **Place Rock Cover** (Task 2.3.3)
   - Pilih rock dari palette
   - Place 5-10 rocks di area tengah

4. **Test & Validate** (Tasks 2.3.8-2.3.9)
   - Run scene (F6)
   - Test movement dan collision

---

## Phase Gate 2 Criteria
- [ ] Player bergerak di arena dengan environment
- [ ] Ground collision bekerja
- [ ] Trees/rocks collision bekerja (jika ada)
- [x] Scene saved di `scenes/levels/forest_01.tscn`
