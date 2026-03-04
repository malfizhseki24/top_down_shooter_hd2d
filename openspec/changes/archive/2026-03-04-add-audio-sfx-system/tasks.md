# Tasks

- [x] **T1: Download Free SFX Assets**
  - Source stylized/fantasy SFX from Kenney Audio, Pixabay, or Freesound (CC0/free license)
  - Required: shoot, hit, dash, enemy_death, player_hurt, player_death
  - Place in `assets/audio/sfx/` as .ogg or .wav
  - Validate: all 6 files present and playable

- [x] **T2: Configure Audio Bus Layout**
  - Create `default_bus_layout.tres` with Master → SFX and Master → Music buses
  - Validate: buses visible in Godot Audio panel

- [x] **T3: Create AudioManager Autoload**
  - File: `scripts/autoload/audio_manager.gd`
  - Preload all SFX at startup
  - Use a pool of AudioStreamPlayer nodes for overlapping sounds
  - Expose `play_sfx(sfx_name: String)` method
  - Register as autoload in `project.godot`
  - Validate: can call `AudioManager.play_sfx("shoot")` from any script

- [x] **T4: Connect Events to SFX**
  - File: `scripts/autoload/audio_manager.gd`
  - Connect `Events.player_shot` → play shoot SFX
  - Connect `Events.player_dashed` → play dash SFX
  - Connect `Events.player_damaged` → play player_hurt SFX
  - Connect `Events.player_died` → play player_death SFX
  - Connect `Events.enemy_killed` → play enemy_death SFX
  - Add `arrow_hit` signal to Events + emit from arrow collision → play hit SFX
  - Validate: every gameplay action has audio feedback

- [x] **T5: Tune Volume & Polish**
  - Balance SFX volumes relative to each other
  - Add pitch randomization (±10%) to shoot/hit for variety
  - Validate: audio feels natural, no clipping, no annoying repetition
