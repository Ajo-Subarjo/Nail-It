extends  Node2D


@export var time := 25
@onready var nail_group = $"nail group"
@onready var main_menu := "res://scene/main_screen.tscn"
@export var scene_path := "res://scene/level_2.tscn"

var nail_count = 0



func _ready() -> void:
	$tutorial.show()
	for child in nail_group.get_children():
		child.nail_finish.connect(_on_nail_finish)


func _on_nail_finish():
	nail_count += 1
	if nail_count >= 4:
		print("Done")
		on_finish()
		$scene/conditional_screen/AnimationPlayer.play("WIN")
		$scene/Timer.start(5)

func on_finish():
	var loader: AsyncScene = AsyncScene.new(scene_path,AsyncScene.LoadingOperation.Replace, self)
	loader.with_transition(AsyncScene.TransitionType.Iris, 1.2, Color.from_hsv(0.589963, 0.614607, 0.474517, 1.0))
	loader.OnComplete.connect(on_load_complete)
	loader.start()

func on_load_complete(loader: AsyncScene):
	loader.change_scene()


func back_main_menu():
	var loader: AsyncScene = AsyncScene.new(main_menu,AsyncScene.LoadingOperation.Replace, self)
	loader.with_transition(AsyncScene.TransitionType.WipeLeft, 1.2, Color.from_hsv(0.589963, 0.614607, 0.474517, 1.0))
	loader.OnComplete.connect(on_load_complete)
	loader.start()



func _on_start() -> void:
	$tutorial.hide()
	$scene/Timer.start(time)
