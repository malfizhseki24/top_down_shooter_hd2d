# player-hud Specification Delta

## ADDED Requirements

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
