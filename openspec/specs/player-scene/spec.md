# player-scene Specification

## Purpose
TBD - created by archiving change add-player-scene. Update Purpose after archive.
## Requirements
### Requirement: Player Root Node

The Player SHALL use CharacterBody3D as the root node to support physics-based movement.

#### Scenario: Instance player scene ke level
- **Given** player.tscn exists di scenes/player/
- **When** player scene di-instance ke level scene
- **Then** player SHALL have CharacterBody3D as root
- **And** player SHALL be positionable in 3D space

---

### Requirement: Sprite3D Billboard Visual

The Player MUST have a Sprite3D with Y-Billboard mode for HD-2D aesthetic.

#### Scenario: Sprite menghadap kamera
- **Given** player memiliki Sprite3D child
- **When** camera bergerak atau berputar
- **Then** sprite SHALL always face the camera on Y-axis
- **And** sprite SHALL remain upright (no X/Z rotation)

#### Scenario: Placeholder texture visible
- **Given** Sprite3D menggunakan icon.svg sebagai texture
- **When** game di-run
- **Then** placeholder sprite SHALL be visible di viewport
- **And** sprite SHALL be centered di player position

---

### Requirement: Collision Shape untuk Physics

The Player MUST have a CylinderShape3D collision to interact with the world.

#### Scenario: Collision dengan ground
- **Given** player memiliki CollisionShape3D dengan CylinderShape3D
- **When** player di-spawn di atas ground
- **Then** player SHALL NOT fall through ground
- **And** collision radius SHALL be proporsional dengan visual sprite

---

### Requirement: Gun Marker untuk Bullet Spawn

The Player MUST have a marker node to determine bullet spawn point.

#### Scenario: Bullet spawn position
- **Given** player memiliki GunMarker Node3D
- **When** shooting system memerlukan spawn point
- **Then** GunMarker.global_position SHALL be available
- **And** position SHALL be at center player body

---

### Requirement: Hurtbox untuk Damage Reception

The Player MUST have an Area3D hurtbox to receive damage from enemy attacks.

#### Scenario: Enemy bullet mengenai player
- **Given** player memiliki Hurtbox Area3D
- **And** hurtbox collision_mask include enemy bullet layer
- **When** enemy bullet overlap dengan hurtbox
- **Then** area_entered signal SHALL be emitted
- **And** damage SHALL be processable

---

