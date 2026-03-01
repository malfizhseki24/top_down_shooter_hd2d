# camera-system

Camera system with smooth follow for top-down view. Camera follows the player with configurable smoothing.

## ADDED Requirements

### Requirement: The camera SHALL smoothly follow the target

The camera MUST follow the assigned target with lerp-based interpolation for smooth movement.

#### Scenario: Camera follows moving player
- **Given** the camera has a target assigned
- **And** the target is moving
- **When** the camera updates
- **Then** the camera position moves towards the target position
- **And** the movement is smooth (interpolated)

#### Scenario: Camera stops when target stops
- **Given** the camera is following a target
- **And** the target stops moving
- **When** the camera updates
- **Then** the camera gradually reaches the target position
- **And** the camera becomes stationary

### Requirement: Camera smoothing speed SHALL be configurable

The smoothing speed MUST be adjustable via the Inspector for game feel tuning.

#### Scenario: Designer adjusts smoothing speed
- **Given** the camera scene is open in the editor
- **When** the designer changes the Smoothing Speed property
- **Then** the new speed value is used for interpolation

#### Scenario: Default smoothing speed is set
- **Given** a fresh camera follow instance
- **When** no speed has been configured
- **Then** the smoothing speed defaults to 5.0

### Requirement: Camera offset SHALL be configurable

The camera offset from the target MUST be adjustable for different viewing angles.

#### Scenario: Camera maintains offset from target
- **Given** the camera has an offset configured
- **When** the camera follows the target
- **Then** the camera maintains the configured offset distance
- **And** the offset is added to the target position
