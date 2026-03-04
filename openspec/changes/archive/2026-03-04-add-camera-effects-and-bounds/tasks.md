# Tasks

- [x] **T1: Camera Shake on Shoot**
  - File: `scripts/camera/camera_follow.gd`
  - Connect to shoot event (add `player_shot` signal to Events if missing)
  - Call `shake(0.03)` on shoot — very subtle
  - Validate: shooting feels punchier without being distracting

- [x] **T2: Camera Shake on Dash**
  - File: `scripts/camera/camera_follow.gd`
  - Connect to dash event (add `player_dashed` signal to Events if missing)
  - Call `shake(0.04)` on dash start
  - Validate: dash has a subtle screen kick

- [x] **T3: Camera Bounds Clamping**
  - File: `scripts/camera/camera_follow.gd`
  - Add `@export var use_bounds: bool = false`
  - Add `@export var bounds_min: Vector3` and `@export var bounds_max: Vector3`
  - After lerp follow, clamp `global_position.x` and `global_position.z` (accounting for orthographic half-extents) so viewport edges never exceed bounds
  - Validate: move player to all 4 corners of map, camera stops at edges

- [x] **T4: Configure Forest Level Bounds**
  - File: `scenes/levels/forest_01.tscn`
  - Enable `use_bounds = true` on Camera3D node
  - Set `bounds_min` and `bounds_max` to match the forest_01 GridMap extents
  - Validate: no void/empty space visible at any map edge
