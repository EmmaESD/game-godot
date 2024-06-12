extends Spatial

signal level_completed()

func _on_Goal_body_entered(body):
	if body.name == "Player":  # assuming the node name is "Player"
		emit_signal('level_completed')
