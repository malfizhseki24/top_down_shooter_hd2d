# Tasks

## Setup
- [x] Buat folder `resources/mesh_libraries/` untuk MeshLibrary
- [x] Buat how-to guide untuk editor tasks (`docs/howto-meshlibrary.md`)

## Asset Selection (See how-to guide)
- [ ] Review Kenney Nature Kit contents
- [ ] Identify ground/floor tiles (ground_grass, ground_dirt, platform_grass)
- [ ] Identify tree assets (tree_pine, tree_simple, tree_palm)
- [ ] Identify rock/stone assets (rock_small, rock_large, stone_small)
- [ ] Identify plant/foliage assets (plant_bush, grass_leafs, flower)
- [ ] Identify mushroom assets (mushroom_red, mushroom_tan)

## MeshLibrary Creation (Editor Tasks - Follow how-to guide)
- [ ] Buat MeshLibrary resource file `nature_kit.meshlib`
- [ ] Add ground tiles ke MeshLibrary (Item 0-4) + Convex Collision
- [ ] Add trees ke MeshLibrary (Item 5-9) + Convex Collision
- [ ] Add rocks/stones ke MeshLibrary (Item 10-14) + Convex Collision
- [ ] Add plants/foliage ke MeshLibrary (Item 15-19) - No collision
- [ ] Add mushrooms ke MeshLibrary (Item 20-22) - No collision
- [ ] Generate thumbnails untuk semua items
- [ ] Save MeshLibrary resource

## Validation
- [ ] Test MeshLibrary load di GridMap
- [ ] Verify palette visible di GridMap editor
- [ ] Verify collision works pada placed meshes
