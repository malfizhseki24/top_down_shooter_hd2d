## Game Design Context

Phase 2.1 dari GDD Production Pipeline - Kenney Nature Kit Integration. Ini adalah tahap persiapan assets untuk level building dengan GridMap.

## Design Goals

**Core Experience:**
Level designer dapat dengan cepat membangun environment menggunakan palette organized assets.

**Goals:**
- MeshLibrary dengan kategori yang jelas
- Collision-enabled meshes untuk ground
- Consistent scale dan pivot points

**Non-Goals:**
- Custom materials (gunakan default dari .obj)
- LOD system
- Material variations

## Technical Design

### MeshLibrary Structure

```
Item Index | Category | Asset Name
-----------|----------|------------------
0-4        | Ground   | ground_grass, ground_dirt, platform_grass, path_stone, ground_pathCross
5-9        | Trees    | tree_pineTallA, tree_pineSmallA, tree_simple, tree_palmTall, tree_plateau
10-14      | Rocks    | rock_largeA, rock_smallA, stone_smallA, rock_tallA, stone_largeA
15-19      | Plants   | plant_bush, plant_bushSmall, grass_leafs, flower_yellowA, plant_bushDetailed
20-22      | Mushrooms| mushroom_red, mushroom_tan, mushroom_redTall
```

### Import Settings

**For Ground Tiles:**
```
Mesh: Generate
Collision: Convex (untuk walkable surface)
Scale: 1.0 (default Kenney scale)
```

**For Trees:**
```
Mesh: Generate
Collision: Simple convex (untuk trunk collision)
Scale: 1.0
```

**For Rocks:**
```
Mesh: Generate
Collision: Convex
Scale: 1.0
```

### GridMap Cell Size

Based on Kenney asset scale:
```
Cell Size: Vector3(1, 1, 1)
Mesh Library items occupy 1x1 cell for ground
Trees may be larger but centered on 1x1
```

## Implementation Notes

### Creating MeshLibrary in Godot 4

1. **Manual Method (Recommended for MVP):**
   - Create new MeshLibrary resource
   - Drag meshes from FileSystem to MeshLibrary editor
   - Configure collision for each item
   - Generate thumbnails

2. **Programmatic Method (Future):**
   - Use EditorScript to batch process
   - More complex, not needed for MVP

### Collision Considerations

**Ground Tiles:**
- Need convex collision untuk player movement
- Trimesh terlalu expensive untuk simple ground

**Trees & Rocks:**
- Simple convex collision
- Player tidak bisa walk through

**Plants & Mushrooms:**
- No collision (decorative only)
- OR very small collision untuk large bushes

## Asset Selection Rationale

**Trees:**
- `tree_pineTallA` - Tall pine untuk forest border
- `tree_pineSmallA` - Smaller variation
- `tree_simple` - Generic deciduous
- `tree_palmTall` - Tropical variety
- `tree_plateau` - Unique shape untuk visual interest

**Ground:**
- `ground_grass` - Main terrain
- `ground_dirt` - Path variation
- `platform_grass` - Elevated platform
- `path_stone` - Stone path
- `ground_pathCross` - Intersection

**Rocks:**
- `rock_largeA-C` - Large cover objects
- `rock_smallA-C` - Small scatter
- `stone_smallA-C` - Tiny details

## Risks / Trade-offs

| Risk | Impact | Mitigation |
|------|--------|------------|
| Too many items in library | Medium | Start with ~20 items, add more as needed |
| Collision too complex | Medium | Use convex, not trimesh |
| Inconsistent scale | Low | Kenney assets are uniform |

## Open Questions

- [x] Manual vs programmatic MeshLibrary? → Manual untuk MVP
- [x] How many items per category? → ~5 per category, total ~20
- [x] Collision for all items? → Ground + obstacles, not decorations

## References

- GDD Section 6 - Phase 2.1 Kenney Nature Kit Integration
- Godot 4 Docs - MeshLibrary
- Godot 4 Docs - GridMap
- Kenney Nature Kit License (CC0)
