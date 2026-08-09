pextends CharacterBody2D

@export var speed: float = 80.0
@export var detection_range: float = 400.0
@export var cone_half_angle_deg: float = 20.0

var player: CharacterBody2D
var flashlight: PointLight2D

@onready var sprite = $AnimatedSprite2D
@onready var ray = $RayCast2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	flashlight = player.get_node("Flashlight")

func _physics_process(_delta):
	if player == null:
		return

	var dir = Vector2.ZERO

	if is_lit_by_flashlight():
		velocity = Vector2.ZERO
		sprite.stop()
	else:
		dir = (player.global_position - global_position).normalized()
		velocity = dir * speed

	move_and_slide()
	_update_animation(dir)

func _update_animation(direction: Vector2) -> void:
	if direction.length() > 0:
		if abs(direction.x) > abs(direction.y):
			sprite.play("side")
			sprite.flip_h = direction.x < 0
		elif direction.y < 0:
			sprite.play("up")
		else:
			sprite.play("down")
	else:
		sprite.stop()

func is_lit_by_flashlight() -> bool:
	if not player.flashlight_on:
		return false

	var to_enemy = global_position - flashlight.global_position
	var distance = to_enemy.length()
	if distance > detection_range:
		return false

	var flashlight_dir = Vector2.RIGHT.rotated(flashlight.global_rotation)
	var angle = abs(flashlight_dir.angle_to(to_enemy.normalized()))
	if angle > deg_to_rad(cone_half_angle_deg):
		return false

	ray.global_position = flashlight.global_position
	ray.target_position = ray.to_local(global_position)
	ray.force_raycast_update()
	if ray.is_colliding() and ray.get_collider() != self:
		return false

	return true
