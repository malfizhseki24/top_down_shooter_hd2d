## HUD.gd
## Heads-Up Display controller for the game.
## Manages crosshair, health bar, dash cooldown, damage vignette, score, pause menu, and death screen.

extends CanvasLayer
class_name HUD

## Duration of damage vignette flash.
@export var vignette_flash_duration: float = 0.3

@onready var crosshair: TextureRect = $Crosshair
@onready var _health_bar: ProgressBar = $HealthBar
@onready var _dash_bar: ProgressBar = $DashBar
@onready var _vignette: ColorRect = $Vignette
@onready var _death_screen: ColorRect = $DeathScreen
@onready var _restart_button: Button = $DeathScreen/VBoxContainer/RestartButton
@onready var _death_score_label: Label = $DeathScreen/VBoxContainer/ScoreLabel
@onready var _score_label: Label = $ScoreLabel
@onready var _pause_menu: ColorRect = $PauseMenu
@onready var _resume_button: Button = $PauseMenu/VBoxContainer/ResumeButton
@onready var _pause_restart_button: Button = $PauseMenu/VBoxContainer/RestartButton
@onready var _quit_button: Button = $PauseMenu/VBoxContainer/QuitButton

var _player_health: HealthComponent
var _player: PlayerController
var _is_dead: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	_restart_button.pressed.connect(_on_restart_pressed)
	_resume_button.pressed.connect(_on_resume_pressed)
	_pause_restart_button.pressed.connect(_on_restart_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)

	Events.player_damaged.connect(_on_player_damaged)
	Events.player_died.connect(_on_player_died)
	Events.enemy_killed.connect(_on_enemy_killed)

	_score_label.text = "Score: 0"

	_find_player.call_deferred()


func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not _is_dead:
		_toggle_pause()


func _process(_delta: float) -> void:
	# Update crosshair position to follow mouse
	var mouse_pos := get_viewport().get_mouse_position()
	crosshair.global_position = mouse_pos - crosshair.size / 2

	# Update dash cooldown bar
	if _player:
		var cd_ratio := _player._dash_cooldown_timer / _player.dash_cooldown if _player.dash_cooldown > 0 else 0.0
		_dash_bar.value = (1.0 - cd_ratio) * 100


func _find_player() -> void:
	var player := get_tree().get_first_node_in_group("players")
	if player:
		_player = player as PlayerController
		if player.has_node("HealthComponent"):
			_player_health = player.get_node("HealthComponent")
			_player_health.health_changed.connect(_on_health_changed)
			_health_bar.value = _player_health.get_health_percent() * 100


## HEALTH BAR

func _on_health_changed(_new_health: int, _old_health: int) -> void:
	if _player_health:
		var target_percent := _player_health.get_health_percent() * 100
		var tween := create_tween()
		tween.tween_property(_health_bar, "value", target_percent, 0.2)


## SCORE

func _on_enemy_killed(_enemy: Node, _position: Vector3) -> void:
	Game.add_score(1)
	_score_label.text = "Score: %d" % Game.score


## DAMAGE VIGNETTE

func _on_player_damaged(_amount: int) -> void:
	_vignette.color = Color(0.8, 0, 0, 0.3)
	var tween := create_tween()
	tween.tween_property(_vignette, "color", Color(0.8, 0, 0, 0), vignette_flash_duration)


## DEATH SCREEN

func _on_player_died() -> void:
	_is_dead = true
	_death_screen.visible = true
	_death_screen.mouse_filter = Control.MOUSE_FILTER_STOP
	_death_score_label.text = "Score: %d" % Game.score
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var tween := create_tween()
	tween.tween_property(_death_screen, "color", Color(0, 0, 0, 0.7), 0.5)


func _on_restart_pressed() -> void:
	get_tree().paused = false
	Game.reset_game()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().reload_current_scene()


## PAUSE MENU

func _toggle_pause() -> void:
	var is_paused := not get_tree().paused
	get_tree().paused = is_paused
	_pause_menu.visible = is_paused
	if is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _on_resume_pressed() -> void:
	_toggle_pause()


func _on_quit_pressed() -> void:
	get_tree().quit()
