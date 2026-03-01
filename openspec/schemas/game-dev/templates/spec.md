## ADDED Requirements

### Requirement: <!-- Feature/System Name -->
<!-- Clear description of what this feature/system MUST do. Use SHALL for mandatory behavior. -->

#### Scenario: <!-- Scenario name - e.g., "Player shoots weapon" -->
- **GIVEN** <!-- Initial game state (optional) -->
- **WHEN** <!-- Player action or game event -->
- **THEN** <!-- Expected game behavior -->

#### Scenario: <!-- Edge case or alternative path -->
- **GIVEN** <!-- Initial game state -->
- **WHEN** <!-- Different action or condition -->
- **THEN** <!-- Different expected result -->

---

## Example (Reference):

### Requirement: Player Double Jump
The player SHALL be able to perform a second jump while airborne, but only once per air time.

#### Scenario: Successful double jump
- **GIVEN** player is in the air after first jump
- **WHEN** player presses jump button again
- **THEN** player gains additional upward velocity
- **AND** cannot jump again until landing

#### Scenario: Double jump depleted
- **GIVEN** player has already used double jump
- **WHEN** player presses jump button
- **THEN** no jump occurs

#### Scenario: Double jump resets on landing
- **GIVEN** player has used double jump
- **WHEN** player lands on ground
- **THEN** double jump becomes available again
