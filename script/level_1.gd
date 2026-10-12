extends  Node2D


@onready var nail_group = $"nail group"
@onready var main_menu := "res://scene/main_screen.tscn"
@export var scene_path := "res://scene/level_2.tscn"

var nail_count = 0



func _ready() -> void:
	#$tutorial.show()
	await get_tree().create_timer(1).timeout
	GameManager.start_timer()
	GameManager.paused = false

	$Camera.shake(1)
	Audiomanager.setup_audio()
	for child in nail_group.get_children():
		child.nail_finish.connect(_on_nail_finish)


func _on_nail_finish():
	nail_count += 1
	if nail_count >= 4:
		print("Done")
		on_finish()


func on_finish():
	GameManager.paused = true
	GameManager.level = 2
	GameManager.update_time()
	GameManager.change_level()

func on_load_complete(loader: AsyncScene):
	loader.change_scene()


func back_main_menu():
	var loader: AsyncScene = AsyncScene.new(main_menu,AsyncScene.LoadingOperation.Replace, self)
	loader.with_transition(AsyncScene.TransitionType.WipeLeft, 1.2, Color.from_hsv(0.589963, 0.614607, 0.474517, 1.0))
	loader.OnComplete.connect(on_load_complete)
	loader.start()



func _on_start() -> void:
	$tutorial.hide()


func _on_debug_pressed() -> void:
	GameManager.level = 2
	GameManager.change_level()
