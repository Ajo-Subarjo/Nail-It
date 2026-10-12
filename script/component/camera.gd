extends Node2D

@onready var camera =$"camera 2d"

var shake_strength := 0.0
var shaking := false
var shake_fade := 18.0
var one_time := false


func _process(delta):

	if shaking:
		shake_camera()
	elif shake_strength > 0.1 and one_time:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		shake_camera()
		#print(camera.offset)
	else:
		one_time = false
		camera.offset = Vector2.ZERO


func shake_camera():
	camera.offset = Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength)
	)


func start_shake(amount: float):
	shake_strength = amount
	shaking = true

func stop_shake():
	shaking = false
	shake_strength = 0

func shake(amount: float):
	shake_strength = amount
	one_time = true
