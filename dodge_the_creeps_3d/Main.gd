extends Node

export(PackedScene) var mob_scene
export(PackedScene) var mob_kat_scene
export(PackedScene) var mob_spider_scene

signal playerDead
signal finalScore(score_number)
signal level_completed

var score = 0
var elapsed_time: int = 0
var play_time = 0.0

onready var timer: Timer = $UserInterface/TimeLabel/Timer
onready var time_label: Label = $UserInterface/TimeLabel
onready var final_menu = $FinalMenu
onready var player = $Player

func _ready():
	randomize()
	var Level1 = get_node("Level1")
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start()
	$UserInterface/Retry.hide()
	$FinalMenu.hide()
	$Level1.connect("level_completed", self, "_on_Goal_body_entered")
	
func _on_Timer_timeout():
	elapsed_time += 1
	var minutes = elapsed_time / 60
	var seconds = elapsed_time % 60
	time_label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# Capture the return value and ignore it to avoid the warning
		var _result = get_tree().reload_current_scene()

func _on_MobTimer_timeout():
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()
	var kat = mob_kat_scene.instance()
	var spider = mob_spider_scene.instance()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()
	
	var player_position = $Player.transform.origin

	add_child(mob)
	# Connect the mob's "squashed" signal to the ScoreLabel's "_on_Mob_squashed" method.
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
	mob.initialize(mob_spawn_location.translation, player_position)
	
	add_child(kat)
	# Connect the mob's "squashed" signal to the ScoreLabel's "_on_Mob_squashed" method.
	kat.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
	kat.initialize(mob_spawn_location.translation, player_position)
	
	add_child(spider)
	# Connect the mob's "squashed" signal to the ScoreLabel's "_on_Mob_squashed" method.
	spider.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
	spider.initialize(mob_spawn_location.translation, player_position)
	
func _on_Mob_squashed():
	score += 1
	


func _process(delta : float) -> void:
	play_time += delta
	
func _on_Player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	emit_signal("playerDead")
	
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
	
func _on_Level1_level_completed():
	print('connect level1Completed')
	player.queue_free()
	final_menu._ready()
	
func _on_FinalMenu_retried():
	get_tree().reload_current_scene()

func _on_Main_level_completed():
	print("connectMainLevelCompleted")
	player.queue_free()
	final_menu._ready()
