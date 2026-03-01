## HUD.gd
## Heads-Up Display controller for the game.
## Manages crosshair positioning and mouse cursor visibility.

extends CanvasLayer
class_name HUD

## The crosshair texture rect that follows the mouse.
@onready var crosshair: TextureRect = $Crosshair


func _ready() -> void:
	# Hide the default OS mouse cursor
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _exit_tree() -> void:
	# Restore the mouse cursor when HUD is removed
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _process(_delta: float) -> void:
	# Update crosshair position to follow mouse
	# Center the crosshair on the mouse position
	var mouse_pos := get_viewport().get_mouse_position()
	crosshair.global_position = mouse_pos - crosshair.size / 2
