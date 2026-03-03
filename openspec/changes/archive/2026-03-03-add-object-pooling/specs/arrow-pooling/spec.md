# arrow-pooling Specification

## ADDED Requirements

### Requirement: ObjectPool SHALL provide arrow instance reuse

The ObjectPool autoload singleton MUST manage a pool of pre-instantiated arrows to eliminate runtime allocation overhead.

#### Scenario: Pool prewarms arrows on initialization
- **Given** the game starts
- **And** ObjectPool is registered as autoload
- **When** ObjectPool._ready() executes
- **Then** at least 20 arrow instances SHALL be pre-created
- **And** all instances SHALL be in the available pool

#### Scenario: Acquire returns pooled arrow
- **Given** the arrow pool has available instances
- **When** ObjectPool.acquire("Arrow") is called
- **Then** an arrow instance SHALL be returned
- **And** the arrow SHALL be marked as in-use
- **And** no new allocation SHALL occur

#### Scenario: Release returns arrow to pool
- **Given** an arrow was acquired from the pool
- **And** the arrow is in-use
- **When** ObjectPool.release("Arrow", arrow) is called
- **Then** the arrow SHALL be moved to available pool
- **And** the arrow.reset() method SHALL be called

---

### Requirement: Arrows SHALL support reset for pool reuse

Arrow instances MUST implement a reset() method that clears all state for safe reuse.

#### Scenario: Arrow reset clears lifetime timer
- **Given** an arrow has been traveling for 2 seconds
- **When** arrow.reset() is called
- **Then** _lifetime_timer SHALL be reset to 0.0
- **And** the arrow SHALL be ready for reuse

#### Scenario: Arrow reset clears direction
- **Given** an arrow has direction set to Vector3.RIGHT
- **When** arrow.reset() is called
- **Then** _direction SHALL be reset to Vector3.FORWARD (default)
- **And** set_direction() can be called again

#### Scenario: Arrow despawn uses pool release
- **Given** an arrow lifetime has expired
- **When** the arrow would normally queue_free()
- **Then** ObjectPool.release("Arrow", self) SHALL be called instead
- **And** the arrow SHALL NOT be freed from memory

---

### Requirement: PlayerController SHALL use pool for arrow spawning

The player shooting system MUST acquire arrows from the pool instead of instantiating new scenes.

#### Scenario: Shoot acquires arrow from pool
- **Given** the player presses the shoot button
- **And** shoot cooldown has elapsed
- **When** _shoot() executes
- **Then** ObjectPool.acquire("Arrow") SHALL be called
- **And** arrow_scene.instantiate() SHALL NOT be called

#### Scenario: Pool exhausts during rapid fire
- **Given** all pooled arrows are in-use
- **And** auto_expand is enabled
- **When** ObjectPool.acquire("Arrow") is called
- **Then** a new arrow instance SHALL be created
- **And** a warning SHALL be logged
- **And** the pool size SHALL increase

---

### Requirement: Pool configuration SHALL be tunable

Designers MUST be able to configure pool parameters via Inspector exports.

#### Scenario: Initial pool size is configurable
- **Given** a designer opens project settings
- **When** the designer sets initial_arrow_pool_size to 50
- **Then** 50 arrows SHALL be prewarmed on game start
- **And** the default SHALL be 20

#### Scenario: Max pool size prevents unbounded growth
- **Given** max_pool_size is set to 100
- **And** auto_expand is enabled
- **When** pool attempts to expand beyond 100
- **Then** no new instances SHALL be created
- **And** acquire() SHALL return null
- **And** an error SHALL be logged
