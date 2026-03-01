# project-architecture Specification

## Purpose
TBD - created by archiving change add-project-foundation. Update Purpose after archive.
## Requirements
### Requirement: Project Folder Structure
Project SHALL memiliki struktur folder yang terorganisir sesuai GDD untuk memudahkan development dan maintenance.

#### Scenario: Folder structure created
- **GIVEN** project baru dibuat
- **WHEN** developer membuka FileSystem
- **THEN** semua folder berikut ada: `scenes/`, `scripts/`, `assets/`, `resources/`
- **AND** subfolder `scripts/autoload/`, `scripts/player/`, `scripts/enemies/`, `scripts/utils/` ada
- **AND** subfolder `scenes/player/`, `scenes/enemies/`, `scenes/effects/`, `scenes/ui/`, `scenes/levels/` ada
- **AND** subfolder `assets/3d/`, `assets/sprites/`, `assets/audio/`, `assets/shaders/` ada

#### Scenario: Asset folder has .gdignore
- **GIVEN** folder assets/ berisi file non-code
- **WHEN** Godot scanning project
- **THEN** folder assets/ memiliki file .gdignore
- **AND** Godot tidak mem-scan folder tersebut untuk GDScript

---

### Requirement: Game Autoload Singleton
Project SHALL memiliki autoload singleton `Game` untuk mengelola global game state.

#### Scenario: Game autoload registered
- **GIVEN** project settings
- **WHEN** game di-run
- **THEN** `Game` singleton tersedia dan dapat diakses dari scene manapun
- **AND** `Game` memiliki state enum (MENU, PLAYING, PAUSED, GAME_OVER)

#### Scenario: Game state changeable
- **GIVEN** Game singleton aktif
- **WHEN** memanggil `Game.change_state(newState)`
- **THEN** state berubah
- **AND** signal `state_changed` ter-emit

---

### Requirement: Events Autoload Singleton
Project SHALL memiliki autoload singleton `Events` sebagai global event bus untuk komunikasi decoupled antar sistem.

#### Scenario: Events autoload registered
- **GIVEN** project settings
- **WHEN** game di-run
- **THEN** `Events` singleton tersedia dan dapat diakses dari scene manapun

#### Scenario: Global signals available
- **GIVEN** Events singleton aktif
- **WHEN** developer membuka Events.gd
- **THEN** signal berikut tersedia: `enemy_spawned`, `enemy_killed`, `player_damaged`, `score_changed`

---

### Requirement: Input Map Configuration
Project SHALL memiliki input map yang terkonfigurasi untuk gameplay controls.

#### Scenario: Movement inputs configured
- **GIVEN** Project Settings > Input Map
- **WHEN** developer membuka input map
- **THEN** input actions berikut ada: `move_up`, `move_down`, `move_left`, `move_right`
- **AND** masing-masing ter-map ke WASD keys

#### Scenario: Action inputs configured
- **GIVEN** Project Settings > Input Map
- **WHEN** developer membuka input map
- **THEN** input actions berikut ada: `dash`, `shoot`
- **AND** `dash` ter-map ke Space key
- **AND** `shoot` ter-map ke Mouse Left Button

#### Scenario: Input readable in code
- **GIVEN** input map sudah dikonfigurasi
- **WHEN** memanggil `Input.get_vector("move_left", "move_right", "move_up", "move_down")`
- **THEN** return Vector2 dengan nilai berdasarkan WASD input

---

### Requirement: Rendering Configuration
Project SHALL dikonfigurasi dengan rendering settings yang sesuai untuk HD-2D style.

#### Scenario: Forward+ renderer enabled
- **GIVEN** Project Settings
- **WHEN** developer membuka Rendering > Renderer > Rendering Method
- **THEN** value adalah "Forward+"

#### Scenario: Window size configured
- **GIVEN** Project Settings
- **WHEN** developer membuka Display > Window
- **THEN** Window Width adalah 1920
- **AND** Window Height adalah 1080
- **AND** Mode adalah "windowed" atau "fullscreen"

