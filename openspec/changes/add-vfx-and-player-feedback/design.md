# Design: VFX & Player Damage Feedback

## Overview

This change adds visual feedback across two areas: (1) combat VFX that make hits and kills feel impactful, and (2) player HUD/feedback that communicates health state to the player.

## Architecture

### Signal Flow

```
Player takes damage:
  HurtboxComponent.damage_received
    → player._on_hurtbox_damage_received()
      → health.take_damage()
      → _play_hit_flash()           # NEW: white flash
      → _apply_knockback()          # NEW: push from source
      → _start_invulnerability()    # NEW: 0.3s i-frames
      → Events.player_damaged.emit()# NEW: notify camera + HUD
        → CameraFollow.shake()      # NEW: screen shake
        → HUD._on_player_damaged()  # NEW: damage vignette

Player dies:
  HealthComponent.died
    → player._on_player_died()
      → Events.player_died.emit()   # NEW: notify HUD
        → HUD._show_death_screen()  # NEW: death overlay

Arrow hits enemy:
  HitboxComponent.hit_hurtbox
    → arrow._on_hit_hurtbox()
      → _spawn_hit_effect()         # NEW: particle burst at impact

Enemy dies:
  enemy_base._on_died()
    → Events.enemy_killed.emit()    # Already exists
      → CameraFollow.shake()        # NEW: small shake on kill
```

### Hit Effect (GPUParticles3D)

Spawned at impact point. Short burst of white/yellow particles expanding outward. Self-destructs after 0.5s.

```
HitEffect (Node3D)
├── GPUParticles3D (burst, one_shot=true)
│   └── ParticleProcessMaterial (radial burst, gravity=0)
└── OmniLight3D (brief flash, fades out via tween)
```

### Death Effect (GPUParticles3D)

Spawned at enemy death position. Larger burst with color matching enemy. Self-destructs after 1.0s.

```
DeathEffect (Node3D)
├── GPUParticles3D (burst, one_shot=true, amount=24)
│   └── ParticleProcessMaterial (upward + outward, slight gravity)
└── OmniLight3D (bright flash, fades out)
```

### Screen Shake (Camera)

Add shake to `camera_follow.gd`:
- `shake(intensity: float, duration: float)` method
- Random offset applied in `_process` that decays over time
- Small shake on player damage (~0.15 intensity)
- Micro shake on enemy kill (~0.05 intensity)

### Health Bar (HUD)

Add to existing `hud.tscn`:
- `ProgressBar` or `TextureProgressBar` anchored top-left
- Listens to `HealthComponent.health_changed` via player reference
- Smooth tween on value change (not instant snap)
- Red flash when damage taken

### Damage Vignette

- `ColorRect` fullscreen overlay in HUD
- Briefly flashes red-transparent on `Events.player_damaged`
- Fades out over 0.3s

### Death Screen

- Overlay that appears on `Events.player_died`
- "You Died" text + Restart button
- Fades in over 0.5s
- Restart reloads current scene

### Player Damage Feedback

Mirror enemy_base.gd pattern for player:
- White flash (modulate tween) on damage
- Brief knockback from hit source
- 0.3s i-frames after taking damage
- Emit `Events.player_damaged`

## File Changes

| File | Type | Changes |
|------|------|---------|
| `scripts/player/player_controller.gd` | Modify | Hit flash, knockback, i-frames, death handling, Events emit |
| `scripts/camera/camera_follow.gd` | Modify | Add screen shake method and decay |
| `scripts/ui/hud.gd` | Modify | Health bar, damage vignette, death screen |
| `scenes/ui/hud.tscn` | Modify | Add ProgressBar, ColorRect overlay, death panel |
| `scenes/effects/hit_effect.tscn` | New | Particle burst on arrow/bullet impact |
| `scripts/effects/hit_effect.gd` | New | Self-destruct timer |
| `scenes/effects/death_effect.tscn` | New | Particle burst on enemy death |
| `scripts/effects/death_effect.gd` | New | Self-destruct timer |
| `scripts/effects/arrow.gd` | Modify | Spawn hit_effect on impact |
| `scripts/enemies/enemy_base.gd` | Modify | Spawn death_effect on death |

## Tuning Parameters

All values exposed via `@export` for designer tuning:

| Parameter | Default | Location |
|-----------|---------|----------|
| `shake_intensity_damage` | 0.15 | camera_follow.gd |
| `shake_intensity_kill` | 0.05 | camera_follow.gd |
| `shake_decay_speed` | 8.0 | camera_follow.gd |
| `player_knockback_strength` | 5.0 | player_controller.gd |
| `player_invuln_duration` | 0.3 | player_controller.gd |
| `vignette_flash_duration` | 0.3 | hud.gd |
