# Proposal: add-shooting-mechanics

## Summary

Implement the core shooting mechanics for Project Kasuari, enabling the player to fire projectiles toward the mouse cursor position. This is Phase 3.1 from the GDD production pipeline.

## Motivation

Shooting is a core mechanic of the twin-stick shooter genre. The player must be able to:
- Fire bullets by clicking the left mouse button
- Bullets travel in a straight line toward the mouse cursor's world position
- Bullets have configurable speed and lifetime
- The system integrates with the existing player scene and mouse aiming

This change establishes the foundation for the combat system, which will later include hitbox/hurtbox (3.3), health (3.4), and enemy interactions (3.6).

## Scope

### In Scope
- Arrow scene (`arrow.tscn`) with Sprite3D (Y-Billboard), Area3D, and CollisionShape3D
- Arrow script with directional movement, configurable speed, and lifetime despawn
- Player combat script extension to handle shooting input and arrow spawning
- Integration with existing player scene (GunMarker node) and mouse aiming system

### Out of Scope
- Object pooling (Phase 3.2)
- Hitbox/hurtbox system (Phase 3.3)
- Health system (Phase 3.4)
- Enemy damage/death (Phase 3.6)
- Visual effects (Phase 4.1)
- Audio (Phase 4.3)

## Design

See `design.md` for architectural details including:
- Bullet node structure
- Direction calculation from GunMarker to mouse world position
- Input handling via `_input()` vs `_unhandled_input()`
- Scene instantiation pattern

## Tasks

See `tasks.md` for ordered implementation steps.

## Spec Deltas

| Spec | Change Type | Description |
|------|-------------|-------------|
| `shooting-system` | ADDED | New capability for player shooting and bullet behavior |

## Acceptance Criteria

- [ ] Player can shoot by clicking left mouse button
- [ ] Bullets spawn at GunMarker position
- [ ] Bullets travel toward mouse cursor world position
- [ ] Bullets despawn after configurable lifetime
- [ ] Bullet speed is configurable via Inspector
- [ ] No console errors or warnings
- [ ] 60 FPS maintained during shooting

## Dependencies

- **Requires**: `player-scene`, `mouse-aiming` (both complete)
- **Blocks**: `add-object-pooling`, `add-hitbox-system`, `add-health-system`

## Risks

| Risk | Mitigation |
|------|------------|
| Many arrows cause performance issues | This MVP uses simple instantiation; Phase 3.2 adds object pooling |
| Arrows spawn inside player collision | GunMarker positioned at player center; arrow collision excludes player layer |
| Direction calculation edge cases | Reuse existing `_get_mouse_world_position()` from mouse-aiming |

## References

- GDD Section 3.1: Shooting Mechanics
- GDD Code Snippet Reference (shoot implementation)
- Existing: `player_controller.gd`, `player.tscn`
