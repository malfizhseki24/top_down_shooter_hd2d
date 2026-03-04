# basic-enemy Specification

## Purpose
TBD - created by archiving change add-basic-enemy. Update Purpose after archive.
## Requirements
### Requirement: Enemy SHALL follow the player

The enemy MUST move toward the player's position using simple follow AI.

#### Scenario: Enemy moves toward player
- **Given** an enemy is spawned in the scene
- **And** a player exists in the scene
- **When** the enemy is not at the player's position
- **Then** the enemy SHALL move toward the player
- **And** the enemy SHALL move at the configured move_speed

#### Scenario: Enemy stops at obstacles
- **Given** an enemy is moving toward the player
- **And** a wall is between the enemy and player
- **When** the enemy reaches the wall
- **Then** the enemy SHALL NOT pass through the wall
- **And** collision physics SHALL apply

---

### Requirement: Enemy SHALL have configurable movement and health

Enemy parameters MUST be adjustable via Inspector for game balancing.

#### Scenario: Move speed is configurable
- **Given** a designer opens the enemy scene in Inspector
- **When** the designer modifies the Move Speed property
- **Then** the enemy SHALL move at the new speed
- **And** the default move speed SHALL be 3.0 units per second

#### Scenario: Max health is configurable
- **Given** a designer opens the enemy scene in Inspector
- **When** the designer modifies the Max Health property
- **Then** the enemy SHALL die after that many hits
- **And** the default max health SHALL be 3

---

### Requirement: Enemy SHALL receive damage from player projectiles

The enemy MUST use HurtboxComponent to receive damage from arrows.

#### Scenario: Arrow damages enemy
- **Given** an enemy with HurtboxComponent
- **And** the hurtbox is on Layer 7 (EnemyHurtbox)
- **And** an arrow with HitboxComponent configured to detect Layer 7
- **When** the arrow overlaps the enemy hurtbox
- **Then** the enemy SHALL receive damage
- **And** the enemy health SHALL decrease

#### Scenario: Enemy dies when health depleted
- **Given** an enemy with current health of 1
- **When** the enemy receives 1 damage
- **Then** the enemy SHALL emit the `died` signal
- **And** the enemy SHALL be removed from the scene

---

### Requirement: Enemy sprite SHALL flip based on movement direction

The enemy sprite MUST face the direction of movement for visual consistency.

#### Scenario: Sprite faces right when moving right
- **Given** an enemy is moving in the +X direction
- **When** the velocity.x is positive
- **Then** the AnimatedSprite3D flip_h SHALL be false

#### Scenario: Sprite faces left when moving left
- **Given** an enemy is moving in the -X direction
- **When** the velocity.x is negative
- **Then** the AnimatedSprite3D flip_h SHALL be true

---

### Requirement: Enemy SHALL use HD-2D visual style

The enemy MUST follow the same visual conventions as the player for consistency.

#### Scenario: Enemy uses Y-Billboard mode
- **Given** an enemy with AnimatedSprite3D
- **Then** the billboard mode SHALL be set to Y
- **And** the sprite SHALL always face the camera horizontally

#### Scenario: Enemy sprite faces right by default
- **Given** an enemy spritesheet
- **Then** the default orientation SHALL be facing right (+X direction)
- **And** flip_h SHALL be used for left-facing orientation

