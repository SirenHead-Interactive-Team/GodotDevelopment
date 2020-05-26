extends KinematicBody

var gravity = -9.81
var velocity = Vector3()
var camera

const SPEED = 6
const ACCELERATION = 3
const DECELERATION = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("../Camera").get_global_transform()
	set_physics_process(true)

func _physics_process(delta):
	var dir = Vector3()
	
	if(Input.is_action_pressed("move_fw")):
		dir += -camera.basis[2]
	if(Input.is_action_pressed("move_bw")):
		dir += camera.basis[2]
	if(Input.is_action_pressed("move_l")):
		dir += -camera.basis[0]
	if(Input.is_action_pressed("move_r")):
		dir += camera.basis[0]
	
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y += delta * gravity
	
	var hv = velocity
	hv.y = 0
	
	var new_pos = dir * SPEED
	var accel = DECELERATION
	
	if (dir.dot(hv) > 0):
		accel = ACCELERATION
	
	hv.linear_interpolate(new_pos, accel * delta)
	
	velocity.x = hv.x
	velocity.z = hv.z
	
	
	if (dir.length() > 0):
		print("Direction: " + str(dir))
		print("Velocity: " + str(velocity))
		
	# velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
	move_and_slide(velocity)
