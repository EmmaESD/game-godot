extends KinematicBody

# Emitted when the player jumped on the mob.
signal squashed

# Minimum speed of the mob in meters per second.
export var min_speed = 10
# Maximum speed of the mob in meters per second.
export var max_speed = 18

var velocity = Vector3.ZERO


func _physics_process(_delta):
	move_and_slide(velocity)


func initialize(start_position, player_position):
	translation = start_position
	look_at(player_position, Vector3.UP)
	rotate_y(rand_range(-PI / 4, PI / 4))

	var random_speed = rand_range(min_speed, max_speed)
	# We calculate a forward velocity first, which represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the vector based on the mob's Y rotation to move in the direction it's looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)

	$AnimationPlayer.playback_speed = random_speed / min_speed


func squash():
	emit_signal("squashed")
	queue_free()


func _on_VisibilityNotifier_screen_exited():
	queue_free()

func random_rotate():
	var angle = rand_range(deg2rad(90), deg2rad(270))
	rotate_y(angle)
	velocity = Vector3.FORWARD * velocity.length()
	velocity = velocity.rotated(Vector3.UP, rotation.y)

# Coroutine to wait for 1 second before turning
func wait_and_turn():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.start()
	rotate_y(rand_range(deg2rad(90), deg2rad(270)))  # Rotate by 180 degrees
	velocity = Vector3.FORWARD * velocity.length()
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	yield(timer, "timeout")
	timer.queue_free()


