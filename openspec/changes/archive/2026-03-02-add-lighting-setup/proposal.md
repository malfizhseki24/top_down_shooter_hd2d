# Proposal: add-lighting-setup

## Summary
Implement the Lighting Setup phase (GDD 2.4) to enhance `forest_01.tscn` with atmospheric lighting that establishes the HD-2D visual style: dramatic shadows, ambient mood, and accent point lights.

## Motivation
The current `forest_01.tscn` has basic lighting (single DirectionalLight3D with shadows), but lacks:
- Optimized light angle for god ray effect through forest canopy
- Ambient lighting configuration for base illumination
- OmniLight point lights for mood accents (bioluminescent feel)

Proper lighting is foundational to the HD-2D aesthetic defined in the GDD, supporting the "rimbun" (lush) and "mistis" (mystical) atmosphere.

## Scope
### In Scope
- DirectionalLight3D angle adjustment for dramatic shadows
- WorldEnvironment ambient light configuration
- 3-5 OmniLight nodes for mood accents in forest_01.tscn

### Out of Scope
- Post-processing effects (DoF, Vignette) - covered in GDD 2.5
- Other level scenes
- Dynamic/time-of-day lighting

## Approach
1. Adjust existing DirectionalLight3D rotation for dramatic god ray angle (steep diagonal)
2. Configure ambient light in WorldEnvironment (sky color, energy)
3. Add OmniLight nodes at strategic positions for mystical accents
4. Validate visual result against GDD atmosphere goals

## Dependencies
- `level-system` spec (forest_01.tscn exists)
- Kenney Nature Kit assets (already integrated)

## Risks
| Risk | Mitigation |
|------|------------|
| Too many lights impact performance | Limit to 5 OmniLights max, use low priority |
| Lighting too dark for gameplay | Test with player visibility, adjust energy |
| Inconsistent with HD-2D style | Compare against GDD visual references |
