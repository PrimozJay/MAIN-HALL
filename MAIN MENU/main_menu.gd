extends Control

func _ready():
	$StartButton.pressed.connect(_on_start_button_pressed)
	$SettingsButton.pressed.connect(_on_settings_button_pressed)

func _on_start_button_pressed():
	Global.next_scene = "res://GAME/GAME.tscn"
	get_tree().change_scene_to_file("res://MAIN MENU/Loading.tscn")

func _on_settings_button_pressed():
	Global.next_scene = "res://MAIN MENU/settings.tscn"
	get_tree().change_scene_to_file("res://MAIN MENU/Loading.tscn")
