# collision-system Specification

## Purpose
TBD - created by archiving change add-hitbox-hurtbox-system. Update Purpose after archive.
## Requirements
### Requirement: HitboxComponent SHALL detect overlaps with HurtboxComponent

HitboxComponent MUST be an Area3D-based component that emits signals when overlapping valid hurtboxes.

#### Scenario: Hitbox overlaps enemy hurtbox
- **Given** a HitboxComponent with collision_layer=8 (PlayerProjectile)
- **And** collision_mask=64 (EnemyHurtbox)
- **And** an enemy HurtboxComponent with collision_layer=64
- **When** the hitbox overlaps the hurtbox
- **Then** the `area_entered` signal SHALL be emitted
- **And** the hitbox MAY emit a `hit_hurtbox` signal

#### Scenario: Hitbox ignores same-faction hurtboxes
- **Given** a player HitboxComponent with collision_mask=64 (EnemyHurtbox only)
- **And** a player HurtboxComponent with collision_layer=32
- **When** the hitbox overlaps the player hurtbox
- **Then** no signal SHALL be emitted
- **And** the hitbox SHALL pass through without detection

---

### Requirement: HurtboxComponent SHALL receive damage signals

HurtboxComponent MUST be an Area3D-based component that can be detected by hitboxes and emit damage_received signals.

#### Scenario: Hurtbox receives hit from hitbox
- **Given** a HurtboxComponent with collision_layer=64 (EnemyHurtbox)
- **And** monitoring=true and monitorable=true
- **When** a hitbox overlaps the hurtbox
- **Then** the hurtbox SHALL emit `damage_received` signal
- **And** the signal SHALL include reference to the hitbox

#### Scenario: Hurtbox can be disabled for i-frames
- **Given** a HurtboxComponent
- **And** the hurtbox monitoring is enabled
- **When** `set_deferred("monitoring", false)` is called
- **Then** the hurtbox SHALL NOT detect hitboxes
- **And** no damage SHALL be received

---

### Requirement: Arrows SHALL stop on world geometry collision

Arrows MUST detect collision with static world geometry (trees, rocks, walls) and stop/despawn immediately.

#### Scenario: Arrow hits tree obstacle
- **Given** an arrow traveling toward a tree
- **And** the tree is on Layer 1 (World)
- **And** arrow collision_mask includes Layer 1
- **When** the arrow collides with the tree
- **Then** the arrow SHALL stop moving immediately
- **And** the arrow SHALL despawn (return to pool)

#### Scenario: Arrow hits rock obstacle
- **Given** an arrow traveling toward a rock
- **And** the rock is on Layer 1 (World)
- **When** the arrow collides with the rock
- **Then** the arrow SHALL stop moving immediately
- **And** the arrow SHALL despawn (return to pool)

#### Scenario: Arrow passes through empty space
- **Given** an arrow traveling in open air
- **And** no obstacles in the arrow's path
- **When** the arrow lifetime has not expired
- **Then** the arrow SHALL continue moving
- **And** the arrow SHALL NOT despawn prematurely

---

### Requirement: Arrow collision_mask SHALL include world layer

Arrows MUST have Layer 1 (World) in their collision_mask to detect static geometry.

#### Scenario: Arrow collision configuration
- **Given** an arrow scene in the editor
- **When** the collision_mask is inspected
- **Then** Layer 1 (World) SHALL be enabled
- **And** Layer 7 (EnemyHurtbox) SHALL be enabled
- **And** the collision_mask value SHALL be 65 (1 + 64)

#### Scenario: Arrow does not collide with player
- **Given** an arrow spawned by the player
- **And** the player hurtbox on Layer 6
- **And** arrow collision_mask does not include Layer 6
- **When** the arrow is near the player
- **Then** the arrow SHALL NOT detect the player
- **And** the arrow SHALL NOT despawn from player proximity

---

### Requirement: Collision layers SHALL follow GDD specification

All collision layers MUST be configured according to the GDD Phase 3.3 specification.

#### Scenario: Layer configuration reference
- **Given** the collision system is implemented
- **When** reviewing layer assignments
- **Then** Layer 1 SHALL be World (static geometry)
- **And** Layer 2 SHALL be Player (physics body)
- **And** Layer 3 SHALL be Enemy (physics bodies)
- **And** Layer 4 SHALL be PlayerProjectile (bit value 8)
- **And** Layer 5 SHALL be EnemyProjectile (bit value 16)
- **And** Layer 6 SHALL be PlayerHurtbox (bit value 32)
- **And** Layer 7 SHALL be EnemyHurtbox (bit value 64)

