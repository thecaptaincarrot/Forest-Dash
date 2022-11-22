extends "res://scripts/Game.gd"

var rooms_built = 0

var to_transition = false


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
	
	$Map.build_room(Global.special_rooms["TempleStart.json"], offset)
	level = 3
	
	Global.highest_level = 3
	if Persistant.checkpoint < 3:
		Persistant.checkpoint = 3
		Persistant.save_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func Level_3_Room_counter(_junk1, _junk2, special, room_name):
	if $LevelEndTimer.is_stopped() and state != LEVEL_UP:
		if !special:
			rooms_built += 1
		if direction == "right":
			if rooms_built >= 10:
				rooms_built = 0
				
				var T = Timer.new()
				T.wait_time = 1.0
				add_child(T)
				T.start()
				yield(T,"timeout")
				T.queue_free()
				
				levelup_cell = offset
				
				levelup_pixel = cell_to_pixel(levelup_cell)
				$Map.build_room(Global.special_rooms["TempleEnd.json"], offset)
				state = LEVEL_UP
				 
		elif direction == "left":
			if rooms_built >= 5:
				
				var T = Timer.new()
				T.wait_time = 1.0
				add_child(T)
				T.start()
				yield(T,"timeout")
				T.queue_free()
				
				rooms_built = 0
				change_direction("up")
		elif direction == "down" or direction == "up":
			if rooms_built >= 5:
				
				var T = Timer.new()
				T.wait_time = 1.0
				add_child(T)
				T.start()
				yield(T,"timeout")
				T.queue_free()
				
				rooms_built = 0
				change_direction("right")
	elif $LevelEndTimer.time_left <= 15:
		rooms_built = 0
	else:
		if !special:
			rooms_built += 1
		#print("rooms built: ", rooms_built)
		if rooms_built > 8:
			to_transition = true
			var coin = randi() % 2
			if coin == 0:
				rooms_built = 0
				coin = randi() % 2
				
				var T = Timer.new()
				T.wait_time = 1.0
				add_child(T)
				T.start()
				yield(T,"timeout")
				T.queue_free()
				
				if direction == "right" or direction == "left":
					match coin:
						0:
							change_direction("down")
						1:
							change_direction("up")
				elif direction == "up" or direction == "down":
					match coin:
						0:
							change_direction("right")
						1:
							change_direction("left")
			else:
				pass
