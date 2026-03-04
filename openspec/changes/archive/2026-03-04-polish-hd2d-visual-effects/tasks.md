# Tasks: polish-hd2d-visual-effects

## Implementation Order

Tasks are ordered by dependency and impact. Tier 1 (high impact) tasks first, then Tier 2 (polish).

---

### Tier 1 — High Impact

- [x] **T1: Lighting Color Temperature**
  Update forest_01.tscn Environment and OmniLight nodes:
  - Change `ambient_light_color` to Color(0.08, 0.1, 0.15), energy 0.3
  - Change OmniLight_TreeCluster to Color(0.4, 0.6, 0.8), energy 0.4
  - Change OmniLight_RockFormation to Color(0.9, 0.8, 0.5), energy 0.3
  - Change OmniLight_PathCenter to Color(0.7, 0.85, 0.6), energy 0.5
  - Tune ssao_radius to 0.3, ssao_intensity to 1.0
  - Tune glow_bloom to 0.15
  - **Files**: `scenes/levels/forest_01.tscn`
  - **Verify**: Warm/cool contrast visible between sunlit and shaded areas

- [x] **T2: God Ray Shape Improvement**
  Make god rays organic-looking instead of flat rectangles:
  - Add `taper_amount` uniform to `god_ray.gdshader` vertex shader — widen top, narrow bottom
  - Add `billboard_y` export to `god_ray.gd` — set `billboard = BILLBOARD_FIXED_Y` on mesh
  - Update default params: ray_color=(1, 0.92, 0.7), edge_fade=0.25, noise_speed=0.02
  - Update forest_01.tscn god ray instances with new intensity range (0.08-0.15)
  - **Files**: `shaders/god_ray.gdshader`, `scripts/effects/god_ray.gd`, `scenes/levels/forest_01.tscn`
  - **Verify**: God rays look like tapered light cones, no visible rectangular edges

- [x] **T3: Sprite Rim Light Shader**
  Create per-sprite rim light for HD-2D character separation:
  - Create `shaders/rim_light.gdshader` spatial shader with UV-based alpha edge detection
  - Add uniforms: `rim_color`, `rim_intensity`, `rim_width`, `rim_direction`
  - Apply to player AnimatedSprite3D (warm white rim)
  - Apply to enemy (wisp) AnimatedSprite3D (cool purple rim)
  - Ensure compatibility with billboard mode and alpha_scissor
  - **Files**: `shaders/rim_light.gdshader` (new), `scenes/player/player.tscn`, `scenes/enemies/wisp.tscn`
  - **Verify**: Characters have visible edge glow that separates them from background
  - **Depends on**: None (can parallel with T1, T2)

- [x] **T4: Dappled Light Ground Texture**
  Project animated sunlight spots on the ground:
  - Add `dappled_light_enabled` export group to `atmosphere.gd`
  - Create Decal with Voronoi/cellular noise texture (high frequency)
  - Modulate with warm additive color Color(1, 0.95, 0.8, 0.3)
  - Animate UV scroll at (0.1, 0.07) for gentle canopy sway
  - Cover play area approximately 20x10x20
  - **Files**: `scripts/effects/atmosphere.gd`
  - **Verify**: Visible warm light spots on ground, gentle animation, complements cloud shadows

---

### Tier 2 — Polish

- [x] **T5: Depth Fog Tuning**
  Increase ground fog visibility for diorama depth:
  - Update atmosphere.gd defaults: fog_density=0.008, fog_height=0.5, fog_color=(0.65, 0.7, 0.55)
  - Update forest_01.tscn if overriding atmosphere defaults
  - **Files**: `scripts/effects/atmosphere.gd`, `scenes/levels/forest_01.tscn`
  - **Verify**: Far tree borders show subtle atmospheric fade, play area center remains clear
  - **Depends on**: T1 (lighting color affects fog perception)

- [x] **T6: Hit Pause**
  Add frame freeze on combat impacts:
  - Add `_apply_hit_pause(duration_ms, scale)` to `camera_follow.gd`
  - On `player_damaged`: pause 50ms at time_scale 0.0, then shake
  - On `enemy_killed`: pause 30ms at time_scale 0.05
  - Use SceneTreeTimer with `process_always = true` for recovery
  - Prevent stacking: check if pause already active
  - **Files**: `scripts/camera/camera_follow.gd`
  - **Verify**: Brief satisfying freeze on hits, no broken timers or state corruption
  - **Depends on**: None (can parallel with T5)

- [x] **T7: Chromatic Aberration**
  Add subtle color fringing to post-processing:
  - Add `chromatic_aberration` uniform to `tilt_shift.gdshader` (default 0.0)
  - Sample R, G, B at offset UVs scaled by distance from center
  - Set to 0.5 in forest_01.tscn ShaderMaterial_TiltShift
  - **Files**: `shaders/tilt_shift.gdshader`, `scenes/levels/forest_01.tscn`
  - **Verify**: Subtle color fringing at screen edges, sharp center, no visual distraction
  - **Depends on**: None (can parallel with T5, T6)

- [x] **T8: Leaf Fall Particles**
  Add falling leaf ambient particles:
  - Add `leaf_enabled` export group to `atmosphere.gd`
  - Create GPUParticles3D with ~20 particles, 10s lifetime
  - Spawn above play area, gentle gravity (~1.0), horizontal turbulence
  - Small quad mesh with warm green/brown color, billboard enabled
  - Alpha curve: fade in 0-10%, hold 10-80%, fade out 80-100%
  - **Files**: `scripts/effects/atmosphere.gd`
  - **Verify**: Gentle leaf drift visible, no performance impact, forest atmosphere enhanced
  - **Depends on**: None (can parallel with T5, T6, T7)

---

## Parallelization Notes

- **T1, T2, T3, T4** can all be worked on in parallel (no file conflicts except T1+T2 both touch forest_01.tscn — coordinate)
- **T5, T6, T7, T8** can all be worked on in parallel
- T5 depends on T1 being done first (lighting affects fog perception)
- All other tasks are independent

## Verification Checklist (Post-Implementation)

- [x] Warm/cool contrast visible between sunlit clearing and shaded canopy
- [x]God rays appear as organic light cones, not rectangles
- [x]Player and enemy sprites have visible rim light separation from background
- [x]Dappled light spots visible on ground, animate gently
- [x]Far objects fade into atmospheric fog
- [x]Hit pause triggers on player damage and enemy kills
- [x]Subtle chromatic aberration at screen edges
- [x]Leaf particles drift naturally through the scene
- [x]All effects maintain 60 FPS target
- [x]Parameters are tunable via @export in editor inspector
