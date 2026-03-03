# How-To: Membuat MeshLibrary dari Kenney Nature Kit

Panduan step-by-step untuk membuat MeshLibrary di Godot 4.x Editor.

> **Note:** Workflow ini untuk Godot 4.x (4.3, 4.4, 4.5, 4.6). Berbeda dari Godot 3.x!

---

## Prerequisites
- Kenney Nature Kit sudah ada di `assets/3d/kenney_nature-kit/`
- Folder `resources/mesh_libraries/` sudah dibuat

---

## Metode 1: Scene → Export as MeshLibrary (Recommended)

Metode ini lebih terorganisir dan mudah untuk mengelola banyak meshes.

### Step 1: Buat Scene untuk MeshLibrary

1. **Scene → New Scene**
2. Pilih **3D Scene** template
3. Rename root node menjadi `NatureKitSource`
4. Save sebagai `resources/mesh_libraries/nature_kit_source.tscn`

### Step 2: Tambahkan Meshes ke Scene

Untuk setiap asset yang ingin ditambahkan:

1. **Drag** file `.obj` dari FileSystem ke scene tree
2. Mesh akan menjadi child node dengan nama file-nya
3. Atur posisi sehingga semua mesh berada di Y=0 (ground level)

#### Ground Tiles (Wajib dengan Collision):
```
NatureKitSource
├── ground_grass (MeshInstance3D)
│   └── StaticBody3D
│       └── CollisionShape3D (Box/Convex)
├── ground_dirt (MeshInstance3D)
│   └── StaticBody3D
│       └── CollisionShape3D
├── platform_grass
├── path_stone
└── ground_pathCross
```

#### Cara Tambah Collision ke Mesh (Godot 4.6):
1. Pilih MeshInstance3D node di Scene tree
2. **Klik kanan** pada node tersebut
3. Pilih salah satu:
   - **Create Single Convex Collision Static Body** - untuk convex sederhana (recommended)
   - **Create Simplified Convex Collision Static Body** - untuk convex yang disederhanakan
   - **Create Trimesh Static Body** - untuk collision detail (concave, lebih berat)
4. Godot otomatis membuat StaticBody3D + CollisionShape3D sebagai child node

> **Note:** Di Godot 4.6, opsi ini ada di **context menu (klik kanan)**, bukan di menu Mesh Inspector.

#### Trees (Dengan Collision):
```
├── tree_pineTallA
│   └── StaticBody3D (Convex)
├── tree_pineSmallA
├── tree_simple
├── tree_palmTall
└── tree_plateau
```

#### Rocks (Dengan Collision):
```
├── rock_largeA
├── rock_smallA
├── stone_smallA (optional: no collision)
├── rock_tallA
└── stone_largeA
```

#### Plants (Tanpa Collision - Decorative):
```
├── plant_bush
├── plant_bushSmall
├── grass_leafs
├── flower_yellowA
└── plant_bushDetailed
```

#### Mushrooms (Tanpa Collision):
```
├── mushroom_red
├── mushroom_tan
└── mushroom_redTall
```

### Step 3: Export sebagai MeshLibrary

1. Dengan scene terbuka, buka **Scene → Export as MeshLibrary...**
2. Pilih lokasi: `resources/mesh_libraries/nature_kit.meshlib`
3. Klik **Save**

### Step 4: Verifikasi MeshLibrary

1. Di FileSystem, double-click `nature_kit.meshlib`
2. MeshLibrary Editor akan terbuka
3. Verifikasi semua items ada dengan preview thumbnails
4. Jika perlu, klik **Generate Thumbnails**

---

## Metode 2: New MeshLibrary dari FileSystem (Alternative)

Metode ini lebih manual tapi memberikan kontrol item per item.

### Step 1: Buat MeshLibrary Resource

1. Di FileSystem dock, navigate ke `resources/mesh_libraries/`
2. **Right-click** → **New Resource**
3. Cari dan pilih **MeshLibrary**
4. Name: `nature_kit.meshlib`
5. Klik **OK**

### Step 2: Buka MeshLibrary Editor

1. **Double-click** `nature_kit.meshlib` di FileSystem
2. MeshLibrary Editor akan terbuka di bawah viewport
3. Atau buka via **Project → Mesh Library** (jika tersedia)

### Step 3: Tambahkan Items

1. Di FileSystem, navigate ke `assets/3d/kenney_nature-kit/`
2. **Drag** file `.obj` ke MeshLibrary Editor panel
3. Item baru akan muncul di list

### Step 4: Configure Setiap Item

Untuk setiap item di MeshLibrary Editor:

1. **Klik item** untuk select
2. Di Inspector (kanan), configure:
   - **Name**: Beri nama yang jelas (e.g., "Ground Grass")
   - **Mesh**: Preview mesh (auto-filled)
   - **Collision**: Klik dropdown → **Add Convex Collision**
   - **Navigation**: Skip untuk MVP

### Step 5: Generate Thumbnails

1. Di MeshLibrary Editor toolbar, klik **Generate Thumbnails**
2. Tunggu proses selesai

### Step 6: Save

1. **Ctrl+S** / **Cmd+S** atau klik **Save**
2. MeshLibrary tersimpan

---

## Asset Checklist

| Category | Filename | Collision |
|----------|----------|-----------|
| **Ground** | | |
| 0 | `ground_grass.obj` | ✅ Convex |
| 1 | `ground_dirt.obj` | ✅ Convex |
| 2 | `platform_grass.obj` | ✅ Convex |
| 3 | `path_stone.obj` | ✅ Convex |
| 4 | `ground_pathCross.obj` | ✅ Convex |
| **Trees** | | |
| 5 | `tree_pineTallA.obj` | ✅ Convex |
| 6 | `tree_pineSmallA.obj` | ✅ Convex |
| 7 | `tree_simple.obj` | ✅ Convex |
| 8 | `tree_palmTall.obj` | ✅ Convex |
| 9 | `tree_plateau.obj` | ✅ Convex |
| **Rocks** | | |
| 10 | `rock_largeA.obj` | ✅ Convex |
| 11 | `rock_smallA.obj` | ✅ Convex |
| 12 | `stone_smallA.obj` | ❌ Optional |
| 13 | `rock_tallA.obj` | ✅ Convex |
| 14 | `stone_largeA.obj` | ✅ Convex |
| **Plants** | | |
| 15 | `plant_bush.obj` | ❌ None |
| 16 | `plant_bushSmall.obj` | ❌ None |
| 17 | `grass_leafs.obj` | ❌ None |
| 18 | `flower_yellowA.obj` | ❌ None |
| 19 | `plant_bushDetailed.obj` | ❌ None |
| **Mushrooms** | | |
| 20 | `mushroom_red.obj` | ❌ None |
| 21 | `mushroom_tan.obj` | ❌ None |
| 22 | `mushroom_redTall.obj` | ❌ None |

---

## Test dengan GridMap

### Step 1: Buat Test Scene

1. **Scene → New Scene** → **3D Scene**
2. Rename root: `TestGridMap`
3. Tambahkan node **GridMap** (klik + → search "GridMap")
4. Save: `scenes/levels/test_gridmap.tscn`

### Step 2: Assign MeshLibrary

1. Pilih **GridMap** node
2. Di Inspector, cari **Mesh Library** property
3. Klik dropdown → **Quick Load**
4. Pilih `resources/mesh_libraries/nature_kit.meshlib`
5. Palette akan muncul di panel bawah viewport

### Step 3: Configure GridMap Settings

Di Inspector, set:
- **Cell Size**: `Vector3(1, 1, 1)` (match Kenney scale)
- **Cell Octant Size**: `8` (default, untuk optimization)
- **Cell Center X/Y/Z**: `true` (center items in cells)

### Step 4: Test Painting

| Action | Shortcut |
|--------|----------|
| Place tile | **Left Click** |
| Delete tile | **Shift + Left Click** atau **Ctrl + Right Click** |
| Rotate tile | **A** / **S** / **D** |
| Change axis | **Z** / **X** / **C** |
| Select different tile | Klik di palette |

---

## Troubleshooting

### MeshLibrary tidak muncul di GridMap palette?
- Pastikan file `.meshlib` sudah di-save
- Coba re-assign via Inspector → Mesh Library
- Restart editor jika perlu

### Collision tidak bekerja?
- Pastikan mesh punya StaticBody3D + CollisionShape3D
- Check collision layer settings (Layer 1 untuk World)
- Test dengan CharacterBody3D player

### Thumbnails hitam/kosong?
- Klik **Generate Thumbnails** di MeshLibrary Editor
- Pastikan ada lighting di scene preview
- Tidak critical - masih bisa dipakai

### Mesh orientation salah?
- Kenney assets biasanya sudah correct
- Jika perlu rotate, lakukan di MeshLibrary Editor per item

---

## Summary

| Item | Count | Collision |
|------|-------|-----------|
| Ground | 5 | ✅ All Convex |
| Trees | 5 | ✅ All Convex |
| Rocks | 5 | ✅ 4 Convex, 1 Optional |
| Plants | 5 | ❌ None |
| Mushrooms | 3 | ❌ None |
| **Total** | **23** | **14-15 dengan collision** |

---

## References

- [Godot 4 GridMap Documentation](https://docs.godotengine.org/zh-cn/4.x/classes/class_gridmap.html)
- [Godot GridMap Tutorial (Chinese)](https://blog.csdn.net/gitblog_00250/article/details/152345012)
- [Godot 4 3D Platformer - GridMap Lesson](https://m.bilibili.com/video/BV1vK7NzvE3C)
