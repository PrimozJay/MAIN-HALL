extends CharacterBody2D

@export var speed: float = 80.0
@export var detection_range: float = 400.0
@export var cone_half_angle_deg: float = 20.0
@export var attack_range: float = 30.0
@export var attack_damage: float = 10.0
@export var attack_cooldown: float = 1.0

var player: CharacterBody2D
var flashlight: PointLight2D
var can_attack: bool = true

@onready var sprite = $AnimatedSprite2D
@onready var nav_agent = $NavigationAgent2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	flashlight = player.get_node("Flashlight")
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0

func _physics_process(_delta):
	if player == null:
		return

	var dir = Vector2.ZERO
	var distance_to_player = global_position.distance_to(player.global_position)

	if is_lit_by_flashlight():
		velocity = Vector2.ZERO
		sprite.stop()
	elif distance_to_player <= attack_range:
		velocity = Vector2.ZERO
		_try_attack()
	else:
		nav_agent.target_position = player.global_position
		var next_path_pos = nav_agent.get_next_path_position()
		dir = (next_path_pos - global_position).normalized()
		velocity = dir * speed

	move_and_slide()
	_update_animation(dir)

func _try_attack():
	if not can_attack:
		return
	can_attack = false

	if player.has_method("take_damage"):
		player.take_damage(attack_damage)

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

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

	return true
