extends Node2D


@export var scene_path : String = "res://scene/level_1.tscn"

func _on_button_pressed() -> void:
	var loader: AsyncScene = AsyncScene.new(scene_path,AsyncScene.LoadingOperation.ReplaceImmediate, self)
	loader.with_transition(AsyncScene.TransitionType.WipeLeft, 1.2, Color.from_hsv(0.589963, 0.614607, 0.474517, 1.0))
	loader.OnComplete.connect(on_load_complete)
	loader.start()

 

func on_load_complete(loader: AsyncScene):
	loader.change_scene()


func _on_button_3_pressed() -> void:
	get_tree().quit()
