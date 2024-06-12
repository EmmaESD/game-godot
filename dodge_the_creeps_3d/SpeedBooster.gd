extends Area

signal boosted(new_text)

var speed_boost = 10.0
var boost_active = false
var boosted_player = null
var player_dead = false

func _on_Player_dead ():
	player_dead = true

func _ready():
	$Timer.wait_time = 3.0
	$Timer.one_shot = true

func _on_SpeedBooster_body_entered(body):
	if body.name == "Player" and not boost_active:
		body.speed += speed_boost
		boost_active = true
		boosted_player = body
		$Timer.start()
		emit_signal("boosted", "Boost Activé !")

func _on_Timer_timeout():
	if !player_dead:
		if boosted_player:
			boosted_player.speed -= speed_boost
			boost_active = false
			boosted_player = null
			emit_signal("boosted", "")
