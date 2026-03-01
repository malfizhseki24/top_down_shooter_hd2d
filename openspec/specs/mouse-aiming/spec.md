# mouse-aiming Specification

## Purpose
TBD - created by archiving change add-mouse-aiming. Update Purpose after archive.
## Requirements
### Requirement: The player sprite SHALL face the mouse cursor

The player character MUST orient towards the mouse cursor position in world space, regardless of movement direction.

#### Scenario: Player aims to the right
- **Given** the game is running
- **And** the mouse cursor is to the right of the player
- **When** the aiming system updates
- **Then** the player sprite faces right (flip_h = false)

#### Scenario: Player aims to the left
- **Given** the game is running
- **And** the mouse cursor is to the left of the player
- **When** the aiming system updates
- **Then** the player sprite faces left (flip_h = true)

#### Scenario: Player moves forward while aiming backward
- **Given** the game is running
- **And** the player is moving forward (W key)
- **And** the mouse cursor is behind the player
- **When** the aiming system updates
- **Then** the player sprite faces backward (towards mouse)
- **And** the player continues moving forward

#### Scenario: Moving left while aiming right
- **Given** the player is moving left (A key)
- **And** the mouse is to the right of the player
- **When** the sprite orientation updates
- **Then** the sprite faces right (flip_h = false)
- **And** the player continues moving left

### Requirement: Mouse position SHALL be converted to world coordinates

The system MUST convert mouse screen position to world space coordinates on the X-Z plane.

#### Scenario: Mouse at screen center
- **Given** the game is running with a camera
- **When** the mouse is at the center of the screen
- **Then** the world position is calculated at Y=0 plane

#### Scenario: Mouse at screen edge
- **Given** the game is running
- **When** the mouse is at the edge of the screen
- **Then** the world position is still calculated correctly
- **And** no errors occur

