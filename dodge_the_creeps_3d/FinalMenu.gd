# FinalMenu.gd
extends Control

signal retried

# Reference to the Label to display the final time
onready var final_time_label: Label = $CenterContainer/Column/Time

# Function called at startup

# Function called when the Try Again button is pressed
func _on_TryAgain_pressed():
	emit_signal("retried")

# Function called when the Exit button is pressed
func _on_Exit_pressed():
	get_tree().quit()

# Ensure the initialize function is defined
func initialize():
	var final_time = Global.final_time
	var minutes = int(final_time / 60)
	var seconds = int(final_time % 60)
	final_time_label.text = "Temps final: " + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
