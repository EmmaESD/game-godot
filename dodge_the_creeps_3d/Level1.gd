extends Spatial

signal level_completed()

func _on_Goal_body_entered(_body):
	print('level completed')
	emit_signal('level_completed')
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Level_1_level_completed():
	pass
