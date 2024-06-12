extends Control

signal retried

func _on_TryAgain_pressed():
	emit_signal("retried")

func _on_Exit_pressed():
	get_tree().quit()
