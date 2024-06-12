extends Spatial

signal level_completed()

func _on_Goal_body_entered(body):
	if body.name == "Player":
		print('level completed')
		emit_signal('level_completed')
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_level_1_level_completed():
	pass

