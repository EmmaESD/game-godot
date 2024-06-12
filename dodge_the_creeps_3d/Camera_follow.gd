extends Camera

export var distance = 6.0
export var height = 3.0
export var mouse_sensitivity = 0.005  # Réduire la sensibilité de la souris

var yaw = 0.0
var pitch = 0.0

signal camera_rotated(yaw)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture the mouse

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var target = get_parent().get_global_transform().origin
	var up = Vector3(0,1,0)

	var offset = Vector3()
	offset.z = distance * cos(yaw)
	offset.x = distance * sin(yaw)
	offset.y = height

	var pos = target + offset

	look_at_from_position(pos, target, up)
	emit_signal("camera_rotated", yaw)

func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -1.5, 1.5)  # Limit pitch to prevent flipping
