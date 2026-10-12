extends Node2D

var duration := 90
@export var grad : Gradient

@onready var level_transition := $CanvasLayer/level_transition
@onready var timer_label := $Control/Label
@onready var timer := $Timer

@onready var l1p = $CanvasLayer/win/info/progress/l1
@onready var prog = $CanvasLayer/win/info/progress
@onready var timebar = $Control/timeprog



var paused := true
var ratio 
var rgrad
var fill : StyleBoxFlat
var level := 1




var level_times = [
	{"time": 25.0, "time_left": 25.0},
	{"time": 10.0, "time_left": 15.0},
	{"time": 24.0, "time_left": 215.0},
	{"time": 27.0, "time_left": 3.0}
]
const level_path = [
	"res://scene/level_1.tscn",
	"res://scene/level_2.tscn",
	"res://scene/level_3.tscn",
	"res://scene/level_4.tscn"
]
const main_menu = "res://scene/main_screen.tscn"

var past_val := 0.0


func _process(delta: float) -> void:
	timer_label.text = str(int(timer.time_left))
	
	if !paused:
		timebar.show()
		timebar.value = timer.time_left
		rgrad = timer.time_left / timer.wait_time
		timebar.get_theme_stylebox("fill").bg_color = grad.sample(rgrad)
		timebar.get_theme_stylebox("fill").shadow_color = grad.sample(rgrad).darkened(0.1)
	else:
		timebar.hide()

	timer.paused = paused


func start_timer():
	timebar.max_value = duration
	timer.wait_time = duration
	timer.start()


func _on_button_pressed() -> void:
	#change_level()
	#completed()
	$AnimationPlayer.play("game_over")
	#time_prog()
	#start_timer()


func _on_timer_timeout() -> void:
	$AnimationPlayer.play("game_over")
	print("done finish")

func completed():
	paused = true
	$AnimationPlayer.play("complete")
	await $AnimationPlayer.animation_finished
	var tw =create_tween()
	tw.set_trans(Tween.TRANS_ELASTIC)
	tw.tween_property($CanvasLayer/win/Label, "scale", Vector2(1.0, 1.0), 1)
	await tw.finished
	time_prog()




func time_prog():
	for i in range(level_times.size()):
		var lprog = prog.get_child(i)
		lprog.max_value = duration
		var label = lprog.get_child(0)
		label.text = "---------<"+str(int(level_times[i].time))+"s   level "+str(i+1)
		var value = past_val + level_times[i]["time"]
		
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(lprog,"value", value, 2.0)
		tween.parallel().tween_method(
			func(v):
				var ratio = v / lprog.max_value
				label.position.y = (lprog.size.y * (1.0-ratio)) - 10.0,
			lprog.value,
			value,
			2.0,
		)
		await tween.finished
		past_val = value

func update_time():
	level_times[level-2].time = duration - timer.time_left
	level_times[level-2].time_left = timer.time_left
	print(level_times[level-2])


func change_level():
	await  get_tree().create_timer(1).timeout
	level_transition.show()
	$AnimationPlayer.play("change_scene")

	var loader: AsyncScene = AsyncScene.new(level_path[level-1],AsyncScene.LoadingOperation.Replace, self)
	loader.start()


	if level == 1:
		await level_transition.start()
	else:
		await level_transition.start_path(level-2)

	if not loader.is_completed:
		await loader.OnComplete

	loader.change_scene()
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/game_over/info/level.text = str(level)
	$AnimationPlayer.play_backwards("change_scene")

func change_scene(scene):
	AsyncScene.new(scene, AsyncScene.LoadingOperation.ReplaceImmediate, self) \
		.with_transition(AsyncScene.TransitionType.Iris, 1.0, Color.CADET_BLUE) \
		.start()



func _on_tryagain_pressed() -> void:
	level = 1
	change_scene(level_path[0])


func _on_quit_pressed() -> void:
	change_scene(main_menu)
