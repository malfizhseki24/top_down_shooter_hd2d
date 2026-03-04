# Proposal: Add VFX & Player Damage Feedback

## Summary

Implements GDD Phase 4.1 (Visual Effects) plus player damage feedback systems that are currently missing. Enemies already have hit flash, knockback, death animations, and spawn effects — the player has **none**. Additionally, there is no health bar UI, no screen shake, no hit/death particle effects, and no arrow impact VFX.

## Motivation

- **Player has zero damage feedback**: taking a hit is invisible — no flash, no shake, no knockback, no UI indication
- **No health bar**: player has 10 HP but no way to see it on screen
- **No impact VFX**: arrows and bullets disappear on hit with no visual payoff
- **No screen shake**: combat lacks weight and impact
- **No death handling**: player death only prints to console

## Scope

### Two new specs:

1. **combat-vfx** — Hit effects, death effects, arrow trail, screen shake
2. **player-hud** — Health bar, damage vignette, death screen

### Systems touched:

| System | Changes |
|--------|---------|
| Player (`player_controller.gd`) | Hit flash, knockback, i-frames on damage, death handling, emit Events |
| Camera (`camera_follow.gd`) | Screen shake on damage/kill |
| HUD (`hud.tscn`, `hud.gd`) | Health bar, damage vignette overlay, death screen |
| Effects (new scenes) | `hit_effect.tscn`, `death_effect.tscn` |
| Arrow (`arrow.gd`) | Spawn hit_effect on impact |
| Events (`events.gd`) | Emit `player_damaged`, `player_died` |

### Out of scope:

- Audio/SFX (separate Phase 4.3)
- Score counter, wave UI (separate Phase 4.4/4.5)
- Dash trail particles (already has visual via animation)

## Gameplay Impact

- **Feel**: Combat becomes visceral — every hit and kill has visual weight
- **Readability**: Player can see their health and react to damage
- **Fairness**: Player gets visual warning when hit (flash + shake)
- **Satisfaction**: Kill effects make combat rewarding

## Technical Considerations

- Particle effects use GPUParticles3D (consistent with existing enemy_bullet trail)
- Screen shake uses camera offset (no additional nodes needed)
- Health bar uses existing `health.get_health_percent()` and `health_changed` signal
- Hit effects are short-lived scenes spawned at impact point then queue_free
- All VFX use existing Events bus for decoupled spawning
