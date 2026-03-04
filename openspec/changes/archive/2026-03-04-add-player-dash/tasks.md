# Tasks: Add Player Dash Mechanic

## Implementation Order

### 1. Add Dash Export Variables
- [x] Add `@export var dash_speed: float = 15.0` to player_controller.gd
- [x] Add `@export var dash_duration: float = 0.2` to player_controller.gd
- [x] Add `@export var dash_cooldown: float = 0.5` to player_controller.gd

### 2. Add Dash State Variables
- [x] Add `enum State { NORMAL, DASHING }` to player_controller.gd
- [x] Add `var current_state: State = State.NORMAL`
- [x] Add `var dash_timer: float = 0.0`
- [x] Add `var dash_cooldown_timer: float = 0.0`
- [x] Add `var dash_direction: Vector3 = Vector3.FORWARD`
- [x] Add `var _last_movement_direction: Vector3 = Vector3.FORWARD`

### 3. Add Hurtbox Reference
- [x] Add `@onready var hurtbox: Area3D = $Hurtbox` to player_controller.gd

### 4. Implement Dash State Machine
- [x] Modify `_physics_process()` to handle states with `match current_state:`
- [x] Create `_handle_normal_movement(delta)` function (extract existing movement logic)
- [x] Create `_handle_dash(delta)` function for dash movement

### 5. Implement Dash Input Handling
- [x] Add dash input check in `_input()` or `_unhandled_input()`
- [x] Create `_start_dash()` function
- [x] Create `_end_dash()` function

### 6. Implement I-Frames
- [x] Disable hurtbox monitoring in `_start_dash()`
- [x] Re-enable hurtbox monitoring in `_end_dash()`
- [x] Use `set_deferred()` for thread safety

- [x] Handle animation in `_end_dash()`

### 7. Implement Dash Animation
- [x] Play "dash" animation in `_start_dash()`
- [x] Return to appropriate animation in `_end_dash()` (idle/running)

### 8. Test Dash Mechanics
- [x] Run forest_01 scene
- [x] Test dash with Space key - verify quick movement
- [x] Test dash cooldown - verify cannot spam
- [x] Test i-frames - verify invulnerability during dash
- [x] Test dash direction - verify follows movement or facing
- [x] Test animation - verify dash animation plays
- [x] Verify no console errors

