extends Node

## AudioManager - Singleton for SFX playback.
## Uses a pool of AudioStreamPlayer nodes for overlapping sounds.
## Connects to the Events bus for gameplay audio feedback.

const POOL_SIZE := 8
const PITCH_VARIATION := 0.1

var _sfx_library: Dictionary = {}
var _pool: Array[AudioStreamPlayer] = []
var _pool_index: int = 0


func _ready() -> void:
	_load_sfx()
	_create_pool()
	_connect_events()


func _load_sfx() -> void:
	var sfx_dir := "res://assets/audio/sfx/"
	var sfx_names := ["shoot", "hit", "dash", "enemy_death", "player_hurt", "player_death"]
	for sfx_name in sfx_names:
		var path: String = sfx_dir + sfx_name + ".ogg"
		var stream := load(path) as AudioStream
		if stream:
			_sfx_library[sfx_name] = stream
		else:
			push_warning("AudioManager: Could not load SFX '%s'" % path)


func _create_pool() -> void:
	for i in POOL_SIZE:
		var player := AudioStreamPlayer.new()
		player.bus = &"SFX"
		add_child(player)
		_pool.append(player)


func play_sfx(sfx_name: String, volume_db: float = 0.0) -> void:
	if not _sfx_library.has(sfx_name):
		push_warning("AudioManager: Unknown SFX '%s'" % sfx_name)
		return

	var player := _get_available_player()
	player.stream = _sfx_library[sfx_name]
	player.volume_db = volume_db
	player.pitch_scale = randf_range(1.0 - PITCH_VARIATION, 1.0 + PITCH_VARIATION)
	player.play()


func _get_available_player() -> AudioStreamPlayer:
	# Try to find a non-playing player first
	for i in POOL_SIZE:
		var idx := (_pool_index + i) % POOL_SIZE
		if not _pool[idx].playing:
			_pool_index = (idx + 1) % POOL_SIZE
			return _pool[idx]

	# All playing - steal the oldest
	var player := _pool[_pool_index]
	_pool_index = (_pool_index + 1) % POOL_SIZE
	return player


func _connect_events() -> void:
	Events.player_shot.connect(_on_player_shot)
	Events.player_dashed.connect(_on_player_dashed)
	Events.player_damaged.connect(_on_player_damaged)
	Events.player_died.connect(_on_player_died)
	Events.enemy_killed.connect(_on_enemy_killed)
	Events.arrow_hit.connect(_on_arrow_hit)


func _on_player_shot() -> void:
	play_sfx("shoot", -3.0)


func _on_player_dashed() -> void:
	play_sfx("dash", -5.0)


func _on_player_damaged(_amount: int) -> void:
	play_sfx("player_hurt", -2.0)


func _on_player_died() -> void:
	play_sfx("player_death", 0.0)


func _on_enemy_killed(_enemy: Node, _position: Vector3) -> void:
	play_sfx("enemy_death", -4.0)


func _on_arrow_hit() -> void:
	play_sfx("hit", -3.0)
