# combat-vfx Specification

## Purpose
Combat visual effects that enhance game feel and impact feedback — hit pause and improved impact effects.

## ADDED Requirements

### Requirement: Hit Pause on Impact
The game SHALL briefly freeze (hit pause) when significant combat events occur to emphasize impact.

#### Scenario: Hit Pause on Player Damage
- **GIVEN** the player takes damage from an enemy or projectile
- **WHEN** the damage event fires
- **THEN** Engine.time_scale SHALL be set to 0.0 for approximately 50ms (3 frames at 60fps)
- **AND** all game objects SHALL freeze during the pause
- **AND** a recovery timer with process_mode PROCESS_MODE_ALWAYS SHALL restore time_scale to 1.0
- **AND** the screen shake SHALL trigger after the pause ends

#### Scenario: Hit Pause on Enemy Kill
- **GIVEN** an enemy's health reaches zero from a player attack
- **WHEN** the enemy_killed event fires
- **THEN** Engine.time_scale SHALL be set to 0.05 for approximately 30ms (shorter than player damage)
- **AND** the brief slowdown SHALL emphasize the kill
- **AND** time_scale SHALL return to 1.0 smoothly

#### Scenario: Hit Pause Does Not Stack
- **GIVEN** a hit pause is already active (Engine.time_scale < 1.0)
- **WHEN** another combat event fires
- **THEN** the pause SHALL extend to the longer duration
- **AND** multiple pauses SHALL NOT compound (time_scale stays at the floor value)

#### Scenario: Hit Pause Does Not Break Timers
- **GIVEN** hit pause sets Engine.time_scale to 0.0
- **WHEN** the freeze duration elapses
- **THEN** all tweens SHALL resume correctly
- **AND** all particle systems SHALL resume correctly
- **AND** no gameplay state SHALL be corrupted by the pause
