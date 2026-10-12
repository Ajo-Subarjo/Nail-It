extends Node2D


@export var scene_path : String = "res://scene/level_1.tscn"



func _on_button_pressed() -> void:
	GameManager.level = 1
	GameManager.change_level()


func _on_button_3_pressed() -> void:
	get_tree().quit()
	
func on_load_complete(loader: AsyncScene):
	loader.change_scene()


func _on_button_2_pressed() -> void:
	$Camera.shake(15)
