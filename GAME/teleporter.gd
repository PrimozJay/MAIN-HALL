extends Area2D

@export var target_scene: String = "res://GAME/floor/2ndfloor/2ndfloor.tscn"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		TransitionManager.go_to_floor(target_scene)
