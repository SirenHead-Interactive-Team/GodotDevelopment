extends KinematicBody

var color
var camera
var character
var velocity = Vector3()
var gravity = -9.81

var ACCELERATION = 3
var DECELERATION = 5
var TURN_STEP = 0.1
var SPEED = 6
var JUMP_STRENGTH = 250
var TRANSFORM

var big_boi_fall_down = false

# Called when the node enters the scene tree for the first time.
func _ready():
    character = get_node(".")
    camera = get_node("target/Perspective").get_global_transform()
    color = get_node("Shape").mesh.surface_get_material(0).get_albedo()

    if TRANSFORM == null:
        TRANSFORM = get_global_transform()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
    camera = get_node("target/Perspective").get_global_transform()

    var is_moving = false

    if big_boi_fall_down:
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
        if dir.length() > 0:
            is_moving = true

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

    if is_moving:
        rotating_player_turn()

func rotating_player_turn():
    var res = 0
    var angle = atan2(velocity.x, velocity.z)
    var char_rot = character.get_rotation().y
    var diff = get_circular_diff_PI(angle, char_rot)

    if diff < TURN_STEP:
        res = angle
    else:
        if (angle+PI) < (char_rot+PI):
            diff = -TURN_STEP
        else:
            diff = TURN_STEP
        res = char_rot+diff

    transform.basis = Basis()
    rotate_object_local(Vector3(0, 1, 0), res)

func get_circular_diff_PI(ang1, ang2):
    var unit = PI
    ang1 += unit
    ang2 += unit

    var min_ang = min(ang1, ang2)
    var max_ang = max(ang1, ang2)

    return min(2*unit + min_ang - max_ang, max_ang - min_ang)

func print_all(list):
    print("---")
    for item in list:
        print(item)

func _on_ColorChangeBox_body_entered(body):
    if body.get_instance_id() == get_instance_id():
        get_node("Shape").mesh.surface_get_material(0).set_albedo(Color(1, 0, 0, 1))


func _on_ColorChangeBox_body_exited(body):
    if body.get_instance_id() == get_instance_id():
        get_node("Shape").mesh.surface_get_material(0).set_albedo(color)


func _on_Area_out_of_bounds(body):
    if body.get_instance_id() == get_instance_id():
        big_boi_fall_down = true
