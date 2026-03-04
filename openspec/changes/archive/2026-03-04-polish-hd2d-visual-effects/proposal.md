# Proposal: polish-hd2d-visual-effects

## Summary
Polish pass on all visual effects and environment systems to achieve Triangle Strategy-level HD-2D quality. Addresses 8 distinct improvements across lighting, atmosphere, post-processing, combat VFX, and sprite rendering — all identified from a senior VFX artist audit.

## Motivation
Current scene has correct foundations (tilt-shift, ACES tonemap, SSAO, cloud shadows, god rays, bloom) but parameters are at "first pass" values. The visual identity lacks:
- **Warm/cool color temperature contrast** — the signature of HD-2D lighting
- **Rim lighting on sprites** — Triangle Strategy's most recognizable visual technique
- **Organic god ray shapes** — current flat quads read as geometric rectangles
- **Layered atmosphere** — missing depth fog and falling foliage
- **Combat impact feel** — no hit pause or chromatic aberration punch

## Scope

### Tier 1 — High Impact (Must Have)
1. **Lighting Color Temperature** — Cool blue ambient + differentiated warm/cool fill lights
2. **God Ray Shape Improvement** — Vertex taper (wider top, narrow bottom) + Y-billboard + softer params
3. **Sprite Rim Light Shader** — Edge highlight shader on AnimatedSprite3D to separate characters from background
4. **Dappled Light Ground Texture** — Projected leaf shadow pattern via Decal

### Tier 2 — Polish (Should Have)
5. **Depth Fog** — Distance-based fog fade for far objects
6. **Hit Pause** — 2-3 frame freeze on combat impacts
7. **Chromatic Aberration** — Subtle color fringing added to tilt-shift shader
8. **Leaf Fall Particles** — Occasional leaf sprites drifting from canopy

## Impact
- **Performance**: Minimal — rim light is per-sprite shader, leaf particles add ~20 GPUParticles3D, depth fog is free (Environment property), hit pause is zero-cost
- **Existing systems**: Modifies lighting-system spec (fill light colors, ambient), post-processing spec (fog, glow, chromatic aberration), adds new atmosphere-effects and sprite-rendering specs
- **Gameplay**: Hit pause improves combat feel significantly; visual clarity improves from rim light + color temperature contrast

## Files Affected

### New Files
- `shaders/rim_light.gdshader` — Spatial shader for sprite edge highlight
- `shaders/dappled_light.gdshader` — Decal shader for animated light spots on ground

### Modified Files
- `shaders/god_ray.gdshader` — Add vertex taper + Y-billboard
- `shaders/tilt_shift.gdshader` — Add chromatic aberration uniform
- `scripts/effects/god_ray.gd` — Billboard mode parameter
- `scripts/effects/atmosphere.gd` — Add leaf particles + dappled light decal
- `scripts/camera/camera_follow.gd` — Add hit pause via Engine.time_scale
- `scenes/levels/forest_01.tscn` — Update Environment, fill lights, god ray params

## Risks
- Rim light shader on billboard sprites needs careful normal handling — may need to use screen-space edge detection instead of world-space normals
- Hit pause affects all game systems (timers, tweens) — need to use `process_mode = PROCESS_MODE_ALWAYS` on the recovery timer
- Chromatic aberration if too strong looks cheap — keep at 0.5-1.0px max

## Related Specs
- `lighting-system` — MODIFIED (ambient color, fill light differentiation)
- `post-processing` — MODIFIED (depth fog, glow tuning, chromatic aberration)
- `atmosphere-effects` — NEW (leaf particles, dappled light, god ray improvements)
- `combat-vfx` — NEW (hit pause)
- `sprite-rendering` — NEW (rim light shader)
