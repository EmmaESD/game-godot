extends Area

signal boosted(new_text)

var speed_boost = 10.0
var boost_active = false
var boosted_player = null
var player_dead = false

func _on_Player_dead():
	player_dead = true

func _ready():
	pass  # No need for a timer here

func _on_SpeedBooster_body_entered(body):
	if body.name == "Player" and not boost_active:
		body.apply_speed_boost(speed_boost)
		boost_active = true
		boosted_player = body
		emit_signal("boosted", "Boost Activé !")
		queue_free()  # Remove the booster after applying the boost
