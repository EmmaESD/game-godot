extends Camera

# Variables exportées
export var distance = 4.0
export var height = 2.0

# Initialisation
func _ready():
	set_physics_process(true)
	set_as_toplevel(true)

func _physics_process(_delta):
	var pivot = get_parent() # Suppose que le pivot est le parent direct de la caméra
	var target = pivot.global_transform.origin
	
	var offset = -pivot.global_transform.basis.z * distance
	offset.y = height
	
	var pos = target + offset
	
	# Ajuster légèrement la position de la caméra pour éviter l'alignement avec le vecteur up
	pos += Vector3(0.1, 0.1, 0)

	# Mise à jour de la position de la caméra
	global_transform.origin = pos
	
	# Utiliser look_at pour diriger la caméra vers la cible
	look_at(target, Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
