# combat-vfx Specification

## Purpose
TBD - created by archiving change add-vfx-and-player-feedback. Update Purpose after archive.
## Requirements
### Requirement: Arrow impact SHALL spawn a hit effect

When an arrow hits an enemy hurtbox or world geometry, a particle burst SHALL appear at the impact point.

#### Scenario: Arrow hits enemy
- **Given** a player arrow traveling toward an enemy
- **When** the arrow's hitbox overlaps an enemy hurtbox
- **Then** a hit_effect particle burst SHALL spawn at the arrow's position
- **And** the effect SHALL self-destruct after 0.5 seconds
- **And** the particles SHALL burst outward in a radial pattern

#### Scenario: Arrow hits world geometry
- **Given** a player arrow traveling toward a wall or tree
- **When** the arrow collides with a StaticBody3D
- **Then** a hit_effect particle burst SHALL spawn at the arrow's position

---

### Requirement: Enemy death SHALL spawn a death effect

When an enemy's health reaches zero, a death particle effect SHALL appear at the enemy's position.

#### Scenario: Enemy dies from player arrow
- **Given** an enemy with 1 health remaining
- **When** the enemy takes 1 damage and health reaches 0
- **Then** a death_effect particle burst SHALL spawn at the enemy's position
- **And** the effect SHALL be larger than the hit_effect
- **And** the effect SHALL self-destruct after 1.0 second

---

### Requirement: Camera SHALL shake on combat events

The camera SHALL apply screen shake to convey impact on damage and kill events.

#### Scenario: Player takes damage
- **Given** a player that receives damage from an enemy projectile
- **When** Events.player_damaged is emitted
- **Then** the camera SHALL shake with intensity ~0.15
- **And** the shake SHALL decay smoothly over ~0.2 seconds

#### Scenario: Enemy is killed
- **Given** an enemy that dies
- **When** Events.enemy_killed is emitted
- **Then** the camera SHALL shake with intensity ~0.05
- **And** the shake SHALL be subtle but noticeable

#### Scenario: Shake decays smoothly
- **Given** a camera shake is active
- **When** time passes
- **Then** the shake offset SHALL decay toward zero using lerp
- **And** the camera SHALL return to smooth follow after shake ends

---

### Requirement: Player SHALL receive visual feedback on damage

The player character SHALL flash white, receive knockback, and gain brief invulnerability when hit.

#### Scenario: Player hit flash
- **Given** a player that takes damage
- **When** the hurtbox receives damage from an enemy hitbox
- **Then** the player sprite modulate SHALL tween to bright white
- **And** the modulate SHALL return to normal over ~0.15 seconds

#### Scenario: Player knockback
- **Given** a player that takes damage from an enemy projectile
- **When** the damage is received
- **Then** a velocity impulse SHALL push the player away from the damage source
- **And** the knockback SHALL decay smoothly over time

#### Scenario: Player invulnerability after damage
- **Given** a player that just took damage
- **When** the i-frame period is active (~0.3 seconds)
- **Then** the player hurtbox SHALL be disabled
- **And** subsequent hits SHALL be ignored
- **And** the hurtbox SHALL re-enable after the duration

---

### Requirement: Player death SHALL emit Events.player_died

When the player's health reaches zero, the game SHALL emit a global event.

#### Scenario: Player health reaches zero
- **Given** a player with 1 health remaining
- **When** the player takes 1 damage
- **Then** Events.player_died SHALL be emitted
- **And** the player SHALL be visually indicated as dead (fade or freeze)

---

### Requirement: Player damage SHALL emit Events.player_damaged

When the player takes damage, the game SHALL emit a global event with the damage amount.

#### Scenario: Player takes damage from enemy bullet
- **Given** a player that receives damage
- **When** health.take_damage is called
- **Then** Events.player_damaged SHALL be emitted with the damage amount
- **And** listening systems (camera, HUD) SHALL react

---

### Requirement: Hit Pause on Impact
The game SHALL briefly freeze (hit pause) when significant combat events occur to emphasize impact.

#### Scenario: Hit Pause on Player Damage
- **GIVEN** the player takes damage from an enemy or projectile
- **WHEN** the damage event fires
- **THEN** Engine.time_scale SHALL be set to 0.0 for approximately 50ms (3 frames at 60fps)
- **AND** all game objects SHALL freeze during the pause
- **AND** a recovery timer with process_mode PROCESS_MODE_ALWAYS SHALL restore time_scale to 1.0
- **AND** the screen shake SHALL trigger after the pause ends

#### Scenario: Hit Pause on Enemy Kill
- **GIVEN** an enemy's health reaches zero from a player attack
- **WHEN** the enemy_killed event fires
- **THEN** Engine.time_scale SHALL be set to 0.05 for approximately 30ms (shorter than player damage)
- **AND** the brief slowdown SHALL emphasize the kill
- **AND** time_scale SHALL return to 1.0 smoothly

#### Scenario: Hit Pause Does Not Stack
- **GIVEN** a hit pause is already active (Engine.time_scale < 1.0)
- **WHEN** another combat event fires
- **THEN** the pause SHALL extend to the longer duration
- **AND** multiple pauses SHALL NOT compound (time_scale stays at the floor value)

#### Scenario: Hit Pause Does Not Break Timers
- **GIVEN** hit pause sets Engine.time_scale to 0.0
- **WHEN** the freeze duration elapses
- **THEN** all tweens SHALL resume correctly
- **AND** all particle systems SHALL resume correctly
- **AND** no gameplay state SHALL be corrupted by the pause

