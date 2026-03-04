# post-processing Specification Delta

## MODIFIED Requirements

### Requirement: SSAO Configuration
The SSAO SHALL use tighter radius and reduced intensity to avoid visible halos on small props.

#### Scenario: Tighter SSAO Settings
- **GIVEN** a WorldEnvironment node with Environment resource
- **WHEN** SSAO is configured for polished HD-2D style
- **THEN** ssao_radius SHALL be 0.3
- **AND** ssao_intensity SHALL be 1.0
- **AND** contact shadows SHALL be visible at asset boundaries without halo artifacts

---

### Requirement: Glow Effect
The glow/bloom SHALL use tighter bloom radius to prevent excessive bleed while still enhancing god rays and VFX.

#### Scenario: Tighter Bloom Configuration
- **GIVEN** a WorldEnvironment node with Environment resource
- **WHEN** glow is configured for polished look
- **THEN** glow_enabled SHALL be true
- **AND** glow_intensity SHALL be 0.8
- **AND** glow_bloom SHALL be 0.15
- **AND** bloom SHALL enhance god rays and emissive VFX without bleeding into non-emissive geometry

---

## ADDED Requirements

### Requirement: Depth Fog
The level environment SHALL have distance-based fog that fades far objects into atmosphere, enhancing diorama depth perception.

#### Scenario: Distance Fog Configuration
- **GIVEN** a WorldEnvironment node with Environment resource
- **WHEN** fog is configured for depth
- **THEN** fog_enabled SHALL be true
- **AND** fog_density SHALL be 0.008
- **AND** fog_height SHALL be 0.5
- **AND** fog_height_density SHALL be 0.08
- **AND** fog_light_color SHALL be warm green-yellow Color(0.65, 0.7, 0.55)

#### Scenario: Depth Fog Visual Effect
- **GIVEN** depth fog is enabled
- **WHEN** the scene is rendered
- **THEN** distant tree borders SHALL show subtle atmospheric fade
- **AND** the play area center SHALL remain clear
- **AND** the fog SHALL enhance the diorama "miniature world" feeling

---

### Requirement: Chromatic Aberration
The tilt-shift post-processing shader SHALL include subtle chromatic aberration for cinematic punch.

#### Scenario: Chromatic Aberration in Tilt-Shift Shader
- **GIVEN** the tilt_shift.gdshader canvas_item shader
- **WHEN** chromatic aberration is enabled
- **THEN** the shader SHALL sample R, G, B channels at slightly offset screen UVs
- **AND** the offset SHALL scale with distance from screen center
- **AND** a `chromatic_aberration` uniform SHALL control the strength (default 0.0, forest set to 0.5)
- **AND** the effect SHALL be subtle enough to not distract from gameplay

#### Scenario: Chromatic Aberration at Screen Center
- **GIVEN** chromatic aberration is enabled
- **WHEN** viewing the screen center
- **THEN** there SHALL be zero or negligible color fringing
- **AND** the player character (typically near center) SHALL appear sharp

#### Scenario: Chromatic Aberration at Screen Edges
- **GIVEN** chromatic aberration is enabled with strength 0.5
- **WHEN** viewing the screen edges
- **THEN** there SHALL be a subtle 0.5-1.0 pixel color separation
- **AND** the effect SHALL combine naturally with the existing tilt-shift blur
