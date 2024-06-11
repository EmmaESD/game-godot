extends KinematicBody

signal hit

# How fast the player moves in meters per second.
export var speed = 14
# Vertical impulse applied to the character upon jumping in meters per second.
export var jump_impulse = 20
# Vertical impulse applied to the character upon bouncing over a mob in meters per second.
export var bounce_impulse = 16
# The downward acceleration when in the air, in meters per second per second.
export var fall_acceleration = 75

var velocity = Vector3.ZERO
var camera
var pivot
var current_yaw = 0.0

func _ready():
	camera = get_node("target/Camera")
	pivot = get_node("Pivot")
	camera.connect("camera_rotated", self, "_on_camera_rotated")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture la souris

func _physics_process(delta):
	var direction = Vector3.ZERO
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

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse

	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)

	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("mob"):
			var mob = collision.collider
			if Vector3.UP.dot(collision.normal) > 0.1:
				mob.squash()
				velocity.y = bounce_impulse

	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func _on_camera_rotated(yaw):
	current_yaw = yaw
	rotation.y = yaw

func die():
	emit_signal("hit")
	queue_free()

func _on_MobDetector_body_entered(_body):
	die()
