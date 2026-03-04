# health-system Specification

**Engine**: Godot 4.x (tested with Godot 4.6)

## Purpose

Provides a reusable HealthComponent for managing entity health (player, enemies, NPCs). Enables damage reception, healing, invulnerability frames, and death signals for game state integration.

## ADDED Requirements

### Requirement: HealthComponent SHALL manage entity health

HealthComponent MUST be a reusable Node-based component that tracks current health and emits signals on health changes.

#### Scenario: Health initializes from max_health
- **Given** a HealthComponent with max_health=5
- **When** the component is ready
- **Then** current_health SHALL be initialized to 5
- **And** the component SHALL be ready to receive damage

#### Scenario: Health clamps to valid range
- **Given** a HealthComponent with max_health=3 and current_health=3
- **When** take_damage(10) is called
- **Then** current_health SHALL be 0
- **And** current_health SHALL NOT be negative

---

### Requirement: HealthComponent SHALL emit health_changed signal

The component MUST emit a signal whenever health changes, enabling UI and game systems to react.

#### Scenario: Damage emits health_changed signal
- **Given** a HealthComponent with current_health=3
- **And** a signal handler connected to health_changed
- **When** take_damage(1) is called
- **Then** health_changed signal SHALL be emitted
- **And** signal parameters SHALL be (new_health=2, old_health=3)

#### Scenario: Heal emits health_changed signal
- **Given** a HealthComponent with current_health=1 and max_health=3
- **And** a signal handler connected to health_changed
- **When** heal(1) is called
- **Then** health_changed signal SHALL be emitted
- **And** signal parameters SHALL be (new_health=2, old_health=1)

#### Scenario: No signal when health unchanged
- **Given** a HealthComponent with is_invulnerable=true
- **And** a signal handler connected to health_changed
- **When** take_damage(1) is called
- **Then** health_changed signal SHALL NOT be emitted

---

### Requirement: HealthComponent SHALL emit died signal at zero health

The component MUST emit a died signal exactly once when health reaches zero.

#### Scenario: died signal emitted at zero health
- **Given** a HealthComponent with current_health=1
- **And** a signal handler connected to died
- **When** take_damage(1) is called
- **Then** died signal SHALL be emitted
- **And** current_health SHALL be 0

#### Scenario: died signal not emitted on overkill
- **Given** a HealthComponent with current_health=0
- **And** died signal already emitted
- **When** take_damage(5) is called
- **Then** died signal SHALL NOT be emitted again

#### Scenario: died signal not emitted on heal from zero
- **Given** a HealthComponent with current_health=0
- **And** a signal handler connected to died
- **When** heal(1) is called
- **Then** died signal SHALL NOT be emitted
- **And** current_health SHALL be 1

---

### Requirement: HealthComponent SHALL support healing

The component MUST provide a heal() method to restore health, clamping to max_health.

#### Scenario: Heal restores health
- **Given** a HealthComponent with current_health=1 and max_health=3
- **When** heal(2) is called
- **Then** current_health SHALL be 3
- **And** health_changed signal SHALL be emitted with (3, 1)

#### Scenario: Heal clamps to max_health
- **Given** a HealthComponent with current_health=2 and max_health=3
- **When** heal(10) is called
- **Then** current_health SHALL be 3
- **And** current_health SHALL NOT exceed max_health

---

### Requirement: HealthComponent SHALL support invulnerability

The component MUST allow toggling invulnerability to block damage.

#### Scenario: Invulnerability blocks damage
- **Given** a HealthComponent with current_health=3
- **And** is_invulnerable=true
- **When** take_damage(1) is called
- **Then** current_health SHALL remain 3
- **And** health_changed signal SHALL NOT be emitted

#### Scenario: Vulnerability allows damage
- **Given** a HealthComponent with current_health=3
- **And** is_invulnerable=false
- **When** take_damage(1) is called
- **Then** current_health SHALL be 2
- **And** health_changed signal SHALL be emitted

---

### Requirement: Entities SHALL connect HurtboxComponent to HealthComponent

Entities with both HurtboxComponent and HealthComponent MUST connect damage signals.

#### Scenario: Player takes damage from enemy projectile
- **Given** a player with HurtboxComponent on Layer 6
- **And** a HealthComponent attached
- **And** the hurtbox damage_received signal connected to health.take_damage
- **When** an enemy projectile HitboxComponent overlaps the player hurtbox
- **Then** HealthComponent.take_damage SHALL be called
- **And** player health SHALL decrease

#### Scenario: Enemy takes damage from player projectile
- **Given** an enemy with HurtboxComponent on Layer 7
- **And** a HealthComponent attached
- **And** the hurtbox damage_received signal connected to health.take_damage
- **When** a player arrow HitboxComponent overlaps the enemy hurtbox
- **Then** HealthComponent.take_damage SHALL be called
- **And** enemy health SHALL decrease

---

### Requirement: HealthComponent max_health SHALL be configurable

The component MUST allow designers to configure max_health via Inspector.

#### Scenario: max_health configurable in Inspector
- **Given** a designer places HealthComponent on an entity
- **When** the Inspector is viewed
- **Then** Max Health property SHALL be visible
- **And** the default value SHALL be 3

#### Scenario: Different entities have different max_health
- **Given** a player with HealthComponent max_health=10
- **And** a basic enemy with HealthComponent max_health=3
- **When** both entities take 3 damage
- **Then** the player SHALL have 7 health remaining
- **And** the enemy SHALL have 0 health (dead)

---

### Requirement: HealthComponent SHALL provide health percentage

The component MUST provide a method to get health as a percentage (0.0 to 1.0) for UI health bars.

#### Scenario: get_health_percent returns correct ratio
- **Given** a HealthComponent with current_health=2 and max_health=10
- **When** get_health_percent() is called
- **Then** the return value SHALL be 0.2 (20%)

#### Scenario: get_health_percent at full health
- **Given** a HealthComponent with current_health=5 and max_health=5
- **When** get_health_percent() is called
- **Then** the return value SHALL be 1.0 (100%)

#### Scenario: get_health_percent at zero health
- **Given** a HealthComponent with current_health=0 and max_health=5
- **When** get_health_percent() is called
- **Then** the return value SHALL be 0.0 (0%)

---

### Requirement: Enemy SHALL use HealthComponent for health tracking

The enemy_base.gd MUST use HealthComponent for managing health instead of inline variables.

#### Scenario: Enemy uses HealthComponent for health tracking
- **Given** an enemy_base scene
- **And** a HealthComponent child node exists
- **When** the enemy takes damage
- **Then** HealthComponent.take_damage SHALL be called
- **And** inline health variables SHALL be removed

#### Scenario: Enemy dies via HealthComponent signal
- **Given** an enemy with HealthComponent
- **And** the enemy connects to health.died signal
- **When** health reaches 0
- **Then** the died signal SHALL trigger enemy.queue_free()

---

## Cross-References

- **Depends on**: collision-system (HurtboxComponent and HitboxComponent)
- **Enables**: player-dash (i-frames via is_invulnerable)
- **Enables**: Future UI health bar system
- **Enables**: Future game state management (death handling)
