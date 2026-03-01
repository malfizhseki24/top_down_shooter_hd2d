## 1. Folder Structure

- [x] 1.1 Buat folder `scenes/` di root
- [x] 1.2 Buat subfolder: `scenes/player/`, `scenes/enemies/`, `scenes/effects/`, `scenes/ui/`, `scenes/levels/`
- [x] 1.3 Buat folder `scripts/` di root
- [x] 1.4 Buat subfolder: `scripts/autoload/`, `scripts/player/`, `scripts/enemies/`, `scripts/utils/`
- [x] 1.5 Buat folder `assets/` di root
- [x] 1.6 Buat subfolder: `assets/3d/`, `assets/sprites/`, `assets/audio/sfx/`, `assets/audio/music/`, `assets/shaders/`
- [x] 1.7 Buat folder `resources/` di root
- [x] 1.8 Buat file `.gdignore` kosong di folder `assets/`

## 2. Autoload Singletons

- [x] 2.1 Buat file `scripts/autoload/game.gd`
- [x] 2.2 Implementasi State enum (MENU, PLAYING, PAUSED, GAME_OVER)
- [x] 2.3 Implementasi state_changed signal
- [x] 2.4 Implementasi change_state() function
- [x] 2.5 Implementasi score dan wave variables
- [x] 2.6 Buat file `scripts/autoload/events.gd`
- [x] 2.7 Definisikan signals: enemy_spawned, enemy_killed, player_damaged, player_died
- [x] 2.8 Definisikan signals: wave_started, wave_completed, score_changed
- [x] 2.9 Register Game.gd di Project Settings > Autoload
- [x] 2.10 Register Events.gd di Project Settings > Autoload

## 3. Input Map

- [x] 3.1 Buka Project Settings > Input Map
- [x] 3.2 Add action: `move_up` → bind to W
- [x] 3.3 Add action: `move_down` → bind to S
- [x] 3.4 Add action: `move_left` → bind to A
- [x] 3.5 Add action: `move_right` → bind to D
- [x] 3.6 Add action: `dash` → bind to Space
- [x] 3.7 Add action: `shoot` → bind to Mouse Left Button

## 4. Project Settings

- [x] 4.1 Set Rendering > Renderer > Rendering Method = "Forward+"
- [x] 4.2 Set Display > Window > Size = 1920x1080
- [x] 4.3 Set Display > Window > Stretch Mode = "canvas_items"
- [x] 4.4 Set Display > Window > Stretch Aspect = "keep"
- [x] 4.5 Set Physics > Common > Physics Ticks Per Second = 60

## 5. Verification

- [ ] 5.1 Run project - tidak ada error
- [ ] 5.2 Test autoload: `print(Game)` di ready() - tidak null
- [ ] 5.3 Test autoload: `print(Events)` di ready() - tidak null
- [ ] 5.4 Test input: `print(Input.get_vector("move_left", "move_right", "move_up", "move_down"))` - return value berubah saat tekan WASD
- [ ] 5.5 Commit dengan message: "feat: Add project foundation - structure, autoloads, input map"
