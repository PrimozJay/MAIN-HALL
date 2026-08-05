extends CanvasLayer

@onready var health_display: TextureRect = $HealthBar

var full = preload("res://sprites/ui/health_3of3.png")
var two_thirds = preload("res://sprites/ui/health_2of3.png")
var one_third = preload("res://sprites/ui/health_1of3.png")
var empty = preload("res://sprites/ui/health_0of3.png")

func update_health_display(current_health: int):
	match current_health:
		3: health_display.texture = full
		2: health_display.texture = two_thirds
		1: health_display.texture = one_third
		0: health_display.texture = empty
