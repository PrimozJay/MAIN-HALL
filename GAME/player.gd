extends CharacterBody2D

const SPEED = 100.0
const MOUSE_SENSITIVITY = 0.005

@onready var flashlight: PointLight2D = $Flashlight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var flashlight_on = true
var flashlight_angle: float = 0.0
var virtual_mouse_offset: Vector2 = Vector2.RIGHT  # arbitrary starting direction

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * SPEED
	move_and_slide()
	_update_animation(input_dir)
	flashlight.rotation = flashlight_angle

func _update_animation(direction: Vector2) -> void:
	if direction.length() > 0:
		if abs(direction.x) > abs(direction.y):
			animated_sprite.play("side")
			animated_sprite.flip_h = direction.x < 0
		elif direction.y < 0:
			animated_sprite.play("up")
		else:
			animated_sprite.play("down")
	else:
		animated_sprite.stop()

func _input(event):
	if event is InputEventMouseMotion:
		virtual_mouse_offset += event.relative * MOUSE_SENSITIVITY
		flashlight_angle = virtual_mouse_offset.angle()

func _unhandled_input(event):
	if event.is_action_pressed("toggle_flashlight"):
		flashlight_on = !flashlight_on
		flashlight.visible = flashlight_on
	if event is InputEventMouseButton and event.pressed and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
