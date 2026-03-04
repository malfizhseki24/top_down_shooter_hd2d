# Tasks

- [x] **T1: Add Score Counter to HUD**
  - Add a Label node to hud.tscn anchored top-right for score display
  - Connect to `Events.enemy_killed` to increment score via `Game.add_score()`
  - Display score as "Score: X" text
  - Validate: score increments visibly when killing enemies

- [x] **T2: Show Score on Death Screen**
  - Add a score Label to the DeathScreen VBoxContainer
  - Display final score when player dies
  - Validate: death screen shows "Score: X" alongside "YOU DIED"

- [x] **T3: Add Pause Menu**
  - Add PauseMenu (ColorRect overlay) with VBoxContainer to hud.tscn
  - Include "PAUSED" label, Resume button, Restart button, Quit button
  - Toggle on Escape key press
  - Set `get_tree().paused = true/false` on toggle
  - Set HUD `process_mode = PROCESS_MODE_ALWAYS` so it works while paused
  - Resume: unpause and hide menu
  - Restart: unpause and reload scene
  - Quit: quit application
  - Validate: Escape pauses/unpauses, all buttons work
