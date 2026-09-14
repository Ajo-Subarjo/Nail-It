extends Node2D

@export var time := 25
@export var scene_path : String = "res://scene/level_.tscn"
@onready var main_menu := "res://scene/main_screen.tscn"
var finish = false


func _ready() -> void:
	$tutorial.show()


func _process(delta: float) -> void:
	if $painter.get_coverage() * 100 >= 93:
		if !finish:
			finish = true
			$scene/Timer.paused = true
			#$scene/conditional_screen/AnimationPlayer.play("WIN")
			on_finish()
		#$scene/Timer.start(5)


func _on_refill_body_entered(body: Node2D) -> void:
	#print(body)
	if body.name == "painter":
		#print(body.paint_amount)
		body.paint_amount = 1000

func back_main_menu():
	var loader: AsyncScene = AsyncScene.new(main_menu,AsyncScene.LoadingOperation.Replace, self)
	loader.with_transition(AsyncScene.TransitionType.WipeLeft, 1.2, Color.from_hsv(0.589963, 0.614607, 0.474517, 1.0))
	loader.OnComplete.connect(on_load_complete)
	loader.start()


func change_scene():
	var loader: AsyncScene = AsyncScene.new(scene_path,AsyncScene.LoadingOperation.Replace, self)
	loader.with_transition(AsyncScene.TransitionType.WipeLeft, 1.2, Color.from_hsv(0.589963, 0.614607, 0.474517, 1.0))
	loader.OnComplete.connect(on_load_complete)
	loader.start()

func on_load_complete(loader: AsyncScene):
	loader.change_scene()


func _on_button_pressed() -> void:
	$tutorial.hide()
	$scene/Timer.start(time)

func on_finish():
	$scene/conditional_screen/Hammer.hide()
	$scene/conditional_screen/Hammer2.hide()
	$scene/conditional_screen/Hammer3.hide()
	$scene/conditional_screen/AnimationPlayer.play("Complete")
