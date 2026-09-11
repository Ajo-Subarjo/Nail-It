extends CharacterBody2D


@export var label = Label

@export var hammer_speed := 8.0
@export var hammer_max_power := 800
@export var rotation_speed := 8.0
@export var rotation_amount := 0.5

var is_click : bool = false

var last_mouse := Vector2.ZERO
var start_swing := Vector2.ZERO


var target_rotation := 0.0 
var target_position := Vector2.ZERO
var power : int


func _ready() -> void:
	last_mouse = global_position
	start_swing = global_position
	target_position = global_position

func _physics_process(delta: float) -> void:

	if is_click:
		target_position = get_global_mouse_position()

	var movement := target_position - global_position
	
	velocity = movement * hammer_speed
	move_and_slide()
	power = abs(movement.x)

	#print(movement.x, "  ",get_real_velocity().x)
	

	label.text = str(movement)

	if is_click:
		if velocity.x > 50 :
			target_rotation = deg_to_rad(25.0)
		elif velocity.x < -50:
			target_rotation = deg_to_rad(-25.0)
		else:
			target_rotation = deg_to_rad(0.0)


	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)





func _on_hammer_up() -> void:
	is_click = false
	target_rotation = deg_to_rad(0)
	last_mouse = target_position
	
func _on_hammer_down() -> void:
	is_click = true
	target_position = get_global_mouse_position()
