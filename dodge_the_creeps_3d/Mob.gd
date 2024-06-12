extends KinematicBody

# Emitted when the player jumped on the mob.
signal squashed

# Minimum speed of the mob in meters per second.
export var min_speed = 10
# Maximum speed of the mob in meters per second.
export var max_speed = 18

var velocity = Vector3.ZERO

func _physics_process(delta):
	# Capture the return value of move_and_slide to avoid the warning
	var _unused = move_and_slide(velocity)

	# Check for collisions
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("level1"):  # Assure that your walls are in the "wall" group
			rotate_y(deg2rad(90))  # Rotate by 90 degrees
			velocity = Vector3.FORWARD * velocity.length()  # Maintain current speed
			velocity = velocity.rotated(Vector3.UP, rotation.y)
			break  # Exit loop after handling collision

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
