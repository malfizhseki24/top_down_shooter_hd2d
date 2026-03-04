# camera-system Specification Delta

## ADDED Requirements

### Requirement: Camera Shake on Shoot
The camera SHALL apply a subtle screen shake when the player fires a projectile, adding tactile weight to shooting.

#### Scenario: Shoot triggers camera shake
- **GIVEN** the player presses the shoot action
- **WHEN** a bullet is spawned
- **THEN** the camera SHALL apply a small shake (intensity ~0.03)
- **AND** the shake SHALL decay rapidly and not obscure aiming

---

### Requirement: Camera Shake on Dash
The camera SHALL apply a very subtle screen shake when the player dashes, reinforcing the burst of movement.

#### Scenario: Dash triggers camera shake
- **GIVEN** the player presses the dash action
- **WHEN** the dash state begins
- **THEN** the camera SHALL apply a subtle shake (intensity ~0.04)
- **AND** the shake SHALL decay quickly and feel like a speed kick

---

### Requirement: Camera Bounds Clamping
The camera SHALL support configurable spatial bounds that prevent it from scrolling beyond the playable map area, so the player never sees empty space outside the level.

#### Scenario: Camera stops at map edge
- **GIVEN** `use_bounds` is enabled with `bounds_min` and `bounds_max` configured
- **AND** the player moves toward a map boundary
- **WHEN** the camera follow position would expose area beyond the bounds
- **THEN** the camera position SHALL be clamped so the viewport edge aligns with the bound limit
- **AND** the player MAY continue moving freely within the level

#### Scenario: Bounds account for orthographic half-extents
- **GIVEN** the camera is orthographic with a configurable `size`
- **WHEN** bounds clamping is applied
- **THEN** the clamp SHALL account for the camera's visible half-width and half-height
- **AND** the viewport edge (not the camera center) SHALL align with the bound

#### Scenario: Bounds disabled by default
- **GIVEN** a fresh CameraFollow instance
- **WHEN** no bounds are configured
- **THEN** `use_bounds` SHALL default to false
- **AND** the camera SHALL follow the target without any spatial limits
