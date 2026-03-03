# Post-Processing Pipeline for HD-2D Aesthetic

## Why

The GDD specifies an HD-2D visual style (like Octopath Traveler) that requires post-processing effects to achieve the characteristic depth and atmosphere. The current forest_01 level has basic SSAO and glow enabled, but is missing **Depth of Field (DoF)** and **Vignette** effects which are critical for:
- Focusing player attention on the character (DoF blur on distant objects)
- Creating cinematic atmosphere (vignette darkening at edges)
- Enhancing the mystical forest mood

Without these effects, the game lacks the signature HD-2D visual identity described in the GDD Section 4 (Art Direction - Post-Processing Wajib).

## What Changes

### Environment Resource Enhancement
- Set **Tonemapper to ACES** for cinematic high-contrast lighting
- Configure **Glow with HDR Threshold > 1.0** to isolate VFX blooming (only HDR bright areas bloom)
- Add **Depth of Field (DoF) Near** blur for close-up depth effect
- Add **Depth of Field (DoF) Far** blur for diorama depth effect and background separation
- Add subtle **Volumetric Fog** to capture dynamic light rays from VFX and enhance god ray atmosphere
- Add **Vignette** effect for edge darkening and focus
- Tune existing **SSAO** and **Adjustments** values to match GDD recommendations
- (Optional) Enable **SSR** for wet/reflective surfaces

### Rendering & Material Enhancement
- Configure global default **Texture Filter to Nearest** for pixel-perfect assets (prevents blurry bilinear filtering on pixel art)
- Update Sprite3D base materials to use **Alpha Scissor/Hash** to:
  - Fix DoF bleeding artifacts on transparent sprite edges
  - Enable proper **Shadow Casting and Receiving** from 3D light sources on 2D sprites

### Scope
- **In Scope**:
  - WorldEnvironment configuration in forest_01.tscn
  - Project rendering settings (texture filter)
  - Player Sprite3D material configuration
- **Out of Scope**:
  - Dynamic DoF that tracks player position (future enhancement)
  - Per-level environment variations
  - Enemy sprite materials (separate change)

### Dependencies
- Requires: lighting-system (already implemented)
- Relates:
  - level-system (forest_01 level scene)
  - player-scene (Sprite3D material updates)
  - camera-system (requires testing Perspective camera with ~20-30 FOV vs Orthographic for optimal DoF effect)

## Acceptance Criteria
- [ ] DoF blur visible on distant GridMap tiles (beyond 15 units)
- [ ] Player character remains in sharp focus at gameplay distance
- [ ] Vignette creates subtle darkening at screen edges
- [ ] Combined effects achieve HD-2D aesthetic per visual review
- [ ] Frame rate maintains 60 FPS with all effects enabled
- [ ] 2D Sprites cast and receive shadows correctly from 3D light sources
- [ ] DoF blur correctly respects the edges of 2D sprites without alpha-bleeding artifacts
- [ ] Pixel art textures remain crisp (no blurry bilinear filtering) on GridMap and sprites
