extends CharacterBody2D
## Attach this to the Monster's root node (CharacterBody2D).
## Child structure expected:
##   Monster (CharacterBody2D)
##     └─ AnimatedSprite2D  (walk_left / walk_right animations from your 4-frame sheet)
##     └─ JumpscareRange (Area2D + CollisionShape2D)

@export var player_path: NodePath          # optional: leave empty to auto-find via "player" group
@export var walk_speed: float = 60.0
@export var follow_distance: float = 180.0  # how far behind the player it lurks
@export var jumpscare_distance: float = 28.0
@export var catch_up_speed: float = 220.0   # burst speed once it decides to strike (currently unused, reserved for later)

var player: Node2D
var triggered := false
var active := false   # starts dormant until activate() is called

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	player = get_node_or_null(player_path) if not player_path.is_empty() else get_tree().get_first_node_in_group("player")
	if player == null:
		push_error("JumpscareRange '%s' could not find a player" % name)
		set_physics_process(false)
		return
	sprite.play("walk")
	visible = false
	set_physics_process(false)

## Call this from MonsterTrigger.gd (or anywhere) to wake the monster up.
func activate() -> void:
	if active or player == null:
		return
	active = true
	visible = true
	var direction := player.global_position.direction_to(global_position) if global_position != player.global_position else Vector2.LEFT
	global_position = player.global_position - direction * follow_distance
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	if not active or triggered or player == null:
		return

	var to_player := player.global_position - global_position
	var distance := to_player.length()

	if distance > follow_distance:
		velocity = to_player.normalized() * walk_speed
	elif distance <= jumpscare_distance:
		_trigger_jumpscare()
		return
	else:
		velocity = to_player.normalized() * (walk_speed * 0.5)

	move_and_slide()

	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0

func _trigger_jumpscare() -> void:
	triggered = true
	velocity = Vector2.ZERO
	Jumpscare.trigger()
