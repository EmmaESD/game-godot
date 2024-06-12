extends Control

signal retried

# Référence au Label pour afficher le temps final
onready var final_time_label: Label = $CenterContainer/Column/Time

# Fonction appelée au démarrage
func _ready():
	# Convertit le temps final en minutes et secondes
	var final_time = Global.final_time
	var minutes = final_time / 60
	var seconds = final_time % 60
	
	# Formate le texte à afficher
	final_time_label.text = "Temps final: " + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)


func _on_TryAgain_pressed():
	emit_signal("retried")

func _on_Exit_pressed():
	get_tree().quit()
