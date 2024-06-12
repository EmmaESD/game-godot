extends Node

export(PackedScene) var mob_scene

var elapsed_time: int = 0

# Références aux nœuds Timer et Label
onready var timer: Timer = $UserInterface/TimeLabel/Timer
onready var time_label: Label = $UserInterface/TimeLabel

func _ready():
	randomize()
	var Level1 = get_node("Level1")
	timer.connect("timeout", self, "_on_Timer_timeout")
	# Démarre le Timer
	timer.start()
	$UserInterface/Retry.hide()
	$FinalMenu.hide()
	$Level1.connect("level_completed", self, "_on_Goal_body_entered")
	

func _on_Timer_timeout():
	# Augmente le temps écoulé de 1 seconde
	elapsed_time += 1
	
	# Convertit le temps écoulé en minutes et secondes
	var minutes = elapsed_time / 60
	var seconds = elapsed_time % 60
	
	# Formate le texte à afficher
	time_label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()


func _on_MobTimer_timeout():
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()

	var player_position = $Player.transform.origin

	add_child(mob)
	# We connect the mob to the score label to update the score upon squashing a mob.
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
	mob.initialize(mob_spawn_location.translation, player_position)

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
	stop_timer()

func stop_timer():
	timer.stop()
	Global.final_time = elapsed_time 


func _on_Level_1_level_completed():
	print('connect')
	var total_play_time = play_time
	player.queue_free()
	final_menu.initialize(total_play_time)


func _on_FinalMenu_retried():
	get_tree().reload_current_scene()
	
