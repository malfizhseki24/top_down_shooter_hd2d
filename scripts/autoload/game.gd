extends Node

## Game State Manager
## Manages global game state, score, and wave progression.

enum State { MENU, PLAYING, PAUSED, GAME_OVER }

var current_state: State = State.MENU
var score: int = 0
var wave: int = 1

signal state_changed(new_state: State)
signal score_changed(new_score: int)


func change_state(new_state: State) -> void:
	if current_state == new_state:
		return
	current_state = new_state
	state_changed.emit(new_state)


func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)


func reset_game() -> void:
	score = 0
	wave = 1
	current_state = State.MENU
