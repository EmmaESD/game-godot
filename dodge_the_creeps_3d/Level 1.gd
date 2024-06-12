extends Spatial

signal level_completed()

func _on_Goal_body_entered(body):
	if body.name == "Player":
		print('level completed')
		emit_signal('level_completed')
		
		


func _on_Level_1_level_completed():
	pass # Replace with function body.
