extends Control

signal retried

onready var final_time_label: Label = $CenterContainer/Column/Time

func _ready():
	var final_time = Global.final_time
	var minutes = final_time / 60
	var seconds = final_time % 60
	
	final_time_label.text = "temps final: " + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	

func _on_TryAgain_pressed():
	emit_signal("retried")

func _on_Exit_pressed():
	get_tree().quit()
