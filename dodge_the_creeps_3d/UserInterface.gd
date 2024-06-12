extends Control

onready var time : = get_node("Timer") 
	
signal var_timer()



func _on_Timer_ready(total_play_time :float) -> void:
	var minutes : String = str(int(total_play_time / 60.0))
	var seconds : String = str(int(fmod(total_play_time, 60.0)))
	var time_text = "Total time : %s m %s s" % [minutes, seconds]
	time.text = time_text
	emit_signal('var_timer')
	
	show()
