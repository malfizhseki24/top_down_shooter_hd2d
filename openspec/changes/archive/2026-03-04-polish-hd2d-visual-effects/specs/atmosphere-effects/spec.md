# atmosphere-effects Specification

## Purpose
Atmospheric visual effects that enhance the HD-2D forest diorama — leaf particles, dappled light, and god ray improvements.

## ADDED Requirements

### Requirement: Leaf Fall Particles
The atmosphere system SHALL include falling leaf particles that drift from the canopy to the ground, enhancing the forest setting.

#### Scenario: Leaf Particle Configuration
- **GIVEN** AtmosphereEffects node with leaf_enabled = true
- **WHEN** leaf particles are created
- **THEN** approximately 20 GPUParticles3D leaf particles SHALL be emitted
- **AND** leaves SHALL spawn above the play area (Y = 3-5)
- **AND** leaves SHALL drift downward with gentle gravity (~1.0)
- **AND** leaves SHALL sway horizontally via turbulence
- **AND** leaf lifetime SHALL be 8-12 seconds

#### Scenario: Leaf Visual Appearance
- **GIVEN** leaf particles are active
- **WHEN** the scene is rendered
- **THEN** leaves SHALL use a small quad mesh with warm green/brown tint
- **AND** leaves SHALL fade in at spawn and fade out before despawn
- **AND** leaves SHALL rotate slowly as they fall
- **AND** billboard mode SHALL be enabled so leaves face the camera

#### Scenario: Leaf Particle Performance
- **GIVEN** leaf particles are active alongside dust particles
- **WHEN** the scene is rendered
- **THEN** total particle count (dust + leaves) SHALL not exceed 120
- **AND** frame rate SHALL remain at or above 60 FPS

---

### Requirement: Dappled Light Ground Projection
The atmosphere system SHALL project animated light spots on the ground simulating sunlight filtered through tree canopy.

#### Scenario: Dappled Light Decal Setup
- **GIVEN** AtmosphereEffects node with dappled_light_enabled = true
- **WHEN** the dappled light effect is created
- **THEN** a Decal node SHALL project a Voronoi-based noise pattern onto the ground
- **AND** the decal modulate SHALL use warm sunlight color with additive appearance
- **AND** the decal size SHALL cover the play area (approximately 20x10x20)
- **AND** the projection SHALL only affect the ground layer

#### Scenario: Dappled Light Animation
- **GIVEN** dappled light decal is active
- **WHEN** the scene is rendering over time
- **THEN** the light pattern SHALL scroll subtly (simulating wind moving the canopy)
- **AND** the scroll speed SHALL be slower than cloud shadows (approximately 0.1-0.2 units/sec)
- **AND** the pattern SHALL appear seamless with no visible tiling boundary

#### Scenario: Dappled Light in Clearing vs Canopy
- **GIVEN** the forest has both clearing and canopy areas
- **WHEN** dappled light is rendered
- **THEN** the light spots SHALL be most visible in the transition zone between canopy and clearing
- **AND** the effect SHALL complement (not compete with) the existing cloud shadow system

---

### Requirement: God Ray Shape Improvement
God rays SHALL use vertex taper and Y-axis billboard to appear as organic light shafts rather than flat rectangles.

#### Scenario: God Ray Vertex Taper
- **GIVEN** a GodRay MeshInstance3D in the scene
- **WHEN** the god ray quad is rendered
- **THEN** the top of the quad SHALL be wider than the bottom
- **AND** the taper amount SHALL be configurable via `taper_amount` export (default 0.4)
- **AND** the resulting shape SHALL resemble a natural light cone

#### Scenario: God Ray Y-Axis Billboard
- **GIVEN** a GodRay with billboard enabled
- **WHEN** the camera views the scene from the orthographic angle
- **THEN** the quad SHALL rotate on the Y-axis to face the camera
- **AND** the quad SHALL remain vertically oriented (not tilting toward camera)
- **AND** the billboard behavior SHALL prevent edge-on viewing angles that reveal the flat quad

#### Scenario: God Ray Softened Parameters
- **GIVEN** god rays are placed in the forest scene
- **WHEN** the default parameters are applied
- **THEN** ray_color SHALL be warm golden Color(1, 0.92, 0.7)
- **AND** intensity SHALL range from 0.08 to 0.15 (reduced from 0.15-0.3)
- **AND** noise_speed SHALL be 0.02 (slower for majestic feel)
- **AND** edge_fade SHALL be 0.25 (softer edges)
- **AND** the bloom/glow system SHALL amplify the rays naturally
