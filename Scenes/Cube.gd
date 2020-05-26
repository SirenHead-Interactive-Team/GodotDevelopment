extends KinematicBody

var camera
var color
var velocity = Vector3()
var gravity = -9.81

var ACCELERATION = 3
var DECELERATION = 5
var SPEED = 6
var JUMP_STRENGTH = 250
var TRANSFORM

var big_boi_fall_down = false

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("../Camera").get_global_transform()
	TRANSFORM = get_global_transform()
	color = get_node("Shape").mesh.surface_get_material(0).get_albedo()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if big_boi_fall_down:
		print("Whoops")
		big_boi_fall_down = false
		
		set_transform(TRANSFORM)
		
		velocity = Vector3()
	else:
		var dir = Vector3()
		
		if(Input.is_action_pressed("move_bw")):
			dir += camera.basis[2]
		if(Input.is_action_pressed("move_fw")):
			dir += -camera.basis[2]
		if(Input.is_action_pressed("move_l")):
			dir += -camera.basis[0]
		if(Input.is_action_pressed("move_r")):
			dir += camera.basis[0]
			
		dir.y = 0
		dir = dir.normalized()
		
		
		var hv = velocity
		hv.y = 0
		
		var new_pos = dir * SPEED
		var accel = DECELERATION
		
		if (dir.dot(hv) > 0):
			accel = ACCELERATION
		
		if(is_on_floor()):
			if(Input.is_action_pressed("move_jump")):
				velocity.y = JUMP_STRENGTH * delta
		else:
			velocity.y += delta * gravity
		
		hv = hv.linear_interpolate(new_pos, accel * delta)
		
		velocity.x = hv.x
		velocity.z = hv.z
		
	velocity = move_and_slide(velocity, Vector3(0,1,0))


func _on_Area_body_entered(body):
	if body.get_instance_id() == get_instance_id():
		get_node("Shape").mesh.surface_get_material(0).set_albedo(Color(1, 0, 0, 1))


func _on_Area_body_exited(body):
	if body.get_instance_id() == get_instance_id():
		get_node("Shape").mesh.surface_get_material(0).set_albedo(color)


func _on_Area_body_shape_exited(body_id, body, body_shape, area_shape):
	print(area_shape)
	print(body_shape)


func _on_Area_out_of_bounds(_body):
	print("Whoops")
	big_boi_fall_down = true
