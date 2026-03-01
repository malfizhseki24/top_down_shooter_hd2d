## Game Design Context

Phase 1.6 dari GDD Production Pipeline - Crosshair UI. Ini adalah komponen visual untuk aiming feedback di twin-stick shooter.

## Design Goals

**Core Experience:**
Player mendapat visual feedback jelas tentang dimana mereka sedang aiming melalui crosshair yang mengikuti mouse cursor.

**Goals:**
- Crosshair sprite simple tapi visible
- Crosshair selalu di posisi mouse
- Default OS cursor tersembunyi untuk immersion

**Non-Goals:**
- Dynamic crosshair (spread indicator)
- Crosshair color changes based on target
- Hit marker feedback

## Technical Design

### Scene Structure

```
HUD (CanvasLayer)
├── Crosshair (TextureRect or Control)
```

### Crosshair Follow Implementation

**Option A: TextureRect with _process (Chosen)**
```gdscript
extends CanvasLayer

@onready var crosshair: TextureRect = $Crosshair

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(_delta: float) -> void:
    crosshair.global_position = get_viewport().get_mouse_position() - crosshair.size / 2
```

**Option B: Custom Cursor Image**
```gdscript
Input.set_custom_mouse_cursor(crosshair_texture)
```
- Simpler tapi kurang fleksibel
- Tidak bisa animasi
- Tidak bisa easy style changes runtime

### Crosshair Asset

**Simple 4-Dot Design:**
```
  ·
·   ·
  ·
```
- Size: 32x32 pixels
- Color: White with black outline (visible on all backgrounds)
- Format: PNG with transparency

**Alternative: Cross Design:**
```
  |
- + -
  |
```
- More traditional FPS style

### Layer Ordering

CanvasLayer ensures crosshair renders on top of all 3D content:
- CanvasLayer default layer: 0
- No need for special z-index
- Always visible regardless of camera

## Implementation Notes

### Why CanvasLayer Instead of Direct Control?

**CanvasLayer Benefits:**
- Independent from camera movement
- Renders on top of 3D viewport
- Proper 2D coordinate system

**Without CanvasLayer:**
- Would need to convert 3D coordinates
- Might get occluded by 3D objects
- More complex setup

### Mouse Mode Options

```gdscript
Input.MOUSE_MODE_VISIBLE   # Default OS cursor
Input.MOUSE_MODE_HIDDEN    # Hide cursor, allow movement
Input.MOUSE_MODE_CAPTURED  # Hide + center cursor (FPS style)
Input.MOUSE_MODE_CONFINED  # Confine to window
```

For twin-stick shooter: `MOUSE_MODE_HIDDEN` is correct choice.

## Risks / Trade-offs

| Risk | Impact | Mitigation |
|------|--------|------------|
| Crosshair terlalu kecil/besar | Low | Make size configurable via export |
| Tidak visible di background tertentu | Medium | Add subtle outline/shadow |
| Performance (update tiap frame) | Very Low | Viewport.get_mouse_position() is fast |

## Open Questions

- [x] CanvasLayer vs set_custom_mouse_cursor? → CanvasLayer untuk fleksibilitas
- [x] Cross design vs 4-dot? → Mulai dengan simple 4-dot
- [x] TextureRect vs Control? → TextureRect untuk simplicity

## References

- GDD Section 6 - Phase 1.6 Crosshair UI
- Godot 4 Docs - CanvasLayer
- Godot 4 Docs - Input.mouse_mode
