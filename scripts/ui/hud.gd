## HUD.gd
## Heads-Up Display controller for the game.
## Manages crosshair, health bar, dash cooldown, damage vignette, and death screen.

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

var _player_health: HealthComponent
var _player: PlayerController


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	_restart_button.pressed.connect(_on_restart_pressed)

	Events.player_damaged.connect(_on_player_damaged)
	Events.player_died.connect(_on_player_died)

	_find_player.call_deferred()


func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


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


## DAMAGE VIGNETTE

func _on_player_damaged(_amount: int) -> void:
	_vignette.color = Color(0.8, 0, 0, 0.3)
	var tween := create_tween()
	tween.tween_property(_vignette, "color", Color(0.8, 0, 0, 0), vignette_flash_duration)


## DEATH SCREEN

func _on_player_died() -> void:
	_death_screen.visible = true
	_death_screen.mouse_filter = Control.MOUSE_FILTER_STOP
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var tween := create_tween()
	tween.tween_property(_death_screen, "color", Color(0, 0, 0, 0.7), 0.5)


func _on_restart_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().reload_current_scene()
