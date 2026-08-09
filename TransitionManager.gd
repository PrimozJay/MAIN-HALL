extends Node

var next_spawn_name: String = "SpawnPoint"

func go_to_floor(scene_path: String, spawn_name: String = "SpawnPoint") -> void:
	next_spawn_name = spawn_name
	call_deferred("_do_scene_change", scene_path)

func _do_scene_change(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
