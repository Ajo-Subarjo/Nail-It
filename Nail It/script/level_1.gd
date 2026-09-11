extends  Node2D

@onready var nail_group = $"nail group"

var nail_count = 0



func _ready() -> void:
	for child in nail_group.get_children():
		child.nail_finish.connect(_on_nail_finish)



func _on_nail_finish():
	nail_count += 1
	if nail_count >= 4:
		print("finish next level")
#func _process(delta: float) -> void:
