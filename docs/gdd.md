# Game Design Document (GDD)

## Project Kasuari - v1.3

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

## 6. Production Pipeline

> **Philosophy**: Setiap tahap harus menghasilkan build yang playable. Tidak ada "big bang" integration. Test early, test often.

---

### Phase 1: Foundation & Player Core
**Durasi Target**: 2-3 hari | **Deliverable**: Player dapat bergerak dan mengarahkan di scene kosong

#### 1.1 Project Setup & Architecture
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 1.1.1 | Buat folder structure sesuai GDD | Semua folder ada di FileSystem |
| 1.1.2 | Setup .gdignore untuk assets | Folder assets tidak di-scan GDScript |
| 1.1.3 | Buat autoload singleton `Game.gd` | Dapat diakses dari scene manapun |
| 1.1.4 | Buat autoload singleton `Events.gd` | Signal global tersedia |
| 1.1.5 | Setup project settings (rendering, input map) | Forward+ renderer, WASD + Mouse mapped |

**Input Map yang Diperlukan:**
```
move_up    : W
move_down  : S
move_left  : A
move_right : D
dash       : Space
shoot      : Mouse Left
```

#### 1.2 Player Scene Assembly
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 1.2.1 | Buat `player.tscn` dengan CharacterBody3D | Scene tersimpan di scenes/player/ |
| 1.2.2 | Tambah Sprite3D dengan placeholder (kotak berwarna) | Sprite visible di viewport |
| 1.2.3 | Set Sprite3D ke Billboard Mode: Y | Sprite selalu menghadap kamera |
| 1.2.4 | Tambah CollisionShape3D (Cylinder) | Collision ada dan proporsional |
| 1.2.5 | Tambah Node3D sebagai `GunMarker` untuk spawn bullet | Marker berada di posisi tengah karakter |

#### 1.3 Player Movement System
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 1.3.1 | Buat `player_controller.gd` extend CharacterBody3D | Script ter-attach ke player |
| 1.3.2 | Implementasi input reading (get_vector) | Debug print menunjukkan direction |
| 1.3.3 | Implementasi velocity calculation | Player bergerak di plane X-Z |
| 1.3.4 | Tambah `@export var movement_speed: float` | Kecepatan dapat di-tune di Inspector |
| 1.3.5 | Implementasi move_and_slide() | Player bergerak smooth |
| 1.3.6 | **TEST**: Player dapat bergerak dengan WASD | ✓ Playtest pass |

**Code Snippet Reference:**
```gdscript
func _physics_process(delta: float) -> void:
    var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

    velocity.x = direction.x * movement_speed
    velocity.z = direction.z * movement_speed

    move_and_slide()
```

#### 1.4 Mouse Aiming System
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 1.4.1 | Tambah RayCast3D ke player node | RayCast ter-configure dengan benar |
| 1.4.2 | Buat static plane (floor) untuk testing | Raycast dapat hit sesuatu |
| 1.4.3 | Implementasi mouse position to ray | `camera.project_ray()` berhasil |
| 1.4.4 | Hit test ke floor plane | Dapatkan world position |
| 1.4.5 | Hitung look direction (player → mouse) | Vector direction benar |
| 1.4.6 | Flip sprite berdasarkan arah (flip_h) | Sprite flip saat mouse di kiri |
| 1.4.7 | **TEST**: Player sprite menghadap mouse | ✓ Playtest pass |

**Critical Implementation:**
```gdscript
func _get_mouse_world_position() -> Vector3:
    var camera := get_viewport().get_camera_3d()
    var mouse_pos := get_viewport().get_mouse_position()
    var ray_origin := camera.project_ray_origin(mouse_pos)
    var ray_dir := camera.project_ray_normal(mouse_pos)

    # Intersect with Y=0 plane (floor)
    var plane := Plane(Vector3.UP, 0)
    return plane.intersects_ray(ray_origin, ray_dir)
```

#### 1.5 Camera System
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 1.5.1 | Buat Camera3D sebagai sibling player (atau remote) | Camera di posisi tinggi |
| 1.5.2 | Set rotation untuk top-down view (45-90 degree) | View dari atas terlihat |
| 1.5.3 | Implementasi smooth follow dengan lerp | Camera mengikuti dengan delay halus |
| 1.5.4 | Tambah `@export var camera_smoothing: float` | Smoothing dapat di-tune |
| 1.5.5 | **TEST**: Camera smooth mengikuti player | ✓ Playtest pass |

#### 1.6 Crosshair UI
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 1.6.1 | Buat UI scene terpisah (`ui_hud.tscn`) | CanvasLayer dengan Control |
| 1.6.2 | Tambah TextureRect untuk crosshair | Crosshair di tengah atau follow mouse |
| 1.6.3 | Buat simple crosshair sprite (4 garis/dot) | Asset crosshair ada |
| 1.6.4 | Crosshair follow mouse position | Crosshair di posisi mouse |
| 1.6.5 | Hide default mouse cursor | `Input.mouse_mode = MOUSE_MODE_HIDDEN` |
| 1.6.6 | **TEST**: Crosshair visible dan responsive | ✓ Playtest pass |

**🚪 Phase Gate 1**: Player dapat move (WASD), aim (mouse), camera follow smooth, crosshair visible.

---

### Phase 2: World Building & Atmosphere
**Durasi Target**: 2-3 hari | **Deliverable**: Test arena dengan environment HD-2D

#### 2.1 Kenney Nature Kit Integration
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 2.1.1 | Download Kenney Nature Kit (CC0) | Assets tersedia lokal |
| 2.1.2 | Import ke `assets/3d/kenney_nature_kit/` | Semua .glb/.obj ter-import |
| 2.1.3 | Review dan pilih asset yang relevan (trees, rocks, ground) | List asset yang dipakai |
| 2.1.4 | Setup import settings (scale, mesh) | Import settings konsisten |
| 2.1.5 | Create MeshLibrary dari selected assets | MeshLibrary siap untuk GridMap |

#### 2.2 GridMap Setup
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 2.2.1 | Buat GridMap node di scene level | GridMap ada di scene tree |
| 2.2.2 | Assign MeshLibrary ke GridMap | Palette visible di editor |
| 2.2.3 | Configure cell size (match asset scale) | Cell size proporsional |
| 2.2.4 | Paint ground plane (basic terrain) | Ground area playable |

#### 2.3 Test Level Assembly
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 2.3.1 | Buat `forest_01.tscn` sebagai level scene | Level scene tersimpan |
| 2.3.2 | Place ground tiles (30x30 grid minimum) | Area cukup untuk testing |
| 2.3.3 | Place tree assets di sekitar border | Border trees sebagai visual boundary |
| 2.3.4 | Place rock assets untuk cover | Beberapa rocks tersebar |
| 2.3.5 | Spawn point untuk player | Marker3D di tengah arena |
| 2.3.6 | **TEST**: Player dapat bergerak di level tanpa fall | ✓ Playtest pass |

#### 2.4 Lighting Setup
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 2.4.1 | Tambah DirectionalLight3D (sun) | Light menyinari scene |
| 2.4.2 | Set shadow mode enabled | Shadows visible |
| 2.4.3 | Configure light angle untuk god ray effect | Sudut light dramatic |
| 2.4.4 | Tambah Ambient light (Environment) | Base lighting tidak terlalu gelap |
| 2.4.5 | Tambah OmniLight point lights untuk accent | Beberapa point lights untuk mood |
| 2.4.6 | **TEST**: Lighting memberikan depth dan mood | ✓ Visual review pass |

#### 2.5 Post-Processing Pipeline
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 2.5.1 | Tambah WorldEnvironment node | Environment ter-attach |
| 2.5.2 | Enable SSAO (Screen Space Ambient Occlusion) | Contact shadows visible |
| 2.5.3 | Enable DoF Blur (Depth of Field) | Background blur effect |
| 2.5.4 | Configure DoF focus distance | Player dalam fokus |
| 2.5.5 | Enable Glow/Bloom | Bright areas glow |
| 2.5.6 | Enable Vignette | Edges gelap, fokus ke tengah |
| 2.5.7 | Enable Adjustments (contrast, saturation) | Colors pop |
| 2.5.8 | **TEST**: HD-2D vibe tercapai | ✓ Visual review pass |

**Post-Processing Recommended Values:**
```
SSAO:           Amount 1.5, Radius 0.5
DoF Near:       Enabled, Distance 5m
DoF Far:        Enabled, Distance 15m
Glow:           Intensity 0.5, Threshold 0.8
Vignette:       Intensity 0.3
```

**🚪 Phase Gate 2**: Player bergerak di arena dengan environment, lighting, dan post-processing HD-2D.

---

### Phase 3: Combat System
**Durasi Target**: 3-4 hari | **Deliverable**: Player dapat menembak, dash, dan membunuh enemy

#### 3.1 Shooting Mechanics
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 3.1.1 | Buat `bullet.tscn` dengan Area3D + Sprite3D | Bullet scene siap |
| 3.1.2 | Tambah CollisionShape3D ke bullet | Collision sphere kecil |
| 3.1.3 | Buat `bullet.gd` dengan movement forward | Bullet bergerak ke arah target |
| 3.1.4 | Implementasi lifetime/despawn | Bullet destroy setelah X detik |
| 3.1.5 | Tambah `@export var bullet_speed: float` | Speed dapat di-tune |
| 3.1.6 | Implementasi shoot di player (spawn bullet) | Bullet spawn di GunMarker |
| 3.1.7 | Arahkan bullet ke mouse world position | Bullet terbang ke target |
| 3.1.8 | **TEST**: Player dapat menembak ke arah mouse | ✓ Playtest pass |

**Shoot Implementation:**
```gdscript
func _input(event: InputEvent) -> void:
    if event.is_action_pressed("shoot"):
        _shoot()

func _shoot() -> void:
    var bullet := bullet_scene.instantiate()
    get_tree().current_scene.add_child(bullet)
    bullet.global_position = gun_marker.global_position

    var target_pos := _get_mouse_world_position()
    var direction := (target_pos - bullet.global_position).normalized()
    bullet.set_direction(direction)
```

#### 3.2 Object Pooling System
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 3.2.1 | Buat autoload `ObjectPool.gd` | Singleton tersedia |
| 3.2.2 | Implementasi pool untuk bullets | Pool dapat store/retrieve bullets |
| 3.2.3 | Pre-instantiate bullets saat game start | Pool terisi awal |
| 3.2.4 | Implementasi get_bullet() dan return_bullet() | API pool jelas |
| 3.2.5 | Update shooting untuk pakai pool | Tidak ada instantiate saat shoot |
| 3.2.6 | **TEST**: Performance stabil dengan 50+ bullets | ✓ Profiler pass |

#### 3.3 Hitbox/Hurtbox System
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 3.3.1 | Buat `hitbox_component.tscn` (Area3D) | Component scene siap |
| 3.3.2 | Buat `hurtbox_component.tscn` (Area3D) | Component scene siap |
| 3.3.3 | Setup collision layers (HITBOX vs HURTBOX) | Layer configuration benar |
| 3.3.4 | Implementasi signal on area_entered | Signal teremit saat overlap |
| 3.3.5 | Tambah hitbox ke bullet | Bullet dapat detect enemy |
| 3.3.6 | **TEST**: Collision detection bekerja | ✓ Debug signal pass |

**Collision Layer Setup:**
```
Layer 1: World (static geometry)
Layer 2: Player
Layer 3: Enemy
Layer 4: Player Bullet (Hitbox)
Layer 5: Enemy Bullet (Hitbox)
Layer 6: Player Hurtbox
Layer 7: Enemy Hurtbox
```

#### 3.4 Health System
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 3.4.1 | Buat `health_component.gd` | Component script siap |
| 3.4.2 | Tambah `@export var max_health: int` | HP dapat di-set |
| 3.4.3 | Implementasi `take_damage(amount)` | HP berkurang |
| 3.4.4 | Emit signal `health_changed` dan `died` | Signals teremit |
| 3.4.5 | Tambah health component ke player | Player punya HP |
| 3.4.6 | Connect hurtbox ke health component | Damage masuk ke HP |
| 3.4.7 | **TEST**: Player dapat menerima damage | ✓ Playtest pass |

#### 3.5 Dash Mechanic
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 3.5.1 | Buat `player_dash.gd` atau extend controller | Dash logic terpisah |
| 3.5.2 | Implementasi dash input (Space) | Dash trigger saat Space |
| 3.5.3 | Implementasi dash velocity burst | Player move cepat |
| 3.5.4 | Tambah `@export var dash_speed: float` | Speed dapat di-tune |
| 3.5.5 | Tambah `@export var dash_duration: float` | Duration dapat di-tune |
| 3.5.6 | Implementasi dash cooldown | Tidak dapat spam dash |
| 3.5.7 | Implementasi i-frames saat dash | Invulnerable selama dash |
| 3.5.8 | Disable hurtbox collision saat i-frames | Tidak dapat ter-hit |
| 3.5.9 | Tambah visual feedback (trail/afterimage) | Dash terlihat jelas |
| 3.5.10 | **TEST**: Dash dengan i-frames bekerja | ✓ Playtest pass |

**Dash Implementation Pattern:**
```gdscript
enum State { NORMAL, DASHING }
var current_state := State.NORMAL
var dash_timer := 0.0
var dash_direction := Vector3.ZERO

func _physics_process(delta: float) -> void:
    match current_state:
        State.NORMAL:
            _handle_normal_movement(delta)
        State.DASHING:
            _handle_dash(delta)

func _start_dash() -> void:
    current_state = State.DASHING
    dash_timer = dash_duration
    dash_direction = velocity.normalized()
    hurtbox.set_deferred("monitoring", false)  # i-frames
```

#### 3.6 Basic Enemy
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 3.6.1 | Buat `enemy_base.tscn` dengan CharacterBody3D | Enemy scene siap |
| 3.6.2 | Tambah Sprite3D (placeholder) | Sprite visible |
| 3.6.3 | Tambah CollisionShape3D | Collision ada |
| 3.6.4 | Tambah HealthComponent + HurtboxComponent | Enemy punya HP |
| 3.6.5 | Buat `enemy_base.gd` dengan AI follow | Enemy mengikuti player |
| 3.6.6 | Implementasi move_toward ke player | Movement smooth |
| 3.6.7 | Tambah `@export var move_speed: float` | Speed dapat di-tune |
| 3.6.8 | Implementasi death (queue_free) saat HP 0 | Enemy destroy saat mati |
| 3.6.9 | Connect bullet hitbox ke enemy hurtbox | Bullet damage enemy |
| 3.6.10 | **TEST**: Player dapat membunuh enemy dengan tembakan | ✓ Playtest pass |

**🚪 Phase Gate 3**: Combat loop lengkap - shoot, dash, kill enemy.

---

### Phase 4: Polish & Juice
**Durasi Target**: 2-3 hari | **Deliverable**: Game feel solid dengan feedback

#### 4.1 Visual Effects (VFX)
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 4.1.1 | Buat `hit_effect.tscn` (particle burst) | Effect scene siap |
| 4.1.2 | Spawn hit effect saat bullet hit enemy | Effect muncul |
| 4.1.3 | Buat `dash_effect.tscn` (afterimage/trail) | Trail effect siap |
| 4.1.4 | Spawn trail particles saat dash | Trail visible |
| 4.1.5 | Buat `death_effect.tscn` (explosion) | Death effect siap |
| 4.1.6 | Spawn death effect saat enemy mati | Effect dramatic |
| 4.1.7 | **TEST**: VFX menambah game feel | ✓ Visual review pass |

#### 4.2 Camera Effects
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 4.2.1 | Implementasi screen shake saat hit | Camera shake saat damage |
| 4.2.2 | Implementasi screen shake saat dash (subtle) | Mini shake saat dash |
| 4.2.3 | Implementasi camera zoom saat kill (optional) | Satisfying feedback |
| 4.2.4 | Tambah `@export` untuk shake intensity | Tunable di Inspector |
| 4.2.5 | **TEST**: Camera effects enhance impact | ✓ Playtest pass |

**Screen Shake Implementation:**
```gdscript
var shake_amount := 0.0

func _process(delta: float) -> void:
    if shake_amount > 0:
        offset = Vector2(
            randf_range(-shake_amount, shake_amount),
            randf_range(-shake_amount, shake_amount)
        )
        shake_amount = lerp(shake_amount, 0.0, 10.0 * delta)

func shake(amount: float) -> void:
    shake_amount = amount
```

#### 4.3 Audio Implementation
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 4.3.1 | Collect SFX (shoot, hit, dash, death) | SFX files tersedia |
| 4.3.2 | Buat `audio_player.gd` untuk one-shot SFX | Audio utility siap |
| 4.3.3 | Play shoot SFX saat bullet spawn | Sound on shoot |
| 4.3.4 | Play hit SFX saat bullet hit | Sound on hit |
| 4.3.5 | Play dash SFX saat dash | Sound on dash |
| 4.3.6 | Play death SFX saat enemy mati | Sound on death |
| 4.3.7 | **TEST**: Audio feedback enhance gameplay | ✓ Playtest pass |

**Required SFX List:**
- `sfx_shoot.wav` - Player shoot
- `sfx_hit.wav` - Bullet hit enemy
- `sfx_dash.wav` - Player dash
- `sfx_enemy_death.wav` - Enemy death
- `sfx_player_hurt.wav` - Player damaged

#### 4.4 HUD & UI
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 4.4.1 | Buat HP bar (ProgressBar atau TextureProgressBar) | HP bar visible |
| 4.4.2 | Connect HP bar ke player health signal | Bar update saat HP change |
| 4.4.3 | Tambah score counter (Label) | Score visible |
| 4.4.4 | Implementasi score increment saat kill | Score update |
| 4.4.5 | Buat pause menu (Button: Resume, Restart, Quit) | Menu functional |
| 4.4.6 | Implementasi pause (get_tree().paused) | Pause bekerja |
| 4.4.7 | **TEST**: HUD functional dan readable | ✓ Playtest pass |

#### 4.5 Game Loop Polish
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 4.5.1 | Implementasi death screen saat player HP 0 | Death screen muncul |
| 4.5.2 | Tambah restart button | Dapat restart game |
| 4.5.3 | Implementasi wave counter | Wave number visible |
| 4.5.4 | Implementasi enemy spawner (wave-based) | Enemies spawn per wave |
| 4.5.5 | Tuning semua parameter (speed, damage, cooldown) | Feel balanced |
| 4.5.6 | **TEST**: Full game loop dari start to death | ✓ Playtest pass |

#### 4.6 Final Art Integration (Optional untuk MVP)
| Task | Detail | Acceptance Criteria |
|------|--------|---------------------|
| 4.6.1 | Replace player placeholder dengan sprite Kasuari | Player sprite final |
| 4.6.2 | Replace enemy placeholder dengan sprite | Enemy sprite final |
| 4.6.3 | Adjust sprite scale dan pivot | Sprite proporsional |
| 4.6.4 | Tambah animasi idle (jika ada sprite sheet) | Animasi bekerja |
| 4.6.5 | **TEST**: Art style konsisten | ✓ Visual review pass |

**🚪 Phase Gate 4**: MVP Complete - Game playable dari start to finish dengan good game feel.

---

### Production Checklist Summary

| Phase | Key Deliverable | Gate Criteria |
|-------|-----------------|---------------|
| **1** | Player Core | Move + Aim + Camera + Crosshair |
| **2** | World | Environment + Lighting + Post-Process |
| **3** | Combat | Shoot + Pool + Health + Dash + Enemy |
| **4** | Polish | VFX + SFX + HUD + Game Loop |

### Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Mouse raycast kompleks di 3D | Test dengan debug draw, gunakan Plane intersect |
| Sprite3D billboard tidak natural | Adjust Billboard mode, pastikan pivot benar |
| Object pooling bugs | Implementasi simple dulu, optimize kemudian |
| Performance dengan banyak bullet | Profile early, limit max bullets di pool |
| Game feel kurang "juicy" | Iterate polish phase, playtest dengan orang lain |

---

## 7. MVP Feature List

### Must Have (Core)
- [ ] Player movement (WASD)
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
- [ ] Upgrade system
- [ ] Full Papua-themed sprites

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
| 1.2 | - | Added workflow phases, refined scope |
| 1.3 | Current | Enhanced production pipeline dengan detailed task breakdown, acceptance criteria, code snippets, phase gates |

---

*Document maintained for Project Kasuari development.*
