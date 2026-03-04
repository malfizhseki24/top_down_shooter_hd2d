# Proposal: Add Basic Enemy

**Engine**: Godot 4.x (tested with Godot 4.6)

## Why
Implements GDD Phase 3.6 - Basic Enemy. The enemy is required to complete the combat loop, allowing the player to shoot and kill targets. This enables full gameplay testing of the twin-stick shooter mechanics.

## What Changes
- Create enemy sprite folder structure at `assets/sprites/enemies/` for spritesheet placement
- Create `enemy_base.tscn` scene with CharacterBody3D, AnimatedSprite3D, collision, and components
- Create `enemy_base.gd` script with follow-player AI behavior
- Create `enemy_frames.tres` SpriteFrames resource for enemy animations
- Enemy uses existing HitboxComponent and HurtboxComponent for damage system
- Enemy follows player using simple move_toward logic
- Enemy dies (queue_free) when health reaches 0

## Gameplay Impact
- **Target Practice**: Player has something to shoot at
- **Combat Loop**: Enables full shoot → hit → kill → repeat cycle
- **Testing**: Allows balancing of damage values and movement speeds

## Scope

### In Scope
1. Enemy sprite folder structure (`assets/sprites/enemies/basic/` for spritesheets)
2. Enemy scene with CharacterBody3D, AnimatedSprite3D (Y-Billboard), CollisionShape3D
3. HurtboxComponent for receiving damage from player arrows
4. Basic AI that follows player using move_toward
5. Death handling when health depleted
6. Configurable export variables (move_speed, max_health)
7. Sprite flip based on movement direction (like player)

### Out of Scope
- Enemy spawning system (future phase)
- Enemy attacks/projectiles
- Multiple enemy types
- Enemy animations beyond idle (for MVP placeholder)
- Wave system
- Score tracking

## Technical Considerations
- Reuse existing HurtboxComponent for damage reception
- Follow same HD-2D pattern as player (AnimatedSprite3D with Y-Billboard)
- Use collision Layer 3 (Enemy) and Layer 7 (EnemyHurtbox)
- Simple follow AI without pathfinding (straight line to player)
- Enemy should NOT have a HitboxComponent (melee contact damage is out of scope)

## Dependencies
- Existing HurtboxComponent (`scenes/components/hurtbox_component.tscn`)
- Existing collision system (Layer 3: Enemy, Layer 7: EnemyHurtbox)
- Player must exist in scene for enemy to follow
- Arrow HitboxComponent must be configured to detect EnemyHurtbox (already done)

## Risks
- Enemy may get stuck on obstacles (no pathfinding for MVP)
- Balance tuning needed for move_speed vs player dash
- Placeholder sprite needed until final art is ready
