# Design: Post-Processing Pipeline

## Overview

This change configures Godot 4's Environment resource post-processing effects to achieve the HD-2D visual style specified in the GDD. The design also covers rendering settings and material configurations essential for pixel-perfect visuals and proper DoF/sprite interaction.

## Effect Stack

The following effects are applied in the Environment resource:

### 1. ACES Tonemapper
**Purpose**: Provides cinematic high-contrast lighting with proper HDR handling.

**Configuration**:
```
Tonemap:
  - mode: TONEMAPPER_ACES
  - exposure: 1.0 (default)
```

**Rationale**: ACES (Academy Color Encoding System) tonemapper preserves highlights and shadows better than Linear, creating a more cinematic look essential for HD-2D aesthetic.

### 2. Depth of Field (DoF)
**Purpose**: Creates cinematic depth by blurring objects outside the focus range, making the player character pop visually.

**Configuration**:
```
DoF Near:
  - enabled: true
  - distance: 5.0    # Start blur 5 units from camera
  - transition: 2.0  # Gradual blur transition

DoF Far:
  - enabled: true
  - distance: 15.0   # Start blur 15 units from camera
  - transition: 5.0  # Gradual blur transition

Blur Amount: 0.1     # Subtle blur, not distracting
```

**Rationale**: The top-down camera at height 8 with 45-degree angle means the player at Y=0.5 is approximately 8-10 units from camera. Near blur at 5 units affects very close foreground, far blur at 15 units affects distant background tiles.

### 2. Vignette
**Purpose**: Darkens screen edges to draw focus to the center where gameplay occurs.

**Configuration**:
```
Vignette:
  - enabled: true
  - intensity: 0.3   # Subtle, not oppressive
  - stretch: 0.3     # Appropriate for top-down view
```

**Rationale**: Too much vignette obscures enemies at edges; 0.3 provides atmosphere without gameplay impact.

### 3. SSAO (Already Configured)
**Configuration**:
```
SSAO:
  - enabled: true
  - radius: 0.5
  - intensity: 1.5
```

### 4. Glow (Already Configured - Update Threshold)
**Configuration**:
```
Glow:
  - enabled: true
  - intensity: 0.5
  - threshold: 1.2   # HDR threshold > 1.0 to isolate VFX blooming
```

**Rationale**: Setting threshold above 1.0 ensures only HDR-bright areas (like magical VFX, projectiles, and emissive materials) bloom, while normal scene brightness doesn't bloom excessively.

### 5. Volumetric Fog
**Purpose**: Creates atmospheric depth and captures light rays for god ray effects.

**Configuration**:
```
Volumetric Fog:
  - enabled: true
  - density: 0.02    # Subtle, not oppressive
  - albedo: Color(0.8, 0.9, 0.85)  # Slight green tint for forest
  - emission: 0.0
  - anisotropy: 0.5  # Forward scattering for god rays
```

**Rationale**: Subtle volumetric fog enhances the mystical forest atmosphere and creates visible light shafts when combined with DirectionalLight3D shadows.

### 6. Color Adjustments (Already Configured)
**Configuration**:
```
Adjustments:
  - enabled: true
  - contrast: 1.1    # Slight pop
  - saturation: 1.1  # Vibrant colors
```

### 7. SSR (Optional)
**Purpose**: Adds reflections on wet/reflective surfaces for enhanced atmosphere.

**Configuration**:
```
SSR:
  - enabled: false (default, enable if needed)
  - max_steps: 64
  - fade_in: 0.15
  - fade_out: 2.0
```

**Rationale**: SSR is optional for MVP. Enable if level design includes wet surfaces or water features.

## Rendering Settings

### Texture Filter Mode
**Purpose**: Preserve pixel art crispness by using nearest-neighbor filtering instead of bilinear.

**Configuration**:
```
Project Settings → Rendering → Textures → Default Texture Filter: NEAREST
```

**Rationale**:
- Bilinear filtering causes blurry edges on pixel art sprites and GridMap tiles
- Nearest filtering maintains sharp pixel edges essential for retro/pixel art aesthetic
- This is a global setting but can be overridden per-texture if needed

**Impact**:
- Kenney nature kit assets will appear with crisp edges
- Player and enemy sprites will maintain pixel-perfect rendering
- No performance cost difference

## Sprite3D Material Configuration

### Alpha Scissor for DoF Compatibility
**Problem**: DoF blur causes alpha-bleeding artifacts on transparent sprite edges because the blur samples neighboring pixels including transparent areas.

**Solution**: Use Alpha Scissor or Alpha Hash transparency mode instead of Alpha Blend.

**Configuration** (StandardMaterial3D):
```
transparency: TRANSPARENCY_ALPHA_SCISSOR
alpha_scissor_threshold: 0.5
```

**Alternative**: For smoother edges with dithering:
```
transparency: TRANSPARENCY_ALPHA_HASH
alpha_hash_scale: 1.0
alpha_antialiasing_mode: ALPHA_ANTIALIASING_ALPHA_HASH
```

### Shadow Casting/Receiving
**Purpose**: 2D sprites should interact with 3D lighting for visual consistency.

**Configuration** (Sprite3D node):
```
cast_shadow: SHADOW_CASTING_SETTING_ON
receive_shadow: true (default)
```

**Rationale**:
- Player sprite casting shadow on ground enhances depth perception
- Sprite darkening in shadowed areas maintains visual consistency
- Essential for HD-2D blend of 2D characters in 3D environment

## Camera Mode Considerations

### Orthographic vs Perspective for DoF

| Aspect | Orthographic | Perspective (FOV 20-30) |
|--------|--------------|-------------------------|
| DoF Behavior | Based on distance only | Based on distance + perspective |
| Depth Perception | Flat, consistent | Natural depth falloff |
| HD-2D Aesthetic | May look too flat | More cinematic |
| Performance | Same | Same |

**Recommendation**: Test both modes during implementation. Perspective with low FOV (20-30) typically produces more cinematic DoF effects for HD-2D style, but Orthographic may be preferred for gameplay clarity in top-down shooter.

## Performance Considerations

| Effect | Performance Cost | Priority |
|--------|------------------|----------|
| ACES Tonemapper | Very Low | Keep |
| SSAO | Medium | Keep |
| DoF | Medium | Keep |
| Glow | Low | Keep |
| Volumetric Fog | High | Keep (tune density) |
| Vignette | Very Low | Keep |
| Adjustments | Very Low | Keep |
| SSR | High | Optional |
| Nearest Filter | None | Keep |
| Alpha Scissor | Very Low | Keep |

**Expected Impact**: With all effects (except SSR), should maintain 60 FPS on target hardware. Volumetric Fog and DoF are the most expensive additions - tune density/quality if needed.

## Alternative Approaches Considered

### Dynamic DoF Tracking Player
**Rejected**: Adds complexity, requires additional scripting, not needed for MVP. Static focus range works well for top-down view.

### Post-Processing via CompositorEffect
**Rejected**: Godot 4.6 Environment resource is sufficient for MVP needs. Custom compositor would be over-engineering.

### Alpha Blend with Edge Detection
**Rejected**: More complex than Alpha Scissor, minimal visual benefit for pixel art sprites.

## File Changes

| File | Change |
|------|--------|
| `project.godot` | Set default texture filter to NEAREST |
| `scenes/levels/forest_01.tscn` | Update Environment with DoF, Vignette |
| `scenes/player/player.tscn` | Configure Sprite3D material with Alpha Scissor, shadow casting |

## Testing Strategy

1. **Visual Test**: Load forest_01, verify DoF blur on distant tiles
2. **Focus Test**: Player sprite should remain sharp at all gameplay positions
3. **Vignette Test**: Check corners are subtly darkened
4. **Texture Test**: Verify pixel art remains crisp (no bilinear blur)
5. **Shadow Test**: Verify player casts shadow on ground, darkens in shadows
6. **Alpha Bleed Test**: Check sprite edges for DoF artifacts
7. **Camera Test**: Compare Orthographic vs Perspective DoF behavior
8. **Performance Test**: Run with profiler, verify 60 FPS maintained
