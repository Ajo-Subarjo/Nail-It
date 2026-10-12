extends Node2D

@export var heat_curve : Curve
@export var gradient: Gradient


@onready var chainsaw = $Chainsaw
@onready var heatbar = $Heatbar
@onready var camera = $Camera

var progress := 0.0
var progress_percentage = 0.0

var trigger := false
var heat := 0.0
var heat_progress := 0.0
var finish = false


var overheat := false
var smoke_alpha := 0.0




func _ready() -> void:
	$Chainsaw.play("idle")
	await get_tree().create_timer(1).timeout
	GameManager.paused = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("chainsaw trigger") and !overheat and!finish:
		print("brrrrrr")
		$Chainsaw/CPUParticles2D.emitting = true
		$Chainsaw/CPUParticles2D2.emitting = true
		chainsaw.play("trigger")
		chainsaw.speed_scale = 8
		trigger = true
		camera.start_shake(1)

	if event.is_action_released("chainsaw trigger") and !finish:
		$Chainsaw/CPUParticles2D.emitting = false
		$Chainsaw/CPUParticles2D2.emitting = false
		trigger = false
		chainsaw.play("idle")
		chainsaw.speed_scale = 1
		camera.stop_shake()


func _process(delta: float) -> void:

	if trigger and heat <= heatbar.max_value and !overheat:
		heat_progress += delta
		heat_progress = clamp(heat_progress, 0.0, 3.0)
		var t = heat_progress / 3.0
		heat = heat_curve.sample(t) * 100.0

		progress += 0.001
		progress_percentage = progress * 100
		#print(progress_percentage)
		$Progress.value = progress_percentage

	if !trigger and heat >= heatbar.min_value and !overheat:
		heat_progress -= delta
		heat_progress = clamp(heat_progress, 0.0, 3.0)
		var t = heat_progress / 3.0
		heat = heat_curve.sample(t) * 100.0

	if progress_percentage >= 90 and !finish:
		finish = true
		trigger = false

		chainsaw.play("idle")
		chainsaw.speed_scale = 1
		camera.stop_shake()
		
		#await get_tree().create_timer(2).timeout
		$LogLeft.hide()
		$LogRight.play("finish")
		await get_tree().create_timer(1).timeout
		GameManager.paused = true
		GameManager.level = 4
		GameManager.update_time()
		GameManager.change_level()


	update_log(delta)
	update_heat()
	check_overheat()


func check_overheat():
	if heat > 90:
		$Chainsaw/SmokeBack.play("default")
		$Chainsaw/SmokeFront.play("default")

	smoke_alpha = remap(heat, 85.0, 100.0, 0.0, 0.5)
	$Chainsaw/SmokeBack.modulate.a = smoke_alpha
	$Chainsaw/SmokeFront.modulate.a = smoke_alpha

	if heat == 100 and !overheat:
		overheat = true
		trigger = false

		chainsaw.play("idle")
		chainsaw.speed_scale = 1
		camera.stop_shake()

		await get_tree().create_timer(3).timeout
		overheat = false



func update_log(delta):
	if finish:
		return
	
	if trigger:
		progress = clamp(progress, 0.0, 1.0)
		chainsaw.position.y =  lerp(245.0, 426.0, progress)
	else:
		chainsaw.position.y = lerp(chainsaw.position.y, 245.0, 10 * delta)

	var frame = int(progress_percentage / 100.0 * 24.0)
	$LogRight.frame = frame
	#print(frame)


func update_heat():
	heatbar.value = heat
	var t = remap(heat, 0, 100, 80, 210)
	$Heatbar/Label.text = "%d°C" % t
	var color = gradient.sample(heat / heatbar.max_value)
	heatbar.get_theme_stylebox("fill").bg_color = color


func _on_debug_pressed() -> void:
	GameManager.level = 4
	GameManager.change_level()
