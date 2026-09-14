extends Control


var is_finish := false
var failed := false



func _process(delta: float) -> void:
	$Label.text = str(int($Timer.time_left))


func _on_timer_timeout() -> void:
	if GlobalState.health <=0:
		print("failed")
		$Timer.paused = true
		$conditional_screen/AnimationPlayer.play("TOTAL_LOSE")

	if GlobalState.health >= 1:
		$conditional_screen/AnimationPlayer.play("LOSE")
		await  $conditional_screen/AnimationPlayer.animation_finished
		$conditional_screen/AnimationPlayer.play("lose "+str(GlobalState.health))
		GlobalState.health -= 1
		await  $conditional_screen/AnimationPlayer.animation_finished
		get_tree().reload_current_scene()
		return




func _on_main_menu_pressed() -> void:
	GlobalState.health = 3
	$"..".back_main_menu()



func _on_play_again_pressed() -> void:
	GlobalState.health = 3
	var loader: AsyncScene = AsyncScene.new("res://scene/level_1.tscn",AsyncScene.LoadingOperation.Replace, self)
	loader.with_transition(AsyncScene.TransitionType.Iris, 1.2, Color.from_hsv(0.589963, 0.614607, 0.474517, 1.0))
	loader.OnComplete.connect(on_load_complete)
	loader.start()

func on_load_complete(loader: AsyncScene):
	loader.change_scene()
