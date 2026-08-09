extends Control

@onready var slots_ui: Array[Sprite2D] = [$Slot1, $Slot2, $Slot3]

func _ready() -> void:
	Inventory.inventory_changed.connect(refresh)
	refresh()

func refresh() -> void:
	for i in slots_ui.size():
		var slot_ui = slots_ui[i]
		var slot_data = Inventory.slots[i]
		if slot_data.item:
			slot_ui.texture = slot_data.item.icon
			slot_ui.visible = true
		else:
			slot_ui.texture = null
			slot_ui.visible = false
