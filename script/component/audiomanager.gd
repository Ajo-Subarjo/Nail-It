extends Node

@onready var audio = $AudioStreamPlayer
@onready var hover = $Hover
@onready var click = $Click

var sfx = {
	}

func _ready() -> void:
	setup_audio()
	

func setup_audio():
	for button in get_tree().get_nodes_in_group("Button"):
		button.mouse_entered.connect(_play_hover)
		button.pressed.connect(_play_click)



func play(name : String):
	audio.stream = sfx[name]
	audio.play()


func _play_click():
	click.stop()
	click.play()

func _play_hover():
	hover.stop()
	hover.play()
