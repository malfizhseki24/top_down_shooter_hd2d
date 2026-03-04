# Proposal: Add Score Counter & Pause Menu

## Why
GDD Phase 4.4 requires a score counter and pause menu. The HUD already has health bar, dash bar, damage vignette, and death screen, but is missing score display and pause functionality. Adding these completes the HUD requirements.

## What Changes

### 1. Score Counter
Add a score label to the HUD that increments when enemies are killed. Connects to the existing `Game.add_score()` and `Events.enemy_killed` systems.

### 2. Pause Menu
Add an Escape-key pause menu with Resume, Restart, and Quit buttons. Uses `get_tree().paused = true` with the HUD's `process_mode` set to always process.

### 3. Score on Death Screen
Show the final score on the death screen so the player knows how they did.

**Affected files:**
- `scripts/ui/hud.gd` — add score label, pause menu logic
- `scenes/ui/hud.tscn` — add ScoreLabel, PauseMenu nodes
- `scripts/enemies/enemy_base.gd` — emit score on death (if not already)
