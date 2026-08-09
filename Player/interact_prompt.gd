extends Label

func _ready() -> void:
	InteractPrompt.register_prompt(self)
