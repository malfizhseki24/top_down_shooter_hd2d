extends Node

## Global Event Bus
## Decoupled event system for inter-system communication.

# Enemy events
signal enemy_spawned(enemy: Node)
signal enemy_killed(enemy: Node, position: Vector3)

# Player events
signal player_damaged(amount: int)
signal player_died()
signal player_shot()
signal player_dashed()

# Game events
signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal score_changed(new_score: int)
