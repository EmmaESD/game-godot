extends Node

export(PackedScene) var mob_scene

signal playerDead

func _ready():
	randomize()
	$UserInterface/Retry.hide()
	
	var speed_booster = get_node("SpeedBooster")
	# Capture and ignore the return value of the connect() function
	var _unused1 = speed_booster.connect("boosted", $UserInterface/BoostLabel, "_on_SpeedBooster_boosted")
	var _unused2 = self.connect("playerDead", $SpeedBooster, "_on_Player_dead")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# Capture the return value and ignore it to avoid the warning
		var _unused3 = get_tree().reload_current_scene()

func _on_MobTimer_timeout():
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()
	
	var player_position = $Player.transform.origin

	add_child(mob)
	# Connect the mob's "squashed" signal to the ScoreLabel's "_on_Mob_squashed" method.
	# Capture and ignore the return value of the connect() function
	var _unused4 = mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
	mob.initialize(mob_spawn_location.translation, player_position)

func _on_Player_hit():
	emit_signal("playerDead")
	$MobTimer.stop()
	$UserInterface/Retry.show()
