extends Area2D

@export var item_name: String = "Battery"
@export var icon: Texture2D

func interact():
	if Hub.add_item(item_name, icon):
		queue_free()
