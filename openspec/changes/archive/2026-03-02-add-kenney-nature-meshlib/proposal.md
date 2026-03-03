# add-kenney-nature-meshlib

## Summary
Membuat MeshLibrary dari Kenney Nature Kit assets untuk digunakan dengan GridMap dalam level building.

## Why
GDD Phase 2.1 - MeshLibrary diperlukan untuk membangun level dengan GridMap system. Tanpa MeshLibrary, kita tidak bisa secara efisien men-paint terrain dan environment di editor.

## What Changes
- Memilih assets yang relevan dari Kenney Nature Kit (trees, rocks, ground, plants)
- Membuat MeshLibrary resource dengan kategori yang terorganisir
- Setup import settings yang konsisten untuk semua mesh

## Scope
- Review dan seleksi asset (trees, rocks, ground tiles, plants, mushrooms)
- Buat MeshLibrary resource di `resources/mesh_libraries/`
- Organisir item dengan nama yang jelas dan thumbnail

## Out of Scope
- GridMap setup (Phase 2.2)
- Level assembly (Phase 2.3)
- Lighting setup (Phase 2.4)
- Post-processing (Phase 2.5)

## Related Specs
- `project-architecture` - MeshLibrary disimpan sesuai struktur folder

## Acceptance Criteria
- [ ] MeshLibrary berisi minimal 15 items (ground, trees, rocks, plants)
- [ ] Semua mesh memiliki collision yang benar
- [ ] MeshLibrary dapat di-assign ke GridMap node
