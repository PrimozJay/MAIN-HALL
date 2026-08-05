extends PointLight2D

func _ready():
	randomize()
	flicker()

func flicker():
	while true:
		energy = randf_range(0.9, 1.4)
		await get_tree().create_timer(randf_range(0.05, 0.2)).timeout
