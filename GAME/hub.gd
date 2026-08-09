extends Control  # attach this to the "Hub" node

@onready var slots: Array[TextureRect] = [$Slot0, $Slot1, $Slot2]
var items: Array = [null, null, null]

func add_item(item_name: String, icon: Texture2D) -> bool:
	for i in range(3):
		if items[i] == null:
			items[i] = {"name": item_name}
			slots[i].texture = icon
			return true
	print("Inventory full!")
	return false
