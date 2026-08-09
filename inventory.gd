extends Node

signal inventory_changed

class Slot:
	var item: ItemData
	var quantity: int = 0

var slots: Array[Slot] = []
const SLOT_COUNT := 20

func _ready() -> void:
	for i in SLOT_COUNT:
		slots.append(Slot.new())

func add_item(item: ItemData, amount: int = 1) -> bool:
	# try stacking onto existing slot first
	if item.stackable:
		for slot in slots:
			if slot.item == item and slot.quantity < item.max_stack:
				var space = item.max_stack - slot.quantity
				var to_add = min(space, amount)
				slot.quantity += to_add
				amount -= to_add
				if amount <= 0:
					inventory_changed.emit()
					return true
	# fall back to an empty slot
	for slot in slots:
		if slot.item == null:
			slot.item = item
			slot.quantity = amount
			inventory_changed.emit()
			return true
	return false # inventory full

func remove_item(item: ItemData, amount: int = 1) -> bool:
	for slot in slots:
		if slot.item == item:
			slot.quantity -= amount
			if slot.quantity <= 0:
				slot.item = null
				slot.quantity = 0
			inventory_changed.emit()
			return true
	return false
