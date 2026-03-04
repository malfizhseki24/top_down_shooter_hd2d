# Design: polish-hd2d-visual-effects

## Architectural Decisions

### AD-1: Rim Light Approach — Screen-Space Edge Detection vs Normal-Based

**Problem**: Triangle Strategy's rim light highlights sprite edges against the background. Billboard sprites in Godot have flat normals pointing at the camera, so traditional Fresnel rim light won't work.

**Options**:
1. **Sobel edge detection in canvas_item shader** — Sample depth/color buffer, detect edges, overlay highlight. Expensive and applies globally.
2. **Per-sprite spatial shader with UV-based edge detection** — Check proximity to UV boundary (0 or 1), apply glow. Cheap, per-object, works with billboard.
3. **Outline via duplicate mesh** — Scale up a back-face copy. Classic but doesn't give soft rim glow.

**Decision**: **Option 2 — UV-based edge detection in spatial shader**. The sprite's transparent pixels naturally define the silhouette. We detect pixels near the alpha boundary by sampling neighboring texels and checking alpha transitions. This gives a soft inner-glow rim light that works perfectly with billboard mode.

**Trade-off**: Only works for sprites with clean alpha boundaries (our pixel art sprites qualify). Won't work for arbitrary 3D meshes, but we don't need that.

### AD-2: God Ray Billboard Behavior

**Problem**: Flat quads viewed from ortho camera show sharp rectangular edges.

**Decision**: Add `BILLBOARD_FIXED_Y` mode so the quad always faces the camera horizontally but stays vertically oriented. Combine with vertex shader taper: at `VERTEX.y > 0` (top), widen the quad; at `VERTEX.y < 0` (bottom), narrow it. This creates a natural cone shape.

### AD-3: Hit Pause Implementation

**Problem**: Need 2-3 frame freeze on impact without breaking game logic.

**Decision**: Use `Engine.time_scale = 0.0` for a real-time duration of ~50ms (3 frames at 60fps). The recovery timer must use `process_mode = PROCESS_MODE_ALWAYS` to tick during the freeze. Place the hit pause logic in `camera_follow.gd` since it already handles combat events via Events bus.

**Trade-off**: `Engine.time_scale = 0` affects all nodes. Tweens and AnimationPlayers pause. This is actually desirable — the "freeze frame" effect should freeze everything. Particles with `local_coords = false` will also pause, which looks correct.

### AD-4: Dappled Light — Animated Decal vs Static Texture

**Problem**: Need projected light spots on ground simulating sunlight through leaves.

**Decision**: Use a second `Decal` in atmosphere.gd with a pre-generated noise texture using high-frequency Voronoi noise. Apply `blend_add` modulate with warm sunlight color. Subtle UV scroll for gentle movement (wind shifting canopy). Reuses the existing cloud shadow Decal pattern.

### AD-5: Chromatic Aberration Placement

**Problem**: Could add as separate shader pass or integrate into existing tilt-shift.

**Decision**: Integrate into `tilt_shift.gdshader`. Sample R, G, B channels at slightly offset UVs (scaled by distance from center). This is free — replaces 1 texture sample with 3, which is trivial. Controlled by uniform `chromatic_aberration : hint_range(0.0, 5.0) = 0.0` (default off for backwards compatibility, set to 0.5 in forest scene).

## System Interactions

```
DirectionalLight3D (warm)
  ├─→ God Rays (blend_add, tapered quad, billboard_y)
  ├─→ Dappled Light Decal (blend_add, warm spots on ground)
  └─→ Shadow casting on sprites (with rim light shader)

WorldEnvironment
  ├─→ Ambient Light (cool blue) ← NEW color
  ├─→ Depth Fog (distance-based) ← NEW
  ├─→ Glow/Bloom (tighter bloom 0.15) ← TUNED
  └─→ SSAO (reduced radius/intensity) ← TUNED

OmniLight3D (3x, differentiated colors)
  ├─→ TreeCluster: cool blue bounce
  ├─→ RockFormation: warm reflected
  └─→ PathCenter: neutral-warm clearing

Atmosphere Effects
  ├─→ Dust particles (existing)
  ├─→ Cloud shadows (existing)
  ├─→ Leaf fall particles ← NEW
  └─→ Dappled light decal ← NEW

Sprites (Player + Enemy)
  └─→ Rim light shader ← NEW

Post-Processing Stack
  └─→ Tilt-shift + vignette + chromatic aberration ← ENHANCED

Combat Events
  └─→ Hit pause (Engine.time_scale) ← NEW
```

## Parameter Reference

### Lighting Changes
| Parameter | Current | Target | Rationale |
|-----------|---------|--------|-----------|
| ambient_light_color | (0.02, 0.04, 0.02) | (0.08, 0.1, 0.15) | Cool blue fill for warm/cool contrast |
| ambient_light_energy | 0.1 | 0.3 | Lift shadows so detail is visible |
| OmniLight TreeCluster color | (0.6, 0.9, 0.9) | (0.4, 0.6, 0.8) | Cool canopy bounce |
| OmniLight TreeCluster energy | 1.0 | 0.4 | Subtle fill, not competing with sun |
| OmniLight RockFormation color | (0.6, 0.9, 0.9) | (0.9, 0.8, 0.5) | Warm reflected light |
| OmniLight RockFormation energy | 0.8 | 0.3 | Background accent |
| OmniLight PathCenter color | (0.6, 0.9, 0.9) | (0.7, 0.85, 0.6) | Neutral-warm clearing |
| OmniLight PathCenter energy | 0.6 | 0.5 | Focal area light |

### Environment Changes
| Parameter | Current | Target | Rationale |
|-----------|---------|--------|-----------|
| ssao_radius | 0.5 | 0.3 | Tighter contact shadows, less halo |
| ssao_intensity | 1.5 | 1.0 | Less aggressive |
| glow_bloom | 0.3 | 0.15 | Tighter bloom radius |
| fog_density | 0.004 | 0.008 | More visible ground fog |
| fog_height | 0.3 | 0.5 | Higher coverage |
| fog_color | (0.6, 0.7, 0.6) | (0.65, 0.7, 0.55) | Warmer green-yellow |
| NEW: fog_sky_affect | — | 0.0 | Distance fog doesn't affect sky color |

### God Ray Changes
| Parameter | Current | Target | Rationale |
|-----------|---------|--------|-----------|
| ray_color | (1, 0.95, 0.85) | (1, 0.92, 0.7) | Warmer golden |
| intensity (range) | 0.15-0.3 | 0.08-0.15 | Subtler, bloom amplifies |
| noise_speed | 0.05 | 0.02 | Slower = more majestic |
| edge_fade | 0.15 | 0.25 | Softer edges |
| NEW: taper_amount | — | 0.4 | Wider at top, narrow at bottom |
| NEW: billboard_y | — | true | Face camera horizontally |
