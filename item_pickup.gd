extends Area2D
class_name ItemPickup

@export var item_data: ItemData
@export var quantity: int = 1

@onready var sprite: Sprite2D = get_parent()

var player_in_range: bool = false
var prompt_label: Label

func _ready() -> void:
	if item_data == null:
		push_error("ItemPickup '%s' has no item_data assigned!" % get_parent().name)
		return
	if sprite == null or not (sprite is Sprite2D):
		push_error("ItemPickup '%s' parent is not a Sprite2D" % get_parent().name)
		return

	# If this item's ID was already collected, remove immediately
	if item_data.id != "" and CollectedItems.is_collected(item_data.id):
		get_parent().queue_free()
		return

	sprite.texture = item_data.icon
	prompt_label = get_tree().get_first_node_in_group("interact_prompt")
	if prompt_label:
		prompt_label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

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
		_pick_up()

func _pick_up() -> void:
	if Inventory.add_item(item_data, quantity):
		if item_data.id != "":
			CollectedItems.mark_collected(item_data.id)
		if prompt_label:
			prompt_label.visible = false
		get_parent().queue_free()
