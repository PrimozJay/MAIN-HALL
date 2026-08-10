extends Node

var collected: Array[String] = []

func mark_collected(id: String) -> void:
	if not collected.has(id):
		collected.append(id)

func is_collected(id: String) -> bool:
	return collected.has(id)
