extends Area2D

@export var next_scene_path: String = "res://Escaped.tscn"

@onready var prompt_label: Label = $PromptLabel

var player_in_range: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	KeyManager.keys_updated.connect(_on_keys_updated)
	_update_label(KeyManager.deposited_keys, KeyManager.KEYS_NEEDED)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = true
		InteractPrompt.show_prompt()

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		InteractPrompt.hide_prompt()

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("Interact"):
		_handle_interact()

func _handle_interact() -> void:
	var held_keys := _count_held_keys()

	if KeyManager.is_escape_ready():
		get_tree().change_scene_to_file(next_scene_path)
		return

	if held_keys > 0:
		for slot in Inventory.slots:
			if slot.item != null and _is_key_item(slot.item):
				var qty = slot.quantity
				for i in qty:
					Inventory.remove_item(slot.item, 1)
		KeyManager.deposit_keys(held_keys)
		if prompt_label:
			prompt_label.visible = true
	else:
		print("No keys to deposit. Need %d/%d total." % [KeyManager.deposited_keys, KeyManager.KEYS_NEEDED])

func _count_held_keys() -> int:
	var total := 0
	for slot in Inventory.slots:
		if slot.item != null and _is_key_item(slot.item):
			total += slot.quantity
	return total

func _is_key_item(item: Resource) -> bool:
	var path := item.resource_path.get_file().to_lower()
	return path.begins_with("key")

func _on_keys_updated(current: int, needed: int) -> void:
	_update_label(current, needed)

func _update_label(current: int, needed: int) -> void:
	if prompt_label:
		prompt_label.text = "%d/%d" % [current, needed]
