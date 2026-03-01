# Project Kasuari

A **HD-2D Top-Down Twin-Stick Shooter** built with Godot 4.6, featuring Papua folklore themes and the legendary Cassowary spirit.

## Overview

Project Kasuari is a top-down action game where players control a warrior (or the embodiment of the Cassowary spirit) clearing sacred forests from dark entities using magical projectile attacks and agile maneuvers.

### Visual Style
- **HD-2D**: 2D pixel art sprites in a 3D modular environment
- **Atmospheric**: Bioluminescent fungi, god rays, ambient particles
- **Post-Processing**: DoF, SSAO, bloom, vignette

## Features

### Implemented (Phase 1)
- [x] Player movement (WASD) in 3D space (X-Z axis)
- [x] Mouse aiming with sprite orientation
- [x] Smooth camera follow system
- [x] Crosshair UI with hidden cursor

### Planned
- [ ] Shooting mechanics
- [ ] Dash with i-frames
- [ ] Enemy AI and spawning
- [ ] Health system
- [ ] Wave-based gameplay
- [ ] Full Papua-themed sprites

## Controls

| Input | Action |
|-------|--------|
| **WASD** | Movement |
| **Mouse** | Aim |
| **Left Click** | Shoot (planned) |
| **Space** | Dash (planned) |

## Tech Stack

- **Engine**: Godot 4.6
- **Language**: GDScript
- **Renderer**: Forward+
- **3D Assets**: Kenney Nature Kit (CC0)
- **Architecture**: Component-based with autoload singletons

## Project Structure

```
res://
├── scenes/
│   ├── player/          # Player scene and components
│   ├── enemies/         # Enemy templates
│   ├── effects/         # VFX scenes
│   ├── ui/              # HUD, crosshair
│   └── levels/          # Game levels
├── scripts/
│   ├── autoload/        # Game, Events, ObjectPool
│   ├── player/          # Player controllers
│   ├── enemies/         # Enemy AI
│   └── ui/              # UI scripts
├── assets/
│   ├── 3d/              # Kenney Nature Kit
│   ├── sprites/         # 2D character sprites
│   └── audio/           # SFX and music
└── resources/           # Weapon resources
```

## Getting Started

1. Clone the repository
2. Open project in Godot 4.6+
3. Run `scenes/levels/test_player.tscn` to test

## Documentation

- [Game Design Document](docs/gdd.md)
- [OpenSpec Specifications](openspec/specs/)

## License

This project is for educational/prototyping purposes. 3D assets from Kenney Nature Kit are CC0.
