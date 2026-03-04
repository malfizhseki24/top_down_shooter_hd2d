# Proposal: Add Audio SFX System

## Why
GDD Phase 4.3 requires audio feedback for all core gameplay actions. Currently the game has zero audio — no SFX, no music, no audio bus configuration. Adding sound effects will significantly improve game feel and complement the existing VFX and screen shake feedback.

## What Changes

### 1. Audio Manager Autoload
A lightweight `AudioManager` singleton that plays one-shot SFX by connecting to the existing Events bus signals. Uses an `AudioStreamPlayer` pool to handle overlapping sounds.

### 2. SFX Assets (Free/CC0)
Download stylized fantasy SFX from free sources (Kenney, Pixabay, Freesound CC0) for:
- **Shoot** — magical bow/arrow whoosh
- **Hit** — impact when arrow hits enemy
- **Dash** — swift wind burst
- **Enemy Death** — magical dissolve/poof
- **Player Hurt** — pain/hit feedback
- **Player Death** — dramatic death sound

### 3. Audio Bus Layout
Configure Master → SFX and Master → Music buses in Godot for independent volume control.

**Affected files:**
- `scripts/autoload/audio_manager.gd` — new autoload singleton
- `project.godot` — register autoload + audio bus
- `default_bus_layout.tres` — SFX and Music buses
- `assets/audio/sfx/` — sound effect files
