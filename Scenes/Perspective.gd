extends Camera

export var distance = 8.0
export var height = 2.0
var parent_height

# Called when the node enters the scene tree for the first time.
func _ready():
    set_as_toplevel(true)
    parent_height = get_parent().get_translation().y

    set_rotation_degrees(Vector3(0, 0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
    var target = get_parent().get_global_transform().origin
    var pos = get_global_transform().origin
    var up = Vector3(0, 1, 0)

    var offset = pos - target

    offset = offset.normalized() * distance
    offset.y = height

    if target.y < parent_height:
        offset.y -= (target.y - parent_height) / 2

    pos = target + offset

    look_at_from_position(pos, target, up)
