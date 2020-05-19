extends RigidBody2D

export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.
var mob_types = ["walk", "swim", "fly"]
var mob_capsule_hitbox = ["walk", "swim"]

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.set_animation(mob_types[randi() % mob_types.size()])
	
	if $AnimatedSprite.animation in mob_capsule_hitbox:
		var capsule = CapsuleShape2D.new()
		capsule.set_radius(36)
		capsule.set_height(27)
		$CollisionShape2D.set_shape(capsule)

	$AnimatedSprite._set_playing(true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func set_movement(spawn_location):
	set_rotation(spawn_location)
	set_linear_velocity(rotation)

func set_rotation(spawn_location):
	var variation = rand_range(-PI / 4, PI / 4)
	rotation = (spawn_location.rotation + PI / 2) + variation
	
	position = spawn_location.position

func set_linear_velocity(direction):
	linear_velocity = Vector2(rand_range(min_speed, max_speed), 0).rotated(direction)
