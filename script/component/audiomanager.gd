extends Node

@onready var audio = $AudioStreamPlayer
@onready var hover = $Hover
@onready var click = $Click

var sfx = {
	}

func _ready() -> void:
	$bgm.play()
	setup_audio()
	

func setup_audio():
	for button in get_tree().get_nodes_in_group("Button"):
		button.mouse_entered.connect(_play_hover)
		button.pressed.connect(_play_click)



func play(name : String):
	audio.stream = sfx[name]
	audio.play()

func hammer_hit():
	$hammer_hit.play()

func meter_down():
	$meter.play()
	await get_tree().create_timer(0.14).timeout
	$meter.stop()

func meter_up():
	$meter.play(0.15)


func set_bgmvolume(vol):
	$bgm.volume_db = vol

func paint(pitch):
	$paint.pitch_scale = pitch
	$paint.play()


func start_chainsaw():
	$"idle-chainsaw".stop()
	$chainsaw.play()

func stop_chainsaw():
	$chainsaw.stop()
	$"idle-chainsaw".play()

func _play_click():
	click.stop()
	click.play()

func _play_hover():
	hover.stop()
	hover.play()
