# player-movement Specification

## Purpose
TBD - created by archiving change add-player-movement. Update Purpose after archive.
## Requirements
### Requirement: The player SHALL move using WASD inputs

The player character MUST respond to keyboard input for movement in the X-Z plane (top-down view).

#### Scenario: Player presses W to move forward
- **Given** the game is running
- **When** the player presses and holds the W key
- **Then** the player character moves in the negative Z direction
- **And** the movement speed equals the configured movement_speed value

#### Scenario: Player presses S to move backward
- **Given** the game is running
- **When** the player presses and holds the S key
- **Then** the player character moves in the positive Z direction

#### Scenario: Player presses A to move left
- **Given** the game is running
- **When** the player presses and holds the A key
- **Then** the player character moves in the negative X direction

#### Scenario: Player presses D to move right
- **Given** the game is running
- **When** the player presses and holds the D key
- **Then** the player character moves in the positive X direction

#### Scenario: Player presses diagonal combination
- **Given** the game is running
- **When** the player presses W and D simultaneously
- **Then** the player character moves diagonally (negative Z, positive X)
- **And** the movement speed is normalized (not faster than cardinal directions)

### Requirement: Movement speed SHALL be configurable via Inspector

The player's movement speed MUST be adjustable via the Inspector for game balancing.

#### Scenario: Designer adjusts movement speed in Inspector
- **Given** the player scene is open in the editor
- **When** the designer changes the Movement Speed property
- **Then** the new speed value is used when the game runs

#### Scenario: Default movement speed is set
- **Given** a fresh player controller instance
- **When** no speed has been configured
- **Then** the movement speed defaults to 5.0 units per second

### Requirement: Player SHALL collide with world geometry

The player MUST use collision detection to prevent moving through solid objects.

#### Scenario: Player moves against a wall
- **Given** the player is next to a solid wall
- **When** the player tries to move into the wall
- **Then** the player slides along the wall instead of passing through

