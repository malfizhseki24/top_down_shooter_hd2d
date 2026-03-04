# Tasks: Add VFX & Player Damage Feedback

## Phase A: Player Damage Feedback (Core Priority)

- [x] A1. Add player hit flash — tween sprite modulate to white on damage (mirror enemy_base pattern)
- [x] A2. Add player knockback — velocity impulse away from hitbox source, decays over time
- [x] A3. Add player i-frames — 0.3s invulnerability after damage via hurtbox.set_invulnerable()
- [x] A4. Emit Events.player_damaged from player_controller on damage received
- [x] A5. Add player death handling — emit Events.player_died, disable input, visual death state
- [x] **A6. VERIFY**: Player flashes white and gets pushed back on hit, cannot be multi-hit

## Phase B: Screen Shake

- [x] B1. Add shake(intensity, duration) method to camera_follow.gd
- [x] B2. Apply random offset in _process that decays via lerp
- [x] B3. Connect Events.player_damaged → camera shake (intensity 0.15)
- [x] B4. Connect Events.enemy_killed → camera shake (intensity 0.05)
- [x] **B5. VERIFY**: Camera shakes on player damage and enemy kill, returns to smooth follow

## Phase C: Hit & Death Effects

- [x] C1. Create hit_effect.tscn — GPUParticles3D one_shot burst + brief OmniLight3D flash
- [x] C2. Create hit_effect.gd — auto queue_free after particles finish
- [x] C3. Create death_effect.tscn — larger particle burst with upward motion
- [x] C4. Create death_effect.gd — auto queue_free after particles finish
- [x] C5. Spawn hit_effect in arrow.gd on _on_hit_hurtbox and _on_body_entered
- [x] C6. Spawn death_effect in enemy_base.gd _on_died at enemy position
- [x] **C7. VERIFY**: Arrow impact shows particle burst, enemy death shows larger burst

## Phase D: Player HUD

- [x] D1. Add ProgressBar to hud.tscn — anchored top-left, styled as health bar
- [x] D2. Connect health bar to player HealthComponent.health_changed signal
- [x] D3. Tween health bar value changes (smooth animation, not instant)
- [x] D4. Add damage vignette ColorRect overlay — fullscreen red flash on Events.player_damaged
- [x] D5. Add death screen panel — "You Died" label + Restart button, fades in on Events.player_died
- [x] D6. Implement restart — reload current scene on button press
- [x] **D7. VERIFY**: Health bar updates smoothly, vignette flashes on damage, death screen with restart works

## Dependencies

- Phase A has no dependencies (player_controller.gd + existing components)
- Phase B depends on A4 (needs Events.player_damaged emitted)
- Phase C has no dependencies (can be done in parallel with A and B)
- Phase D depends on A4 and A5 (needs Events signals emitted)
- **Phases A and C can run in parallel**
- **Phase B requires A4, Phase D requires A4+A5**
