extends Area2D 

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
var sprite_size  # Size of the sprite animation.

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	screen_size = get_viewport_rect().size
	sprite_size = $AnimatedSprite.frames.get_frame("up", 0).get_size() * ($AnimatedSprite.transform.get_scale() / 2 )
	print(sprite_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		print()
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	
	position += velocity * delta
	position.x = clamp(position.x, sprite_size.x, screen_size.x - sprite_size.x)
	position.y = clamp(position.y, sprite_size.y, screen_size.y - sprite_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_area_entered(_area):
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
