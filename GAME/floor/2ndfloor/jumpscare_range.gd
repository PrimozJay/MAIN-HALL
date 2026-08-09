extends CharacterBody2D
## Attach this to the Monster's root node (CharacterBody2D).
## Child structure expected:
##   Monster (CharacterBody2D)
##     └─ AnimatedSprite2D  (walk_left / walk_right animations from your 4-frame sheet)
##     └─ JumpscareRange (Area2D + CollisionShape2D)

@export var player_path: NodePath          # drag your Player node here in the inspector
@export var walk_speed: float = 60.0
@export var follow_distance: float = 180.0  # how far behind the player it lurks
@export var jumpscare_distance: float = 28.0
@export var catch_up_speed: float = 220.0   # burst speed once it decides to strike

var player: Node2D
var triggered := false
var active := false   # starts dormant until activate() is called

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	player = get_node(player_path)
	sprite.play("walk")
	visible = false          # hidden until activated
	set_physics_process(false)

## Call this from MonsterTrigger.gd (or anywhere) to wake the monster up.
func activate() -> void:
	if active:
		return
	active = true
	visible = true
	# spawn it behind the player, out of view, at follow_distance away
	global_position = player.global_position - (player.global_position.direction_to(global_position) if global_position != player.global_position else Vector2.LEFT) * follow_distance
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not active or triggered or player == null:
		return

	# Position target: directly behind the player, relative to their facing/movement
	var to_player := player.global_position - global_position
	var distance := to_player.length()

	# Decide movement: lurk at follow_distance behind, but start closing in over time
	var desired_distance := follow_distance
	if distance > desired_distance:
		velocity = to_player.normalized() * walk_speed
	elif distance <= jumpscare_distance:
		_trigger_jumpscare()
		return
	else:
		# Slowly creep closer than "safe" distance to build dread
		velocity = to_player.normalized() * (walk_speed * 0.5)

	move_and_slide()

	# Flip sprite to face the direction it's walking
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0

func _trigger_jumpscare() -> void:
	triggered = true
	velocity = Vector2.ZERO
	Jumpscare.trigger()  # calls the autoload singleton below
