extends KinematicBody

signal hit

# Exported variables for tweaking player movement characteristics
export var speed = 14
export var jump_impulse = 20
export var bounce_impulse = 16
export var fall_acceleration = 75

var velocity = Vector3.ZERO
var camera
var pivot
var current_yaw = 0.0
var base_speed = 14
var boost_timer = null

func _ready():
	# Initialize camera and pivot nodes, and connect signals
	camera = get_node("target/Camera")
	pivot = get_node("Pivot")
	boost_timer = Timer.new()
	boost_timer.set_wait_time(3.0)
	boost_timer.set_one_shot(true)
	boost_timer.connect("timeout", self, "_on_BoostTimer_timeout")
	add_child(boost_timer)
	
	if camera == null:
		print("Error: Camera node not found")
		return
	if pivot == null:
		print("Error: Pivot node not found")
		return
		
	camera.connect("camera_rotated", self, "_on_camera_rotated")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture the mouse

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	# Capture input for movement direction
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		var forward = Vector3(sin(current_yaw), 0, cos(current_yaw))
		var right = Vector3(forward.z, 0, -forward.x)
		direction = (direction.x * right + direction.z * forward).normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
		$AnimationPlayer.playback_speed = 4
	else:
		$AnimationPlayer.playback_speed = 1

	# Apply horizontal movement
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Apply jumping logic
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse

	# Apply gravity
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)

	# Handle collisions
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("mob"):
			var mob = collision.collider
			if Vector3.UP.dot(collision.normal) > 0.1:
				mob.squash()
				velocity.y = bounce_impulse

	# Adjust pivot rotation based on vertical velocity
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func _on_camera_rotated(yaw):
	# Update current yaw based on camera rotation
	current_yaw = yaw
	rotation.y = yaw

func die():
	# Signal that the player has been hit and queue free
	emit_signal("hit")
	queue_free()

func _on_MobDetector_body_entered(_body):
	# Call die function if mob is detected
	die()

func apply_speed_boost(amount):
	base_speed = speed  # Save the current speed as base speed
	speed += amount
	if boost_timer.is_stopped():
		boost_timer.start()

func _on_BoostTimer_timeout():
	speed = base_speed  # Reset to base speed
