# player-hud Specification

## Purpose
TBD - created by archiving change add-vfx-and-player-feedback. Update Purpose after archive.
## Requirements
### Requirement: HUD SHALL display a health bar

The HUD SHALL show the player's current health as a visual bar.

#### Scenario: Health bar shows current health
- **Given** a player with max_health=10 and current_health=10
- **When** the HUD is visible
- **Then** a health bar SHALL be displayed anchored to the top-left
- **And** the bar SHALL be at 100% fill

#### Scenario: Health bar updates on damage
- **Given** a player with current_health=10
- **When** the player takes 3 damage
- **Then** the health bar SHALL smoothly animate to 70% fill
- **And** the transition SHALL use a tween (not instant snap)

#### Scenario: Health bar updates on heal
- **Given** a player with current_health=5 and max_health=10
- **When** the player heals 2 health
- **Then** the health bar SHALL smoothly animate to 70% fill

#### Scenario: Health bar at zero
- **Given** a player whose health reaches 0
- **When** the health bar updates
- **Then** the bar SHALL show 0% fill

---

### Requirement: HUD SHALL flash a damage vignette on player damage

A red-tinted screen overlay SHALL briefly flash when the player takes damage.

#### Scenario: Damage vignette on hit
- **Given** a player that takes damage
- **When** Events.player_damaged is emitted
- **Then** a red semi-transparent overlay SHALL appear on screen
- **And** the overlay SHALL fade out over ~0.3 seconds

#### Scenario: Multiple rapid hits
- **Given** a player taking damage multiple times quickly
- **When** each Events.player_damaged is emitted
- **Then** the vignette SHALL reset to full opacity each time
- **And** the fade SHALL restart

---

### Requirement: HUD SHALL show a death screen on player death

When the player dies, a death overlay SHALL appear with restart option.

#### Scenario: Player dies
- **Given** a player whose health reaches 0
- **When** Events.player_died is emitted
- **Then** a death overlay SHALL fade in over ~0.5 seconds
- **And** "You Died" text SHALL be displayed
- **And** a "Restart" button SHALL be visible

#### Scenario: Restart button reloads scene
- **Given** the death screen is visible
- **When** the player clicks the Restart button
- **Then** the current scene SHALL be reloaded
- **And** all game state SHALL reset

---

### Requirement: HUD SHALL display a score counter
The HUD SHALL show the player's current score, incrementing on enemy kills.

#### Scenario: Score display
- **GIVEN** the HUD is visible
- **WHEN** the game starts
- **THEN** a score label SHALL be displayed anchored to the top-right
- **AND** the score SHALL start at 0

#### Scenario: Score increments on kill
- **GIVEN** the score is currently 0
- **WHEN** an enemy is killed
- **THEN** the score SHALL increment by the enemy's point value
- **AND** the score label SHALL update immediately

#### Scenario: Score shown on death
- **GIVEN** the player has a score of N
- **WHEN** the player dies
- **THEN** the death screen SHALL display the final score

---

### Requirement: HUD SHALL provide a pause menu
An Escape-key pause menu SHALL allow the player to resume, restart, or quit.

#### Scenario: Pause on Escape
- **GIVEN** the game is running
- **WHEN** the player presses Escape
- **THEN** the game SHALL pause (time scale stops)
- **AND** a pause overlay SHALL appear with "PAUSED" text
- **AND** Resume, Restart, and Quit buttons SHALL be visible

#### Scenario: Resume unpauses
- **GIVEN** the pause menu is visible
- **WHEN** the player clicks Resume or presses Escape again
- **THEN** the game SHALL unpause
- **AND** the pause overlay SHALL hide

#### Scenario: Restart from pause
- **GIVEN** the pause menu is visible
- **WHEN** the player clicks Restart
- **THEN** the game SHALL unpause and reload the current scene

#### Scenario: Quit from pause
- **GIVEN** the pause menu is visible
- **WHEN** the player clicks Quit
- **THEN** the application SHALL exit

