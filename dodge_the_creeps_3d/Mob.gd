extends KinematicBody

# Emitted when the player jumped on the mob.
signal squashed

# Minimum speed of the mob in meters per second.
export var min_speed = 10
# Maximum speed of the mob in meters per second.
export var max_speed = 18

var velocity = Vector3.ZERO
var change_direction_timer = 0
var detection_radius = 10.0
var player = null

func _ready():
	change_direction_timer = rand_range(2, 5)  # Initial direction change timer
	# Find player in the group "player"
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta):
	change_direction_timer -= delta
	if change_direction_timer <= 0:
		change_direction_timer = rand_range(2, 5)
		random_rotate()

	var collision_info = move_and_slide(velocity)

	if collision_info:
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)

			# Start the wait and turn coroutine
			yield(wait_and_turn(), "completed")
			break  # Exit loop after handling collision

func initialize(start_position, player_position):
	translation = start_position
	look_at(player_position, Vector3.UP)
	rotate_y(rand_range(-PI / 4, PI / 4))

	var random_speed = rand_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
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


