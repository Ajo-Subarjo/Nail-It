extends Node2D

var hit := 0
var finish = false

signal nail_finish


func _on_hitbox_body_entered(body: Node2D) -> void:

	if body.name != "Hammer":
		return

	if body.power >= 330 and !finish:
		hit+= 1
		position.x -= 20
		#print("hammer bonk", body.power)
		#body.reset_power()
		if hit >= 4:
			nail_finish.emit()
			$Hitbox.monitoring = false
			finish = true
			print("nail finish")

	
