# Tasks: add-lighting-setup

## Implementation Tasks

- [x] **1. Adjust DirectionalLight3D for dramatic shadows**
  - Modify rotation for steep diagonal angle (god ray effect)
  - Set shadow mode to PSSM 2-split for quality
  - Configure light color to warm white (forest sun)
  - Validate: Shadows cast visible god ray patterns through trees

- [x] **2. Configure ambient light in WorldEnvironment**
  - Set ambient light source to Color
  - Set ambient color to dark forest green (subtle base)
  - Set ambient energy to 0.3-0.5 for mood without flatness
  - Validate: Dark areas have subtle green tint, not pitch black

- [x] **3. Add OmniLight accent lights (3-5 nodes)**
  - Place first OmniLight near tree cluster (simulating light shaft)
  - Place second OmniLight near rock formation
  - Place third OmniLight at center-path intersection
  - Configure light color to subtle cyan/teal (bioluminescent hint)
  - Set low energy (0.5-1.0) and limited range (3-5 units)
  - Validate: Accent lights add depth without overwhelming scene

- [x] **4. Enable player shadow casting**
  - Open `scenes/player/player.tscn`
  - Set `cast_shadow` to `SHADOW_CASTING_SETTING_ON` on Player root node
  - Validate: Player casts visible shadow on ground when moving

- [x] **5. Final lighting validation**
  - Playtest player visibility across entire arena
  - Verify shadows enhance depth perception
  - Confirm atmospheric mood matches GDD description
  - Validate: Visual review pass for HD-2D atmosphere

## Verification
- [x] Run scene in editor and confirm no errors
- [x] Playtest: Player visible and readable at all positions
- [x] Visual check: Shadows visible on ground and props
- [x] Visual check: Player shadow visible and moves with player
- [x] Visual check: Accent lights create subtle mood spots
