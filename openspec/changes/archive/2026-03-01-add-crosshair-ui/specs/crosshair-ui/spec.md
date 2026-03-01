# crosshair-ui Specification

## Purpose
Crosshair UI memberikan visual feedback untuk mouse aiming di twin-stick shooter, menunjukkan posisi target pada layar.

## ADDED Requirements

### Requirement: Crosshair SHALL follow mouse position

The crosshair visual MUST be positioned at the current mouse cursor location on screen.

#### Scenario: Mouse at screen center
- **Given** the HUD scene is loaded
- **And** the mouse is at the center of the screen
- **When** the crosshair position updates
- **Then** the crosshair is displayed at the screen center

#### Scenario: Mouse movement
- **Given** the game is running
- **When** the player moves the mouse
- **Then** the crosshair follows the mouse position immediately
- **And** there is no visible lag

#### Scenario: Mouse at screen edges
- **Given** the game is running
- **When** the mouse is at any screen edge
- **Then** the crosshair remains visible
- **And** the crosshair stays within screen bounds

### Requirement: Default mouse cursor SHALL be hidden

The OS default mouse cursor MUST be hidden when the game HUD is active, replaced by the custom crosshair.

#### Scenario: HUD loads
- **Given** the HUD scene is instantiated
- **When** _ready() is called
- **Then** the OS mouse cursor is hidden
- **And** only the custom crosshair is visible

#### Scenario: HUD cleanup
- **Given** the HUD scene is being removed
- **When** _exit_tree() is called
- **Then** the OS mouse cursor is restored to visible

### Requirement: Crosshair SHALL render above 3D content

The crosshair MUST always be visible on top of all 3D game elements.

#### Scenario: Crosshair over 3D object
- **Given** the game is running with 3D environment
- **And** the mouse is over a 3D tree or enemy
- **When** rendering the frame
- **Then** the crosshair is visible on top of the 3D object
- **And** no z-fighting or occlusion occurs

## Related Capabilities
- `mouse-aiming` - Crosshair visual mendukung aiming mechanic
