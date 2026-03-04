# Proposal: Add Hitbox/Hurtbox Collision System

**Engine**: Godot 4.x (tested with Godot 4.6)

## Summary
Implement a standardized hitbox/hurtbox system for damage detection between entities (player, enemies, projectiles) following the GDD Phase 3.3 specification. Additionally, arrows will stop/crash on world collision instead of passing through.

## Gameplay Impact
- **Combat Feel**: Clean, predictable damage interactions between entities
- **Arrow Behavior**: Arrows will stick/crash into trees, rocks, and walls rather than passing through, adding tactical depth and visual feedback
- **Invulnerability**: Enables i-frames during dash by toggling hurtbox monitoring

## Scope

### In Scope
1. **Hitbox Component** - Area3D-based component for dealing damage (player bullets, enemy attacks)
2. **Hurtbox Component** - Area3D-based component for receiving damage (player body, enemy bodies)
3. **Collision Layer Configuration** - Standardized layer setup per GDD
4. **Arrow World Collision** - Arrows stop on collision with static geometry (Layer 1: World)
5. **Damage Signal Flow** - Standardized damage communication pattern

### Out of Scope
- Health component (Phase 3.4)
- Enemy implementation (Phase 3.6)
- Dash i-frames (Phase 3.5)
- VFX for hit/collision (Phase 4.1)

## Technical Considerations
- Use Area3D for both hitbox and hurtbox (no physics blocking)
- Arrow uses existing Area3D, add Layer 1 (World) to collision_mask
- Signal-based damage flow: Hitbox -> Hurtbox -> Health (when implemented)
- Collision layers follow GDD specification

## Related GDD Section
- GDD Phase 3.3: Hitbox/Hurtbox System
- GDD Phase 3.1: Shooting Mechanics (arrow behavior extension)

## Dependencies
- Existing arrow.gd and arrow.tscn
- ObjectPool for arrow reuse
- World geometry on Layer 1 (GridMap with nature_kit)

## Risks
- Arrow collision with world may cause premature despawn if mask is too broad
- Need to ensure arrows don't collide with player's own hurtbox
