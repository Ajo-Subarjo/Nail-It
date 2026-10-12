extends Node2D

@onready var roll = $Tape/TapeMeasure
@onready var rollmarker = $Tape/TapeMeasure/Button/Marker2D

@onready var end = $Tape/TapeEnd
@onready var tape = $Tape/TapeProg

var target_pos := Vector2()
var click := false

var Xstartpos := 0.0
var target_meter := 0
var current_meter := 0
var meter := 0

var back := false

func _ready() -> void:
	generate_task()
	GameManager.paused = false

func _process(delta: float) -> void:
	if click :
		roll.position.x = clampf($Tape.to_local(get_global_mouse_position()).x, -9150.0, 1272.0)
	
	var a = end.position.x
	var s = roll.position.x
	var length = abs(a - s)
	current_meter = remap(length, 479, 10891, 0, meter)
	
	if back:
		roll.position.x = move_toward(roll.position.x, 1272.0, 9800.0 * delta)
		back = roll.position.x != 1272.0
	
	
	tape.scale.x = (length / tape.texture.get_width()) * -1
	$Tape/TapeMeasure/Label.text = str(int(current_meter), "  target_meter")


func _on_button_button_down() -> void:
	click = true

func _on_button_button_up() -> void:
	click = false
	var lb = $Lb.duplicate()
	$Label.add_child(lb)

	lb.global_position.x = roll.global_position.x + 8
	lb.global_position.y = roll.global_position.y - 50
	lb.get_child(1).text = str(current_meter, " M")
	lb.visible = true

	back = true
	print(roll.global_position.x)

	if current_meter == target_meter:
		print("you are right!!")
		GameManager.paused = true
		GameManager.level = 5
		GameManager.update_time()
		GameManager.completed()
		#GameManager.



func generate_task():
	meter = randi_range(50, 120)
	target_meter = randi_range(10, meter - 15)
	$Label/endmeter.text = str(meter)
	print(target_meter)

func _on_debug_pressed() -> void:
	GameManager.level = 4
	GameManager.change_level()
