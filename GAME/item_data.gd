extends Resource
class_name ItemData

@export var id: String
@export var item_name: String
@export var icon: Texture2D
@export var stackable: bool = true
@export var max_stack: int = 99
@export_multiline var description: String
