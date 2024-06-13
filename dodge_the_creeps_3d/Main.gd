extends Node

export(PackedScene) var mob_scene

signal playerDead
signal finalScore(score_number)

signal level_completed

var score = 0
var elapsed_time: int = 0
var play_time = 0.0  # Corrected syntax

onready var timer: Timer = $UserInterface/TimeLabel/Timer
onready var time_label: Label = $UserInterface/TimeLabel
onready var final_menu = $FinalMenu
onready var player = $Player


func _ready():
	randomize()
	var level1 = $Level1  # Correct node path should be verified here
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start()
	$UserInterface/Retry.hide()
	$FinalMenu.hide()
	level1.connect("level_completed", self, "_on_Goal_body_entered")  # Assuming this is the correct node

func _on_Timer_timeout():
	elapsed_time += 1
	var minutes = elapsed_time / 60
	var seconds = elapsed_time % 60
	time_label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()
	
	if is_instance_valid(player):
		var player_position = $Player.transform.origin
		add_child(mob)
		mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
		mob.connect("squashed", self, "_on_Mob_squashed")
		mob.initialize(mob_spawn_location.translation, player_position)

	add_child(mob)
	# Connect the mob's "squashed" signal to the ScoreLabel's "_on_Mob_squashed" method.
	# Capture and ignore the return value of the connect() function
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
	mob.connect("squashed", self, "_on_Mob_squashed")
	mob.initialize(mob_spawn_location.translation, player_position)
	
func _on_Mob_squashed():
	score += 1
	
onready var final_menu : = $FinalMenu
onready var player : = $Player
var play_time : = 0.0

func _process(delta: float) -> void:
	play_time += delta

func _on_Player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	emit_signal("playerDead")

	self.connect("finalScore", $PauseHandler/UserInterface/Pause/BestScore, "_on_final_score")
	emit_signal("finalScore", score)
	

func _on_Goal_body_entered():
	$MobTimer.stop()
	print("arriver sur le drapeau")
	$FinalMenu.show()
	stop_timer()
	emit_signal("finalScore", score)
	emit_signal("level_completed")

func stop_timer():
	timer.stop()
	Global.final_time = elapsed_time 

func _on_Level_1_level_completed():
	print("connect")
	var total_play_time = play_time
	player.queue_free()
	final_menu.initialize(total_play_time)

func _on_FinalMenu_retried():
	get_tree().reload_current_scene()


func _on_Main_level_completed():
	print("connect")
	player.queue_free()
	final_menu.initialize()
