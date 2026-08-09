extends Node

var next_spawn_name: String = "SpawnPoint"

func go_to_floor(scene_path: String, spawn_name: String = "SpawnPoint"):
	next_spawn_name = spawn_name
	get_tree().change_scene_to_file(scene_path)
