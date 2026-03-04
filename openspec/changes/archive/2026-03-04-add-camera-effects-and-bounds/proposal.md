# Proposal: Add Camera Effects & Bounds

## Why
The camera needs two improvements from GDD Phase 4.2:
1. **Camera effects** — screen shake on shoot and dash for better game feel (shoot shake & dash shake are missing; hit/kill shake already exists).
2. **Camera bounds** — the camera should stop following the player at map edges so areas outside the map are never visible, preserving immersion.

## What Changes

### 1. Camera Shake on Shoot (small)
A subtle shake each time the player fires, adding weight to shooting.

### 2. Camera Shake on Dash (subtle)
A very small shake when the player dashes, reinforcing the burst of speed.

### 3. Camera Bounds / Clamping
Define an AABB (axis-aligned bounding box) for the camera. When the player moves toward a map edge, the camera stops scrolling so nothing beyond the map boundary is shown. The bounds are configurable per-level via `@export` properties.

**Affected files:**
- `scripts/camera/camera_follow.gd` — add bounds clamping + new shake triggers
- `scenes/levels/forest_01.tscn` — configure bound values for current map
