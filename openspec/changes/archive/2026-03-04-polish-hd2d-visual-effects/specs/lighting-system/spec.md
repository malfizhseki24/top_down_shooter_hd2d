# lighting-system Specification Delta

## MODIFIED Requirements

### Requirement: Ambient Light Base
The level SHALL have ambient lighting with cool blue tone to create warm/cool contrast with the warm directional sun light.

#### Scenario: Cool Ambient for Warm/Cool Contrast
- **GIVEN** a WorldEnvironment node with Environment resource
- **WHEN** ambient light is configured for HD-2D warm/cool contrast
- **THEN** ambient_light_color SHALL be cool blue-gray (approximately Color(0.08, 0.1, 0.15))
- **AND** ambient_light_energy SHALL be 0.3
- **AND** shadowed areas SHALL have subtle cool blue tint
- **AND** the contrast with warm directional light SHALL create depth

#### Scenario: Shadow Visibility
- **GIVEN** cool ambient light is configured
- **WHEN** the scene is viewed in shadowed areas
- **THEN** dark areas SHALL have visible detail with cool blue tint
- **AND** the player SHALL remain clearly visible in shadows
- **AND** the warm sun vs cool shadow contrast SHALL be apparent

---

### Requirement: Accent Point Lights
The level SHALL have OmniLight nodes with differentiated color temperatures for visual hierarchy and mood.

#### Scenario: Differentiated Fill Light Colors
- **GIVEN** 3 OmniLight accent nodes in the forest_01 level
- **WHEN** accent lights are configured for visual hierarchy
- **THEN** TreeCluster light SHALL use cool blue Color(0.4, 0.6, 0.8) at energy 0.4 (canopy bounce)
- **AND** RockFormation light SHALL use warm Color(0.9, 0.8, 0.5) at energy 0.3 (reflected sunlight)
- **AND** PathCenter light SHALL use neutral-warm Color(0.7, 0.85, 0.6) at energy 0.5 (clearing focal light)
- **AND** no two fill lights SHALL share the same color

#### Scenario: Fill Light Hierarchy
- **GIVEN** differentiated fill lights are configured
- **WHEN** the scene is rendered
- **THEN** the clearing center SHALL appear warmest (sunlit)
- **AND** canopy areas SHALL appear coolest (shaded)
- **AND** the rock area SHALL have reflected warm light
- **AND** the visual temperature gradient SHALL guide the player's eye toward the clearing
