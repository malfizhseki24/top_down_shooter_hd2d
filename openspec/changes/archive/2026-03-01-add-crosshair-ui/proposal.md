# add-crosshair-ui

## Summary
Implementasi crosshair UI yang mengikuti posisi mouse cursor untuk twin-stick shooter aiming system.

## Motivation
GDD Phase 1.6 - Crosshair UI diperlukan untuk memberikan visual feedback pada player saat aiming. Crosshair mengindikasikan titik target di layar dan meningkatkan game feel.

## Scope
- Membuat crosshair sprite asset (simple 4-dot atau cross design)
- Membuat HUD scene dengan CanvasLayer
- Crosshair mengikuti mouse position
- Hide default OS mouse cursor

## Out of Scope
- HP bar (Phase 4.4)
- Score counter (Phase 4.4)
- Pause menu (Phase 4.4)
- Shooting mechanic (Phase 3.1)

## Related Specs
- `mouse-aiming` - Crosshair bekerja bersama aiming system yang sudah ada

## Acceptance Criteria
- [ ] Crosshair visible dan mengikuti mouse
- [ ] Default mouse cursor tersembunyi
- [ ] Crosshair tidak terhalang oleh 3D elements (di layer UI paling atas)
