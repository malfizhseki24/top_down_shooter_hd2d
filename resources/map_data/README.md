# ASCII Map Format

System untuk AI-augmented level design menggunakan text-based map editing.

## File Structure

```
resources/map_data/
├── forest_01_ground.txt   # Ground layer map
├── forest_01_props.txt    # Props layer map
└── README.md              # This file
```

## Legend

### Ground Layer
| Char | Mesh Name | Description |
|------|-----------|-------------|
| `G` | GroundGrass | Grass terrain |
| `S` | GroundPathOpen | Stone/dirt path |
| `D` | GroundPathStraight | Straight path |
| `P` | PathStone | Stone decoration |

### Props Layer (dengan Random Variants)
| Char | Variant Group | Possible Meshes |
|------|---------------|-----------------|
| `T` | @trees | TreeTallDark, TreeOakDark, TreeDefaultDark, TreeDetailedDark, TreeThinDark |
| `R` | @rocks_large | RockLargeA, RockLargeB, RockLargeC, RockLargeD |
| `r` | @rocks_small | RockSmallA, RockSmallB, RockSmallC, RockSmallD, RockSmallE |
| `B` | @bushes | BushSmallDarkA, BushSmallDarkB, BushSmallDarkC |
| `.` | (empty) | No prop |

## Random Variants Feature

Props mendukung **random variants** untuk diversity:
- Setiap karakter bisa reference **variant group** dengan prefix `@`
- Contoh: `"T": "@trees"` akan random pick dari tree variants
- Gunakan `random_seed` di Inspector untuk reproducible results
- Set `random_seed = -1` untuk random berbeda setiap paint

## Usage

1. Edit ASCII map files in any text editor
2. Open scene with GridMapPainter node in Godot
3. Click "Paint Map" button in Inspector
4. GridMap akan update sesuai ASCII map

## Coordinate System

```
X-axis: left to right (columns)
Z-axis: top to bottom (rows)
Y-axis: controlled by map_offset in GridMapPainter
```

## Tips untuk AI

- Gunakan `.` untuk area kosong di props layer
- Border trees untuk boundary visual
- Rocks untuk cover di gameplay area
- Keep paths clear untuk player movement
- Variants membuat map terlihat lebih natural
