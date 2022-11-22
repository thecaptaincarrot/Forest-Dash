extends "res://scripts/Game.gd"

var rooms_built = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	lives = Global.saved_lives
	score = Global.saved_score
	
	state = NORMAL
	#change_speed(0)
	
	screen_size = get_viewport_rect().size
	
	#Read in previous level's data here from global
	
	$CanvasLayer/HUD.update_lives(lives)
	$CanvasLayer/HUD.update_health($PlayerBody.health)
	
	$CanvasLayer/HUD.update_score(score)
	$CanvasLayer/HUD.update_coins(coins)
	
	$Map.build_room(Global.special_rooms["CaveStart.json"], offset)
	level = 2
	Global.highest_level = 2
	if Persistant.checkpoint < 2:
		Persistant.checkpoint = 2
		Persistant.save_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func Level_2_Room_counter(_junk1, _junk2, special, _room_name):
	var T = Timer.new()
	T.wait_time = .8
	add_child(T)
	T.start()
	yield(T,"timeout")
	T.queue_free()
	
	if $LevelEndTimer.is_stopped() and state != LEVEL_UP and state != DIRECTION_TRANSITION :
		if !special:
			rooms_built += 1
		if direction == "up":
			if rooms_built >= 10:
				rooms_built = 0
				levelup_cell = offset
				
				levelup_pixel = cell_to_pixel(levelup_cell)
				change_direction("right")
				state = LEVEL_UP
				 
		elif direction == "right" or direction == "left":
			if rooms_built >= 5:
				rooms_built = 0
				
				change_direction("up")
		elif direction == "down":
			if rooms_built >= 5:
				
				change_direction("right")
	elif $LevelEndTimer.time_left <= 15:
		print("Level ending, no more transitions")
		rooms_built = 0
	else:
		if !special:
			rooms_built += 1
		print("rooms built: ", rooms_built)
		if rooms_built > 15:
			var coin = randi() % 2
			if coin == 0:
				rooms_built = 0
				coin = randi() % 2
				
				if direction == "right" or direction == "left":
					match coin:
						0:
							change_direction("up")
						1:
							change_direction("down")
				elif direction == "up" or direction == "down":
					match coin:
						0:
							change_direction("right")
						1:
							change_direction("left")
			else:
				pass

#
#func _on_LevelEndTimer_timeout():
#	if direction == "up":
#		print("Already going up")
#	elif direction == "right" or direction == "left":
#		change_direction("up")
#		print("Level ended, going up")
#	elif direction == "down":
#		change_direction("right")
