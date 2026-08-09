extends Node

var interact_prompt: Label

func register_prompt(label: Label) -> void:
	interact_prompt = label
	interact_prompt.visible = false

func show_prompt() -> void:
	if interact_prompt:
		interact_prompt.visible = true

func hide_prompt() -> void:
	if interact_prompt:
		interact_prompt.visible = false
