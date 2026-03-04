# audio-system Specification

## Purpose
TBD - created by archiving change add-audio-sfx-system. Update Purpose after archive.
## Requirements
### Requirement: Audio Manager Singleton
The game SHALL have an AudioManager autoload that handles all SFX playback through a pooled AudioStreamPlayer system.

#### Scenario: Play one-shot SFX
- **GIVEN** the AudioManager is registered as autoload
- **WHEN** `AudioManager.play_sfx("shoot")` is called
- **THEN** the shoot sound effect SHALL play immediately
- **AND** the sound SHALL use an available AudioStreamPlayer from the pool

#### Scenario: Overlapping sounds
- **GIVEN** multiple SFX are triggered in rapid succession (e.g., rapid fire)
- **WHEN** a new SFX is requested while others are playing
- **THEN** the new sound SHALL play concurrently using a separate AudioStreamPlayer
- **AND** no sounds SHALL be cut off or dropped

---

### Requirement: Gameplay SFX Feedback
All core gameplay actions SHALL trigger appropriate sound effects via the Events bus.

#### Scenario: Shoot SFX
- **GIVEN** the player fires an arrow
- **WHEN** `Events.player_shot` is emitted
- **THEN** a magical whoosh/bow SFX SHALL play

#### Scenario: Hit SFX
- **GIVEN** an arrow hits an enemy
- **WHEN** `Events.arrow_hit` is emitted
- **THEN** an impact SFX SHALL play

#### Scenario: Dash SFX
- **GIVEN** the player activates dash
- **WHEN** `Events.player_dashed` is emitted
- **THEN** a swift wind burst SFX SHALL play

#### Scenario: Enemy Death SFX
- **GIVEN** an enemy's health reaches zero
- **WHEN** `Events.enemy_killed` is emitted
- **THEN** a magical dissolve/death SFX SHALL play

#### Scenario: Player Hurt SFX
- **GIVEN** the player takes damage
- **WHEN** `Events.player_damaged` is emitted
- **THEN** a pain/hit feedback SFX SHALL play

#### Scenario: Player Death SFX
- **GIVEN** the player dies
- **WHEN** `Events.player_died` is emitted
- **THEN** a dramatic death SFX SHALL play

---

### Requirement: Audio Bus Configuration
The project SHALL have separate audio buses for SFX and Music to allow independent volume control.

#### Scenario: Audio bus layout
- **GIVEN** the project audio configuration
- **WHEN** the game starts
- **THEN** there SHALL be a Master bus, an SFX bus, and a Music bus
- **AND** SFX and Music buses SHALL route to Master

---

### Requirement: SFX Variety
Sound effects SHALL have slight pitch randomization to avoid robotic repetition.

#### Scenario: Pitch variation on repeated SFX
- **GIVEN** the same SFX is played multiple times in succession
- **WHEN** each instance plays
- **THEN** the pitch SHALL be randomized within ±10% of base pitch
- **AND** the variation SHALL feel natural without being disorienting

