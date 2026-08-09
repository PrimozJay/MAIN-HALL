extends Area2D
class_name Item

@export var item_name: String = "Battery"
@export var icon: Texture2D

func interact():
	if Inventory.add_item(self):
		queue_free()  
