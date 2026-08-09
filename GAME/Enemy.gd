extends CharacterBody2D
class_name Enemy

## Enemy (top-down 2D) that slows down while inside the player's flashlight cone.
## Attach this to a CharacterBody2D. Requires a "player" group node (chase target)
## and a "flashlight" group node (see Flashlight.gd).

@export var normal_speed: float = 120.0
@export var slowed_speed: float = 30.0

@export_group("Flashlight Detection")
@export var flashlight_group: String = "flashlight"     # group name of the flashlight node
@export var detection_range: float = 400.0              # how far the beam reaches
@export var cone_half_angle_degrees: float = 35.0        # half-angle of the flashlight cone
@export var require_line_of_sight: bool = true           # raycast check (walls block the beam)
@export var los_collision_mask: int = 1                  # physics layer(s) that block light

@export_group("Chase")
@export var chase_target_group: String = "player"

var _flashlight: Node2D = null
var _target: Node2D = null
var is_illuminated: bool = false
var move_speed: float = normal_speed

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("enemy")
	# defer so other nodes in the scene have finished _ready() and joined their groups
	call_deferred("_find_references")

func _find_references() -> void:
	var lights := get_tree().get_nodes_in_group(flashlight_group)
	if lights.size() > 0:
		_flashlight = lights[0]

	var targets := get_tree().get_nodes_in_group(chase_target_group)
	if targets.size() > 0:
		_target = targets[0]

func _physics_process(_delta: float) -> void:
	is_illuminated = _check_flashlight()
	move_speed = slowed_speed if is_illuminated else normal_speed

	if _target:
		var direction: Vector2 = (_target.global_position - global_position).normalized()
		velocity = direction * move_speed
		move_and_slide()
		_update_animation(direction)

## Plays the matching directional animation, same pattern as the player script.
func _update_animation(direction: Vector2) -> void:
	if animated_sprite == null:
		return

	if direction.length() > 0:
		if abs(direction.x) > abs(direction.y):
			animated_sprite.play("enemy_side")
			animated_sprite.flip_h = direction.x < 0
		elif direction.y < 0:
			animated_sprite.play("enemy_up")
		else:
			animated_sprite.play("enemy_down")
	else:
		animated_sprite.stop()

## Returns true if this enemy is currently lit by the flashlight.
func _check_flashlight() -> bool:
	if _flashlight == null:
		return false

	if not _flashlight.visible:
		return false

	var to_enemy: Vector2 = global_position - _flashlight.global_position
	var distance: float = to_enemy.length()
	if distance > detection_range:
		return false

	# Assumes the flashlight node's rotation points its beam along +X (local right).
	var flashlight_dir: Vector2 = Vector2.RIGHT.rotated(_flashlight.global_rotation)
	var angle_to_enemy: float = rad_to_deg(abs(flashlight_dir.angle_to(to_enemy.normalized())))

	if angle_to_enemy > cone_half_angle_degrees:
		return false

	if require_line_of_sight:
		var space_state := get_world_2d().direct_space_state
		var query := PhysicsRayQueryParameters2D.create(_flashlight.global_position, global_position)
		query.collision_mask = los_collision_mask
		query.exclude = [self]
		var result := space_state.intersect_ray(query)
		# if the ray hits something before reaching the enemy, the beam is blocked
		if result and result.collider != self:
			return false

	return true
