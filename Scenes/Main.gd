extends Node
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var Mob
var score
var perimeter


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_hit():
	game_over()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	score += 1
	
	$HUD.update_score(score)


func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.set_offset(randi())
	print("----")
	print($MobPath/MobSpawnLocation.get_offset())
	print($MobPath/MobSpawnLocation.get_position_in_parent())
	print($MobPath/MobSpawnLocation.get_position())
	
	var mob = Mob.instance()
	add_child(mob)
	
	# mob.set_movement($MobPath/MobSpawnLocation)
	var variation = rand_range(-PI / 4, PI / 4)
	mob.rotation = ($MobPath/MobSpawnLocation.rotation + PI / 2) + variation
	
	mob.position = $MobPath/MobSpawnLocation.position
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(mob.rotation)


func _on_HUD_start_game():
	new_game()
	
	
