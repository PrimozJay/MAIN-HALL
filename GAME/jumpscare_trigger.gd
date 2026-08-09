extends Area2D

@onready var jumpscare_rect: TextureRect = $CanvasLayer/TextureRect
@onready var jumpscare_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hide_timer: Timer = $Timer

var triggered: bool = false

func _ready() -> void:
	jumpscare_rect.visible = false
	body_entered.connect(_on_body_entered)
	hide_timer.timeout.connect(_on_timer_timeout)

func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
	if body.is_in_group("player"):
		triggered = true
		jumpscare_rect.visible = true
		jumpscare_sound.play()
		hide_timer.start()

func _on_timer_timeout() -> void:
	jumpscare_rect.visible = false
