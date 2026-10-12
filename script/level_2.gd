extends Node2D

@export var time := 240
@export var scene_path : String = "res://scene/level_.tscn"
@onready var main_menu := "res://scene/main_screen.tscn"
var finish = false


func _ready() -> void:
	Audiomanager.setup_audio()
	await get_tree().create_timer(1).timeout
	GameManager.paused = false
	#$tutorial.show()


func _process(delta: float) -> void:
	if $painter.get_coverage() * 100 >= 95:
		if !finish:
			finish = true
			on_finish()


func _on_refill_body_entered(body: Node2D) -> void:
	if body.name == "painter":
		body.paint_amount = 1000

func back_main_menu():
	var loader: AsyncScene = AsyncScene.new(main_menu,AsyncScene.LoadingOperation.Replace, self)
	loader.with_transition(AsyncScene.TransitionType.WipeLeft, 1.2, Color.from_hsv(0.589963, 0.614607, 0.474517, 1.0))
	loader.OnComplete.connect(on_load_complete)
	loader.start()

func on_finish():
	GameManager.paused = true
	GameManager.level = 3
	GameManager.update_time()
	GameManager.change_level()

func on_load_complete(loader: AsyncScene):
	loader.change_scene()


func _on_button_pressed() -> void:
	$tutorial.hide()
	

func _on_debug_pressed() -> void:
	GameManager.level = 3
	GameManager.change_level()
