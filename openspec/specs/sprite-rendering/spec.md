# sprite-rendering Specification

## Purpose
TBD - created by archiving change polish-hd2d-visual-effects. Update Purpose after archive.
## Requirements
### Requirement: Sprite Rim Light Shader
AnimatedSprite3D nodes for player and enemies SHALL use a spatial shader that adds a directional rim light glow at sprite silhouette edges.

#### Scenario: Rim Light Edge Detection
- **GIVEN** an AnimatedSprite3D with the rim light shader applied
- **WHEN** the sprite is rendered
- **THEN** pixels near the alpha boundary (silhouette edge) SHALL receive an additive glow
- **AND** the edge detection SHALL sample neighboring texels to find alpha transitions
- **AND** interior pixels (fully surrounded by opaque pixels) SHALL NOT receive rim glow

#### Scenario: Rim Light Color and Intensity
- **GIVEN** the rim light shader is active on a sprite
- **WHEN** the rim light parameters are configured
- **THEN** `rim_color` uniform SHALL default to warm white Color(1.0, 0.95, 0.85)
- **AND** `rim_intensity` uniform SHALL default to 0.5 (range 0.0-2.0)
- **AND** `rim_width` uniform SHALL default to 1.5 (texel radius, range 0.5-3.0)
- **AND** the rim light SHALL be visible on both lit and shadowed sides of the sprite

#### Scenario: Rim Light Direction Bias
- **GIVEN** the rim light shader has a direction bias parameter
- **WHEN** the light direction is configured
- **THEN** `rim_direction` uniform SHALL bias the rim glow toward the upper-left (matching sun direction)
- **AND** the bias SHALL be subtle — not fully directional, but weighted (e.g., 60% top-left, 40% all edges)
- **AND** this SHALL create the impression of backlight separation

#### Scenario: Rim Light on Player vs Enemy
- **GIVEN** both player and enemy sprites use the rim light shader
- **WHEN** the scene is rendered
- **THEN** the player SHALL have warm white rim light (matching sun color)
- **AND** enemies SHALL have cool purple rim light Color(0.7, 0.5, 1.0) (matching their visual theme)
- **AND** the different rim colors SHALL help distinguish player from enemies at a glance

#### Scenario: Rim Light Compatibility with Billboard
- **GIVEN** the sprite uses billboard_mode = BILLBOARD_FIXED_Y
- **WHEN** the camera views the sprite from the orthographic angle
- **THEN** the rim light SHALL appear consistent regardless of camera angle
- **AND** the shader SHALL work with alpha_scissor transparency
- **AND** the rim light SHALL not cause alpha bleeding artifacts

