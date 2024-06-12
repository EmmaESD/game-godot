extends Node

export(PackedScene) var mob_scene

signal playerDead
signal finalScore(score_number)
var score = 0

func _ready():
	randomize()
	var Level1 = get_node("Level1")
	$UserInterface/Retry.hide()
	$FinalMenu.hide()
	$Level1.connect("level_completed", self, "_on_Goal_body_entered")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# Capture the return value and ignore it to avoid the warning
		var _result = get_tree().reload_current_scene()

func _on_MobTimer_timeout():
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()
	
	var player_position = $Player.transform.origin

	add_child(mob)
	# Connect the mob's "squashed" signal to the ScoreLabel's "_on_Mob_squashed" method.
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
	mob.connect("squashed", self, "_on_Mob_squashed")
	mob.initialize(mob_spawn_location.translation, player_position)
	
func _on_Mob_squashed():
	score += 1
	
onready var final_menu : = $FinalMenu
onready var player : = $Player
var play_time : = 0.0

func _process(delta : float) -> void:
	play_time += delta
	
func _on_Player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
func _on_Goal_body_entered():
	$MobTimer.stop()
	$FinalMenu.show()
	
func _on_Level_1_level_completed():
	print('connect')
	var total_play_time = play_time
	player.queue_free()
	final_menu.initialize(total_play_time)
func _on_FinalMenu_retried():
	get_tree().reload_current_scene()
