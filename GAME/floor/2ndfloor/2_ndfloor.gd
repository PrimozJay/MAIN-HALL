extends Node2D

@onready var player: CharacterBody2D = $Player/Player

func _ready():
	var spawn = get_node_or_null(TransitionManager.next_spawn_name)
	if spawn:
		player.global_position = spawn.global_position
