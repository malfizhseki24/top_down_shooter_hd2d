# Proposal: Add Player Dash Mechanic

**Engine**: Godot 4.x (tested with Godot 4.6)

## Why
The dash mechanic is a core gameplay element for the twin-stick shooter, allowing players to evade enemy attacks and reposition quickly. This implements GDD Phase 3.5.

## What Changes
- Add dash functionality to PlayerController
- Play "dash" animation from existing player_frames.tres (8 frames, speed 5.0, looped)
- Implement i-frames (invulnerability) during dash by disabling hurtbox
- Add dash cooldown to prevent spam

## Gameplay Impact
- **Evasion**: Player can dash through enemies and projectiles
- **Positioning**: Quick repositioning during combat
- **Risk/Reward**: Dash has cooldown, must be used strategically

## Scope

### In Scope
1. Dash input handling (Space key - already mapped per project-architecture spec)
2. Dash velocity burst in movement direction
3. Dash animation playback
4. I-frames via hurtbox monitoring toggle
5. Dash cooldown system
6. Dash direction handling (use last movement direction or facing direction)

### Out of Scope
- Dash trail VFX (Phase 4.1)
- Dash SFX (Phase 4.3)
- Multiple dashes (air dash, etc.)
- Upgrades affecting dash

## Technical Considerations
- Use state machine pattern (NORMAL, DASHING) as suggested in GDD
- Existing "dash" animation has 8 frames at speed 5.0 (~1.6s total)
- Dash duration should be shorter than animation for responsive feel
- Hurtbox already exists in player.tscn at `$Hurtbox`
- Input mapping already exists: `dash` → Space

## Dependencies
- Existing PlayerController script
- Existing "dash" animation in player_frames.tres
- Existing Hurtbox Area3D in player.tscn

## Risks
- Dash animation is looped; need to handle animation stop correctly
- Animation duration (8 frames / 5.0 speed = 1.6s) may be too long for gameplay feel
