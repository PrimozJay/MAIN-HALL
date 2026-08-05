extends CharacterBody2D

const SPEED = 100.0
const MOUSE_SENSITIVITY = 0.005  # lower = less sensitive, higher = more sensitive

@onready var flashlight = $Flashlight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var flashlight_on = true
var flashlight_angle = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # locks + hides cursor, enables relative motion

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * SPEED
	move_and_slide()

	flashlight.rotation = flashlight_angle

	_update_animation(input_dir)

func _update_animation(direction: Vector2) -> void:
	if direction.length() > 0:
		if abs(direction.x) > abs(direction.y):
			animated_sprite.play("walk_side")
			animated_sprite.flip_h = direction.x < 0
		elif direction.y < 0:
			animated_sprite.play("walk_up")
		else:
			animated_sprite.play("walk_down")
	else:
		animated_sprite.stop()

func _input(event):
	if event is InputEventMouseMotion:
		flashlight_angle += event.relative.x * MOUSE_SENSITIVITY

func _unhandled_input(event):
	if event.is_action_pressed("toggle_flashlight"):
		flashlight_on = !flashlight_on
		flashlight.visible = flashlight_on
