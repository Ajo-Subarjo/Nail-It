extends CharacterBody2D


@export var label = Label

@export var painter_speed := 12.0
@export var hammer_max_power := 800
@export var rotation_speed := 8.0
@export var rotation_amount := 0.5

@onready var sprite: Sprite2D = $"../Paint"
@export var img_size := Vector2i(128, 170)
@export var brush_size := 15
@export var paint_color: Color

var painted_pixels := 0
var image: Image
var paint_amount := 1000
var is_can_paint = true
@onready var painter_roll = $PainterRoll


var is_click : bool = false
var last_mouse := Vector2.ZERO
var target_rotation := 0.0 
var target_position := Vector2.ZERO
var power : int


func _ready() -> void:
	img_size = Vector2i(sprite.texture.get_size())
	image = Image.create_empty(img_size.x, img_size.y, false,Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	sprite.texture = ImageTexture.create_from_image(image)

	last_mouse = global_position
	target_position = global_position

func _physics_process(delta: float) -> void:

	if is_click:
		target_position = get_global_mouse_position()

	var movement := target_position - global_position
	velocity = movement * painter_speed
	move_and_slide()

	label.text = str(movement)
	if paint_amount > 0 :
		paint_amount -= movement.length() * 0.025


	if is_click:
		if velocity.x > 50 :
			target_rotation = deg_to_rad(15.0)
		elif velocity.x < -50:
			target_rotation = deg_to_rad(-15.0)
		else:
			target_rotation = deg_to_rad(0.0)
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)

func _process(delta: float) -> void:
	set_saturation(paint_amount * 0.001)


func paint_at(pos: Vector2i) -> void:
	var rect := Rect2i(pos - Vector2i(brush_size, brush_size), Vector2i(brush_size * 2, brush_size * 2))
	rect = rect.intersection(Rect2i(Vector2i.ZERO, img_size))
	if rect.has_area() and paint_amount > 0:
		for y in range(rect.position.y, rect.end.y):
			for x in range(rect.position.x, rect.end.x):
				var old_color := image.get_pixel(x,y)
				if old_color == Color.TRANSPARENT:
					painted_pixels +=1
				image.set_pixel(x,y, paint_color)


func set_saturation(value: float) -> void:
	var painter_saturation = painter_roll.material as ShaderMaterial
	painter_saturation.set_shader_parameter("saturation", value)


func paint():
		var local_pos := sprite.to_local(global_position)
		var img_pos := local_pos - sprite.offset + sprite.get_rect().size / 2.0
		paint_at(Vector2i(img_pos))
		sprite.texture.update(image)


func get_coverage() -> float:
	var total := img_size.x * img_size.y
	return float(painted_pixels) / float(total)


func _on_painter_up() -> void:
	is_click = false
	target_rotation = deg_to_rad(0)
	$Painter.texture = load("res://sprite/painter.png")
	$PainterRoll.texture = load("res://sprite/painter roll.png")
	last_mouse = target_position
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_painter_down() -> void:
	is_click = true
	$Painter.texture = load("res://sprite/painter pressed.png")
	$PainterRoll.texture = load("res://sprite/painter roll pressed.png")
	target_position = get_global_mouse_position()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_click:
		paint()
