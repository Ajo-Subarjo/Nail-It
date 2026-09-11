extends Node2D

@onready var sprite: Sprite2D = $Paint

@export var img_size := Vector2i(128, 170)
@export var brush_size := 15
@export var paint_color: Color

var painted_pixels := 0

var image: Image


func _ready():
	image = Image.create_empty(img_size.x, img_size.y, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	sprite.texture = ImageTexture.create_from_image(image)



func paint_at(pos: Vector2i) -> void:
	var rect := Rect2i(pos - Vector2i(brush_size, brush_size), Vector2i(brush_size * 2, brush_size * 2))
	rect = rect.intersection(Rect2i(Vector2i.ZERO, img_size))
	if rect.has_area():
		for y in range(rect.position.y, rect.end.y):
			for x in range(rect.position.x, rect.end.x):
				var old_color := image.get_pixel(x,y)
				
				if old_color == Color.WHITE:
					painted_pixels +=1
				image.set_pixel(x,y, paint_color)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var local_pos := sprite.to_local(get_local_mouse_position())
		var img_pos := local_pos - sprite.offset + sprite.get_rect().size / 2.0
		paint_at(Vector2i(img_pos))
		sprite.texture.update(image)

func _process(delta: float) -> void:
	print(int(get_coverage() * 100.0),"%")

func get_coverage() -> float:
	var total := img_size.x * img_size.y
	return float(painted_pixels) / float(total)
