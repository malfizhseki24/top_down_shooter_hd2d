# lighting-system Specification

## Purpose
TBD - created by archiving change add-lighting-setup. Update Purpose after archive.
## Requirements
### Requirement: Directional Sun Light
The level SHALL have a primary directional light source that provides dramatic shadows and god ray atmosphere.

#### Scenario: Sun Light Configuration
- **GIVEN** a DirectionalLight3D node in the level scene
- **WHEN** the light is configured for forest atmosphere
- **THEN** the light rotation SHALL be set to a steep diagonal angle (approximately 60 degrees from vertical)
- **AND** shadow_enabled SHALL be true
- **AND** directional_shadow_mode SHALL be SHADOW_PSSM_2_SPLIT for quality
- **AND** light_color SHALL be warm white (approximately Color(1.0, 0.95, 0.9))

#### Scenario: Shadow Casting
- **GIVEN** a DirectionalLight3D with shadows enabled
- **WHEN** the scene is rendered
- **THEN** trees SHALL cast visible shadows on the ground
- **AND** rocks SHALL cast visible shadows
- **AND** shadows SHALL create depth perception for gameplay

---

### Requirement: Ambient Light Base
The level SHALL have ambient lighting that provides base illumination without flattening the scene.

#### Scenario: Ambient Configuration
- **GIVEN** a WorldEnvironment node with Environment resource
- **WHEN** ambient light is configured
- **THEN** ambient_light_source SHALL be set to AMBIENT_COLOR
- **AND** ambient_light_color SHALL be dark forest green (approximately Color(0.05, 0.1, 0.05))
- **AND** ambient_light_energy SHALL be between 0.3 and 0.5

#### Scenario: Ambient Effect
- **GIVEN** ambient light is configured
- **WHEN** the scene is viewed in shadowed areas
- **THEN** dark areas SHALL have subtle green tint
- **AND** areas SHALL NOT be pitch black
- **AND** the player SHALL remain visible in shadows

---

### Requirement: Accent Point Lights
The level SHALL have OmniLight nodes for mood accents supporting the mystical forest atmosphere.

#### Scenario: Accent Light Placement
- **GIVEN** the forest_01 level scene
- **WHEN** accent lights are placed
- **THEN** there SHALL be between 3 and 5 OmniLight nodes
- **AND** lights SHALL be positioned near visually interesting features (trees, rocks, path intersections)
- **AND** lights SHALL NOT overlap significantly in range

#### Scenario: Accent Light Configuration
- **GIVEN** an OmniLight accent node
- **WHEN** the light is configured for mood
- **THEN** light_color SHALL be subtle cyan/teal (approximately Color(0.6, 0.9, 0.9))
- **AND** light_energy SHALL be between 0.5 and 1.5
- **AND** omni_range SHALL be between 3.0 and 5.0 units
- **AND** light_negative SHALL be false

#### Scenario: Accent Light Performance
- **GIVEN** multiple OmniLight nodes in the scene
- **WHEN** the scene is rendered
- **THEN** the total OmniLight count SHALL not exceed 5
- **AND** frame rate SHALL remain at or above 60 FPS

---

### Requirement: Player Shadow Casting
The player character SHALL cast a real-time shadow on the ground for visual depth and grounding.

#### Scenario: Player Shadow Configuration
- **GIVEN** a Player node with GeometryInstance3D (CharacterBody3D)
- **WHEN** shadow casting is configured
- **THEN** cast_shadow SHALL be set to SHADOW_CASTING_SETTING_ON
- **AND** the player SHALL cast shadow on ground tiles below

#### Scenario: Player Shadow Visibility
- **GIVEN** the player is moving in the level with DirectionalLight3D shadows enabled
- **WHEN** the scene is rendered
- **THEN** the player shadow SHALL be visible on the ground
- **AND** the shadow SHALL move with the player position
- **AND** the shadow SHALL enhance player grounding perception

---

