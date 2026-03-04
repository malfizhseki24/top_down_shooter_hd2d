# player-dash Specification

## Purpose
TBD - created by archiving change add-player-dash. Update Purpose after archive.
## Requirements
### Requirement: Player SHALL dash when pressing Space key

The player MUST perform a quick dash movement when the dash input is pressed and cooldown is ready.

#### Scenario: Player dashes with Space key
- **Given** the player is in NORMAL state
- **And** dash cooldown has expired
- **When** the player presses Space
- **Then** the player SHALL enter DASHING state
- **And** the player SHALL move quickly in dash direction
- **And** the "dash" animation SHALL play

#### Scenario: Dash is blocked during cooldown
- **Given** the player has just finished a dash
- **And** dash cooldown has not expired
- **When** the player presses Space
- **Then** nothing SHALL happen
- **And** the player remains in NORMAL state

#### Scenario: Dash direction follows movement input
- **Given** the player is moving right (D key held)
- **When** the player presses Space
- **Then** the dash direction SHALL be to the right
- **And** the player moves quickly to the right

#### Scenario: Dash direction uses facing direction when standing still
- **Given** the player is standing still (no movement input)
- **And** the player sprite is facing left
- **When** the player presses Space
- **Then** the dash direction SHALL be left
- **And** the player moves quickly to the left

---

### Requirement: Dash SHALL have configurable speed and duration

Dash parameters MUST be adjustable via Inspector for game balancing.

#### Scenario: Dash speed is configurable
- **Given** a designer opens the player scene in Inspector
- **When** the designer modifies the Dash Speed property
- **Then** dashes SHALL move at the new speed
- **And** the default dash speed SHALL be 15.0 units per second

#### Scenario: Dash duration is configurable
- **Given** a designer opens the player scene in Inspector
- **When** the designer modifies the Dash Duration property
- **Then** dashes SHALL last for the new duration
- **And** the default dash duration SHALL be 0.2 seconds

#### Scenario: Dash cooldown is configurable
- **Given** a designer opens the player scene in Inspector
- **When** the designer modifies the Dash Cooldown property
- **Then** the time between dashes SHALL be the new cooldown
- **And** the default dash cooldown SHALL be 0.5 seconds

---

### Requirement: Player SHALL be invulnerable during dash

The player's hurtbox MUST be disabled during dash to provide i-frames.

#### Scenario: Hurtbox disabled during dash
- **Given** the player starts a dash
- **When** the player enters DASHING state
- **Then** the Hurtbox monitoring SHALL be disabled
- **And** the player SHALL NOT receive damage from enemies

#### Scenario: Hurtbox re-enabled after dash
- **Given** the player is in DASHING state
- **When** the dash duration expires
- **Then** the Hurtbox monitoring SHALL be re-enabled
- **And** the player CAN receive damage from enemies

#### Scenario: Dash passes through enemy attacks
- **Given** an enemy projectile is traveling toward the player
- **And** the player starts dashing
- **When** the projectile reaches the player's position
- **Then** the projectile SHALL NOT damage the player
- **And** the player continues dashing

---

### Requirement: Dash animation SHALL play during dash

The "dash" animation from player_frames.tres MUST play when dashing.

#### Scenario: Dash animation starts on dash
- **Given** the player is in NORMAL state
- **When** the player presses Space
- **Then** the AnimatedSprite3D SHALL play the "dash" animation
- **And** the animation plays at configured speed (5.0 FPS)

#### Scenario: Animation returns to appropriate state after dash
- **Given** the player is in DASHING state
- **When** the dash duration expires
- **And** the player has no movement input
- **Then** the animation SHALL switch to "idle"

#### Scenario: Animation returns to running after dash while moving
- **Given** the player is in DASHING state
- **And** the player has movement input (WASD held)
- **When** the dash duration expires
- **Then** the animation SHALL switch to "running"

