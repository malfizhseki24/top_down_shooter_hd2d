# post-processing Specification

## Purpose
TBD - created by archiving change add-post-processing-pipeline. Update Purpose after archive.
## Requirements
### Requirement: Tonemapper Configuration
The level environment SHALL use ACES tonemapper for cinematic high-contrast lighting.

#### Scenario: ACES Tonemapper Setting
- **GIVEN** a WorldEnvironment node with Environment resource
- **WHEN** tonemapper is configured
- **THEN** tonemap_mode SHALL be set to TONEMAPPER_ACES
- **AND** the scene SHALL exhibit cinematic high-contrast lighting

#### Scenario: Tonemapper Visual Effect
- **GIVEN** ACES tonemapper is enabled
- **WHEN** the scene is rendered with high dynamic range lighting
- **THEN** bright areas SHALL be preserved without harsh clipping
- **AND** shadow areas SHALL maintain detail
- **AND** overall contrast SHALL appear cinematic

---

### Requirement: Depth of Field Blur
The level environment SHALL have Depth of Field (DoF) effects to create cinematic depth separation between the player and background.

#### Scenario: DoF Far Blur Configuration
- **GIVEN** a WorldEnvironment node with Environment resource
- **WHEN** DoF Far blur is configured
- **THEN** dof_blur_far_enabled SHALL be true
- **AND** dof_blur_far_distance SHALL be 15.0 units
- **AND** dof_blur_far_transition SHALL be 5.0 units

#### Scenario: DoF Near Blur Configuration
- **GIVEN** a WorldEnvironment node with Environment resource
- **WHEN** DoF Near blur is configured
- **THEN** dof_blur_near_enabled SHALL be true
- **AND** dof_blur_near_distance SHALL be 5.0 units
- **AND** dof_blur_near_transition SHALL be 2.0 units

#### Scenario: DoF Blur Amount
- **GIVEN** DoF effects are enabled
- **WHEN** the blur amount is set
- **THEN** dof_blur_amount SHALL be between 0.1 and 0.2
- **AND** the blur SHALL be subtle enough not to distract from gameplay

#### Scenario: Player Focus Visibility
- **GIVEN** the player character at gameplay distance (8-10 units from camera)
- **WHEN** DoF effects are rendered
- **THEN** the player sprite SHALL remain in sharp focus
- **AND** background tiles beyond 15 units SHALL show subtle blur

---

### Requirement: Vignette Effect
The level environment SHALL have a vignette effect to focus visual attention toward the screen center.

#### Scenario: Vignette Configuration
- **GIVEN** a WorldEnvironment node with Environment resource
- **WHEN** vignette is configured
- **THEN** vignette_enabled SHALL be true
- **AND** vignette_intensity SHALL be 0.3
- **AND** vignette_stretch SHALL be between 0.2 and 0.4

#### Scenario: Vignette Visual Effect
- **GIVEN** vignette is enabled
- **WHEN** the scene is rendered
- **THEN** screen edges SHALL show subtle darkening
- **AND** the center of the screen SHALL remain bright
- **AND** gameplay visibility at screen edges SHALL NOT be impaired

---

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

### Requirement: Color Adjustments
The level environment SHALL have color adjustments to enhance visual pop and vibrancy.

#### Scenario: Adjustment Settings
- **GIVEN** a WorldEnvironment node with Environment resource
- **WHEN** color adjustments are configured
- **THEN** adjustment_enabled SHALL be true
- **AND** adjustment_contrast SHALL be 1.1
- **AND** adjustment_saturation SHALL be 1.1

#### Scenario: Adjustment Visual Effect
- **GIVEN** adjustments are enabled
- **WHEN** the scene is rendered
- **THEN** colors SHALL appear slightly more vibrant than default
- **AND** visual contrast SHALL enhance depth perception

---

### Requirement: Volumetric Fog
The level environment SHALL have subtle volumetric fog to capture dynamic light rays and enhance atmospheric depth.

#### Scenario: Volumetric Fog Configuration
- **GIVEN** a WorldEnvironment node with Environment resource
- **WHEN** volumetric fog is configured
- **THEN** volumetric_fog_enabled SHALL be true
- **AND** volumetric_fog_density SHALL be low (e.g., 0.01-0.05) for subtle effect
- **AND** volumetric_fog_albedo SHALL be set to match forest atmosphere

#### Scenario: Volumetric Fog Light Interaction
- **GIVEN** volumetric fog is enabled with DirectionalLight3D
- **WHEN** light rays pass through the fog volume
- **THEN** god ray effects SHALL be visible through tree canopy gaps
- **AND** OmniLight point lights SHALL create volumetric light cones
- **AND** the fog SHALL enhance mystical forest atmosphere

#### Scenario: Volumetric Fog Performance
- **GIVEN** volumetric fog is enabled
- **WHEN** the scene is rendered
- **THEN** frame rate impact SHALL be acceptable
- **AND** fog density SHALL be tuned to balance visual quality vs performance

---

### Requirement: Pixel-Perfect Texture Filtering
The project SHALL use nearest-neighbor texture filtering to preserve pixel art crispness.

#### Scenario: Default Texture Filter Setting
- **GIVEN** project rendering settings
- **WHEN** texture filter mode is configured
- **THEN** rendering/textures/default_texture_filter SHALL be set to NEAREST
- **AND** pixel art assets SHALL render with sharp edges

#### Scenario: GridMap Texture Crispness
- **GIVEN** GridMap with Kenney nature kit assets
- **WHEN** textures are rendered with nearest filtering
- **THEN** ground tiles SHALL show crisp pixel edges
- **AND** no bilinear blur SHALL be visible on terrain

#### Scenario: Sprite Texture Crispness
- **GIVEN** Sprite3D nodes with pixel art sprites
- **WHEN** textures are rendered with nearest filtering
- **THEN** character sprites SHALL show crisp pixel edges
- **AND** no blurry interpolation SHALL occur during sprite scaling

---

### Requirement: Sprite3D Material Configuration
Sprite3D nodes SHALL use materials configured for proper DoF behavior and shadow interaction with 3D lighting.

#### Scenario: Alpha Scissor for DoF Compatibility
- **GIVEN** a Sprite3D node with transparent sprite
- **WHEN** material is configured for post-processing
- **THEN** the material SHALL use Alpha Scissor or Alpha Hash transparency
- **AND** alpha_scissor_threshold SHALL be set appropriately (e.g., 0.5)
- **AND** DoF blur SHALL NOT cause alpha-bleeding artifacts on sprite edges

#### Scenario: Sprite Shadow Casting
- **GIVEN** a Sprite3D node representing player or character
- **WHEN** shadow configuration is set
- **THEN** cast_shadow SHALL be set to SHADOW_CASTING_SETTING_ON
- **AND** the sprite SHALL cast visible shadow on ground tiles
- **AND** the shadow SHALL respond to DirectionalLight3D position

#### Scenario: Sprite Shadow Receiving
- **GIVEN** a Sprite3D node in the scene
- **WHEN** shadow receiving is enabled
- **THEN** receive_shadow SHALL be true (default)
- **AND** the sprite SHALL be darkened when in shadowed areas
- **AND** visual consistency with 3D environment SHALL be maintained

---

### Requirement: Camera Mode for DoF
The camera configuration SHALL be evaluated for optimal Depth of Field behavior in HD-2D aesthetic.

#### Scenario: Orthographic Camera DoF Test
- **GIVEN** the current Orthographic camera setup
- **WHEN** DoF effects are applied
- **THEN** DoF blur behavior SHALL be documented
- **AND** visual quality SHALL be evaluated for HD-2D style

#### Scenario: Perspective Camera DoF Test
- **GIVEN** a Perspective camera with FOV 20-30 degrees
- **WHEN** DoF effects are applied
- **THEN** DoF blur behavior SHALL be documented
- **AND** depth perception SHALL be compared to Orthographic mode
- **AND** the optimal camera mode for HD-2D SHALL be selected

---

### Requirement: Post-Processing Performance
All post-processing effects SHALL maintain target frame rate for smooth gameplay.

#### Scenario: Frame Rate Target
- **GIVEN** all post-processing effects are enabled
- **WHEN** the scene is rendered with typical gameplay load
- **THEN** frame rate SHALL be at or above 60 FPS
- **AND** no frame stuttering SHALL occur during camera movement

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

