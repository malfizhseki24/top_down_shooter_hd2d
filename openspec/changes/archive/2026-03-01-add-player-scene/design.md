## Game Design Context

Phase 1.2 dari GDD Production Pipeline - Player Scene Assembly. Ini adalah tahap pembuatan scene structure sebelum implementasi movement dan combat logic.

## Design Goals

**Core Experience:**
Player entity yang siap menerima input dan berinteraksi dengan world.

**Goals:**
- Scene structure yang mengikuti HD-2D conventions
- Siap untuk movement script (Phase 1.3)
- Siap untuk aiming system (Phase 1.4)
- Siap untuk combat system (Phase 3)

**Non-Goals:**
- Movement implementation (Phase 1.3)
- Mouse aiming (Phase 1.4)
- Combat mechanics (Phase 3)

## Technical Design

### Player Node Structure
```
Player (CharacterBody3D)
├── AnimatedSprite3D            # Animated visual with SpriteFrames
│   └── SpriteFrames resource   # idle, running, attacking animations
├── CollisionShape3D            # Physics collision (Cylinder)
├── GunMarker3D (Node3D)        # Bullet spawn point
└── Hurtbox (Area3D)            # Untuk menerima damage (prepared for Phase 3)
```

### Component Details

**CharacterBody3D (Root)**
- Name: `Player`
- Position: (0, 0, 0) - akan di-override saat spawn
- No script yet (added in Phase 1.3)

**AnimatedSprite3D**
- Billboard Mode: `BILLBOARD_Y` (selalu menghadap kamera di sumbu Y)
- Flip H: `false` (default, akan di-control oleh script untuk arah kiri)
- Centered: `true`
- Offset: (0, 0.5, 0) - sedikit di atas ground
- Scale: (0.5, 0.5, 0.5) - adjust berdasarkan visual
- SpriteFrames: `player_frames.tres` dengan 3 animasi

**SpriteFrames Resource (`player_frames.tres`)**
- **idle**: 16 frames dari `kasuari_idle.png` (64x64 per frame)
- **running**: 16 frames dari `kasuari_running.png` (64x64 per frame)
- **attacking**: 16 frames dari `kasuari_attack.png` (64x64 per frame)
- Semua sprite menghadap kanan (east), flip_h untuk arah kiri (west)
- Frame rate: 12 FPS (adjustable)

**CollisionShape3D**
- Shape: CylinderShape3D
- Radius: 0.3 (setengah lebar character)
- Height: 1.0 (tinggi character)
- Position: (0, 0.5, 0) - center of cylinder di atas ground

**GunMarker3D (Node3D)**
- Position: (0, 0.5, 0) - di tengah body, siap untuk bullet spawn
- Akan digunakan untuk menentukan spawn point bullet

**Hurtbox (Area3D)**
- Collision Layer: Layer 6 (Player Hurtbox)
- Collision Mask: Layer 5 (Enemy Bullet Hitbox)
- Shape: Same cylinder as collision, slightly larger
- Prepared for Phase 3 combat system

### Transform Considerations

**Player Scale in 3D World:**
- Kenney Nature Kit assets menggunakan scale ~1.0
- Player should be visible but not too large
- Target: ~1 unit height, ~0.6 unit width

**Sprite3D Billboard Behavior:**
- Y-Billboard means sprite rotates on Y-axis to face camera
- Sprite remains upright (no X/Z rotation)
- Perfect for top-down view with slight angle

## Implementation Notes

### Sprite Sheet Specifications
| Animation | Source File | Dimensions | Frame Size | Frames |
|-----------|-------------|------------|------------|--------|
| idle | `kasuari_idle.png` | 1024 × 64 | 64 × 64 | 16 |
| running | `kasuari_running.png` | 1024 × 64 | 64 × 64 | 16 |
| attacking | `kasuari_attack.png` | 1024 × 64 | 64 × 64 | 16 |

### Creating SpriteFrames in Godot
1. Create new SpriteFrames resource
2. Add animation "idle", "running", "attacking"
3. For each animation:
   - Load sprite sheet
   - Set region: x=0, y=0, w=64, h=64
   - Add 16 frames (x increments by 64 each frame)
4. Set speed to 12 FPS

### Collision Layer Setup (Prepared)
```
Layer 2: Player (collision with world)
Layer 6: Player Hurtbox (receive damage from enemy bullets)
```

### Why CharacterBody3D vs RigidBody3D vs Area3D?
- **CharacterBody3D**: Best for player-controlled movement dengan collision
- Manual velocity control via `move_and_slide()`
- No physics simulation overhead
- Industry standard for player controllers

## Risks / Trade-offs

| Risk | Impact | Mitigation |
|------|--------|------------|
| Sprite tidak visible dari certain angles | Medium | Test dengan camera rotation |
| Collision shape tidak match visual | Low | Visual debug, adjust radius |
| Scale tidak match environment | Medium | Test dengan Kenney assets di scene |

## Open Questions

- [x] Apakah perlu Hurtbox sekarang? → Ya, prepare for Phase 3, minimal setup
- [x] Sprite assets? → Menggunakan Kasuari sprite sheets (idle, running, attacking)
- [x] Frame rate? → 12 FPS default, adjustable di Inspector

## References

- GDD Section 5 - Technical Specifications (Player Node Structure)
- GDD Section 6 - Phase 1.2 Player Scene Assembly
- Godot 4 Docs - CharacterBody3D, Sprite3D
