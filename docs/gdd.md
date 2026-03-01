# Game Design Document (GDD)

## Project Kasuari - v1.2

---

## 1. Identitas Game

| Aspek | Detail |
|-------|--------|
| **Judul** | Project Kasuari (Working Title) |
| **Genre** | Top-Down Action / Twin-Stick Shooter |
| **Visual Style** | HD-2D (2D Pixel Art Sprites di dalam lingkungan 3D Modular) |
| **Engine** | Godot 4.6 |
| **Target Platform** | PC (Windows/Mac) |
| **Status Produksi** | MVP (Minimum Viable Product) Prototype |

---

## 2. Premis & Tema

### Tema Utama
Mengangkat kekayaan cerita rakyat Papua, berpusat pada legenda burung Kasuari.

### Logline
Pemain mengendalikan seorang pejuang (atau entitas perwujudan roh Kasuari) yang harus membersihkan hutan suci dari entitas gelap menggunakan serangan proyektil magis dan manuver lincah.

### Vibe & Atmosphere
- **Rimbun** - Hutan tropis yang lebat dan misterius
- **Mistis** - Elemen supernatural dan magis
- **Atmospheric** - Pencahayaan dinamis dan ambient

### Visual Atmosphere
Hutan pedalaman yang gelap namun dihiasi oleh pencahayaan magis:
- Jamur bercahaya (bioluminescent fungi)
- Sela-sela sinar matahari menembus kanopi pohon (god rays)
- Partikel ambient (debuan, serbut bunga)

---

## 3. Core Gameplay Loop

### Mekanik Utama

#### Eksplorasi
- Bergerak di dunia 3D (sumbu X dan Z) dengan **WASD**
- Kamera top-down mengikuti pemain

#### Combat (Twin-Stick 2-Arah)
| Input | Aksi |
|-------|------|
| **Mouse** | Bidik menggunakan kursor (crosshair di layar 2D diterjemahkan ke 3D) |
| **Klik Kiri** | Menembak lurus ke arah kursor |
| **Spasi** | Dash (menghindar cepat dengan i-frames) |

### Gameplay Flow
```
EXPLORE → ENCOUNTER ENEMY → COMBAT → DASH/EVADE → REPEAT
                                    ↓
                              DEFEAT ENEMY → PROGRESS
```

---

## 4. Art Direction

### Lingkungan (3D Asset Pack)
- **Primary Asset**: Kenney Nature Kit (CC0/Public Domain)
- **Implementation**: Godot GridMap untuk rapid level assembly
- **Style**: Low-poly nature assets dengan post-processing untuk depth

### Karakter & Musuh (2D Sprites MVP)
| Aspek | Detail |
|-------|--------|
| **Orientasi Sprite** | Menghadap Kanan (East) |
| **Flip Horizontal** | Arah Kiri (West) menggunakan `flip_h` |
| **Arah Tambahan** | Tidak ada arah Utara/Selatan (untuk MVP) |
| **Node Type** | Sprite3D dengan setelan **Y-Billboard** |

### Kamera & Post-Processing

#### Kamera
- Sudut atas (**Top-Down** / Isometric)
- Smooth follow dengan damping

#### Post-Processing (Wajib)
| Effect | Tujuan |
|--------|--------|
| **Depth of Field (DoF)** | Fokus pada karakter, blur latar belakang |
| **SSAO** | Ambient Occlusion untuk depth pada Kenney asset |
| **Directional Light Shadows** | Shadow casting untuk dimensi dan depth |
| **Glow/Bloom** | Efek magis pada proyektil dan elemen supernatural |
| **Vignette** | Fokus visual ke tengah layar |

---

## 5. Technical Specifications

### Scene Structure
```
res://
├── scenes/
│   ├── player/
│   │   └── player.tscn          # Sprite3D + collision + scripts
│   ├── enemies/
│   │   └── enemy_base.tscn      # Base enemy template
│   ├── effects/
│   │   ├── bullet.tscn
│   │   └── dash_effect.tscn
│   └── levels/
│       └── forest_01.tscn       # GridMap level
├── assets/
│   ├── 3d/
│   │   └── kenney_nature_kit/   # Nature assets
│   ├── sprites/
│   │   ├── player/
│   │   └── enemies/
│   └── audio/
│       ├── sfx/
│       └── music/
└── resources/
    └── weapons/
```

### Player Node Structure
```
Player (CharacterBody3D)
├── Sprite3D (Y-Billboard)
├── CollisionShape3D
├── RayCast3D (for mouse targeting)
├── GunMarker3D (bullet spawn point)
└── Scripts
    ├── movement.gd
    ├── combat.gd
    └── dash.gd
```

---

## 6. Scope & Workflow

### Tahap 1: Grayboxing & Basic Logic
- [ ] Setup project structure
- [ ] Player movement (WASD di 3D space)
- [ ] Mouse raycast untuk targeting
- [ ] Basic camera follow
- [ ] Crosshair UI

### Tahap 2: Lingkungan & Dunia
- [ ] Import Kenney Nature Kit
- [ ] Setup GridMap palette
- [ ] Susun test level sederhana
- [ ] Basic lighting setup
- [ ] Post-processing volume

### Tahap 3: Combat
- [ ] Shooting mechanics
- [ ] Projectile system (dengan pooling)
- [ ] Enemy basic AI (follow player)
- [ ] Dash mechanic dengan i-frames
- [ ] Hit detection (hitbox/hurtbox)

### Tahap 4: Injeksi Art & Polish
- [ ] Masukkan sprite Kasuari (player)
- [ ] Sprite musuh
- [ ] Atur lighting final
- [ ] Post-processing tuning
- [ ] SFX dan musik dasar
- [ ] Juice (screen shake, particles, flash)

---

## 7. MVP Feature List

### Must Have (Core)
- [x] Player movement (WASD)
- [ ] Mouse aiming & shooting
- [ ] Dash dengan i-frames
- [ ] 1 tipe enemy basic
- [ ] 1 level test arena
- [ ] Health system sederhana

### Should Have
- [ ] Wave spawning
- [ ] Score counter
- [ ] Basic HUD (HP, Score)
- [ ] Death & restart

### Nice to Have (Post-MVP)
- [ ] Multiple weapon types
- [ ] Enemy variants
- [ ] Boss fight
- [ : Upgrade system
- [ : Full Papua-themed sprites

---

## 8. References

### Visual References
- **Octopath Traveler** - HD-2D style reference
- **Enter the Gungeon** - Top-down shooter gameplay
- **Nuclear Throne** - Fast-paced combat feel

### Technical References
- Godot 4 Documentation - 3D
- Kenney Asset Packs
- Papua Folklore & Kasuari Legend

---

## 9. Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | - | Initial GDD |
| 1.1 | - | Added technical specs |
| 1.2 | Current | Added workflow phases, refined scope |

---

*Document maintained for Project Kasuari development.*
