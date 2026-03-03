# shooting-system Specification

## Purpose

Defines the player shooting mechanics for the twin-stick shooter gameplay. Players fire projectiles toward the mouse cursor position using the left mouse button. This system provides the foundation for combat interactions.

## ADDED Requirements

### Requirement: Player SHALL fire arrows on left mouse click

The player MUST be able to shoot projectiles by pressing the left mouse button (shoot action).

#### Scenario: Player clicks left mouse button
- **Given** the game is running
- **And** the player scene is loaded
- **When** the player presses the left mouse button
- **Then** an arrow SHALL spawn at the GunMarker position
- **And** the arrow SHALL travel toward the mouse cursor world position

#### Scenario: Player holds left mouse button
- **Given** the player is holding the left mouse button
- **When** the shoot cooldown has elapsed
- **Then** another arrow SHALL spawn
- **And** arrows SHALL NOT spawn faster than the cooldown allows

#### Scenario: Shoot cooldown prevents spam
- **Given** the player just fired an arrow
- **And** the shoot cooldown is 0.15 seconds
- **When** the player clicks again within 0.15 seconds
- **Then** no arrow SHALL spawn
- **And** the next arrow SHALL spawn after cooldown expires

---

### Requirement: Arrows SHALL travel in a straight line toward target

Arrows MUST move in a straight line from spawn position toward the mouse world position at a configurable speed.

#### Scenario: Arrow moves toward mouse position
- **Given** an arrow has spawned
- **And** the mouse is to the right of the player
- **When** the arrow moves
- **Then** the arrow SHALL travel to the right
- **And** the arrow SHALL NOT change direction

#### Scenario: Arrow speed is configurable
- **Given** a designer opens the arrow scene in Inspector
- **When** the designer modifies the Speed property
- **Then** arrows SHALL move at the new speed
- **And** the default speed SHALL be 15.0 units per second

#### Scenario: Arrow stays on X-Z plane
- **Given** an arrow has spawned
- **When** the arrow moves
- **Then** the arrow Y position SHALL remain constant
- **And** movement SHALL only occur on X and Z axes

---

### Requirement: Arrows SHALL despawn after lifetime expires

Arrows MUST be removed from the scene after a configurable lifetime to prevent memory accumulation.

#### Scenario: Arrow despawns after lifetime
- **Given** an arrow has spawned
- **And** the arrow lifetime is 3.0 seconds
- **When** 3.0 seconds have elapsed
- **Then** the arrow SHALL be removed from the scene
- **And** no memory leak SHALL occur

#### Scenario: Arrow lifetime is configurable
- **Given** a designer opens the arrow scene in Inspector
- **When** the designer modifies the Lifetime property
- **Then** arrows SHALL despawn after the new lifetime
- **And** the default lifetime SHALL be 3.0 seconds

---

### Requirement: Arrows SHALL use Area3D for collision detection

Arrows MUST use Area3D to detect overlaps with enemy hurtboxes without physics blocking.

#### Scenario: Arrow spawns with correct collision layer
- **Given** an arrow scene is created
- **When** the arrow spawns
- **Then** the arrow SHALL be on Layer 4 (Player Projectile)
- **And** the arrow collision_layer SHALL be 8

#### Scenario: Arrow detects enemy hurtboxes
- **Given** an arrow is traveling
- **And** an enemy hurtbox exists on Layer 7
- **When** the arrow overlaps the hurtbox
- **Then** the area_entered signal SHALL be emitted
- **And** the arrow collision_mask SHALL include Layer 7 (value 64)

---

### Requirement: Arrow visuals SHALL face the camera

Arrows MUST use Sprite3D with Y-Billboard mode for HD-2D aesthetic consistency.

#### Scenario: Arrow sprite faces camera
- **Given** an arrow has spawned with Sprite3D
- **When** the camera moves or rotates
- **Then** the arrow sprite SHALL always face the camera on Y-axis
- **And** the sprite SHALL remain upright

#### Scenario: Arrow has visible placeholder
- **Given** an arrow spawns in the game
- **When** the arrow is in the camera view
- **Then** a visible sprite SHALL be rendered
- **And** the arrow length SHALL be ~0.4 units (proportional to player height of 0.6 units)
- **And** the arrow width SHALL be ~0.08 units (slender projectile appearance)

---

## Cross-References

- **player-scene**: Provides GunMarker for arrow spawn position
- **mouse-aiming**: Provides `_get_mouse_world_position()` for direction calculation
- **project-architecture**: Defines collision layer conventions
