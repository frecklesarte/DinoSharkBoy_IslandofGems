extends Skeleton3D

@onready var character = $Skeleton3D
var character_speed = 0.1

func _physics_process(delta):
	forward = Vector3.MODEL_FRONT
	
	var cam_forward = -camera_forward.abs().max_axis()
	cam_forward
