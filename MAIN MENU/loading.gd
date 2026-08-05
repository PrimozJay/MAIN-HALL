extends Control
@onready var progress_bar: ProgressBar = $ProgressBar
var loaded_scene: PackedScene = null
var start_time: int
var finished := false
var display_value: float = 0.0   # what's actually shown, eased toward target
const MIN_LOAD_TIME_MS := 1000
const EASE_SPEED := 1.0          # lower = slower catch-up, higher = snappier

func _ready():
	progress_bar.min_value = 0
	progress_bar.max_value = 100
	progress_bar.value = 0
	start_time = Time.get_ticks_msec()
	var err = ResourceLoader.load_threaded_request(Global.next_scene)
	print("load_threaded_request returned: ", err)

func _process(delta):
	if finished:
		return

	var progress = []
	var status = ResourceLoader.load_threaded_get_status(Global.next_scene, progress)
	var target: float = 0.0

	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		target = (progress[0] if progress.size() > 0 else 0) * 100
		display_value = lerp(display_value, target, min(EASE_SPEED * delta, 1.0))
		progress_bar.value = display_value

	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		finished = true
		set_process(false)
		loaded_scene = ResourceLoader.load_threaded_get(Global.next_scene)

		# smoothly finish the bar to 100 before switching
		var tween = create_tween()
		tween.tween_property(progress_bar, "value", 100, 0.1)
		await tween.finished

		var elapsed = Time.get_ticks_msec() - start_time
		if elapsed < MIN_LOAD_TIME_MS:
			await get_tree().create_timer((MIN_LOAD_TIME_MS - elapsed) / 100.0).timeout

		_go_to_scene()

	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		print("LOAD FAILED for: ", Global.next_scene)
		finished = true
		set_process(false)

	elif status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		print("INVALID RESOURCE: ", Global.next_scene)
		finished = true
		set_process(false)

func _go_to_scene():
	print("Switching scene now...")
	get_tree().change_scene_to_packed(loaded_scene)
