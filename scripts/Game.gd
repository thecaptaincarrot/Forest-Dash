extends Node2D

var cheat_progress = 0

signal update_speed
signal cheat

var debug_index = 0

var delete_cell = Vector2(-1,0)
var offset = Vector2(0,0)

var can_pause = true
var initiate = true

var player_position
var player_respawn = false
var respawn_room_draw = false

var respawn_cell : Vector2
var respawn_pixel : Vector2

var screen_size

var scroll_speed = 0

export var h_target_speed = 200
export var v_target_speed = 100

var levelup_pixel = Vector2(0,0)
var levelup_cell = Vector2(0,0)
enum {NORMAL, DIRECTION_TRANSITION, LEVEL_UP, BIOME_TRANSITION,HOLD}
var state
var delayed_state = null
var previous_roll = 0

var direction = "right"
var new_direction = "right"
var respawn_direction = "right"
var directions = ["right","left","up","down"]
signal direction_change
var transition_pixel = Vector2(0,0)
var transition_cell = Vector2(0,0)

var mode = "story"

var spacer_room

var debug = 0
var level = 1

var time = 0

#Special rooms
var forest_start_data
var cave_start

var lives = 2

var coins = 0
var score = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	if Global.cheated:
		emit_signal("cheat")


func _physics_process(delta):
	if lives >= 0:
		score += int(delta * 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	can_pause = true
	if initiate:
		if scroll_speed < h_target_speed:
			change_speed(scroll_speed + 1)
		else:
			initiate = false
	
	$CanvasLayer/HUD.update_score(score)
	#position of Mover
	var upper_left = $Mover.position
#	else:
	
	#delete cells
	match direction:
		"right":
			var top_left = $Mover.position
			top_left.x -= 32 #Just Off screen
			delete_cell = pixel_to_cell(top_left)
			$Map.clear_column(delete_cell, "right")
		"left":
			var top_right = $Mover.position
			top_right.x += screen_size.x + 32 #Just Off screen
			delete_cell = pixel_to_cell(top_right)
			$Map.clear_column(delete_cell, "left")
		"up":
			var bottom_left = $Mover.position
			bottom_left.y += screen_size.y + 32 #Just Off screen
			delete_cell = pixel_to_cell(bottom_left)
			$Map.clear_row(delete_cell, "up")
		"down":
			var top_left = $Mover.position
			top_left.y -= 32 #Just Off screen
			delete_cell = pixel_to_cell(top_left)
			$Map.clear_row(delete_cell, "down")
	
	if player_respawn and !respawn_room_draw:
		respawn_pixel = cell_to_pixel(respawn_cell)
		match respawn_direction:
			"up":
				if $Mover.position.y <= respawn_pixel.y: #At some point, match direction.
					respawn_player()
					change_speed(v_target_speed)
			"down":
				if $Mover.position.y >= respawn_pixel.y: #At some point, match direction.
					respawn_player()
					change_speed(v_target_speed)
			"right":
				if $Mover.position.x >= respawn_pixel.x: #At some point, match direction.
					respawn_player()
			"left":
				if $Mover.position.x <= respawn_pixel.x: #At some point, match direction.
					respawn_player()
	
	match state:
		HOLD:
			pass
		NORMAL:
			#choose difficulty
			time += delta
			
			#RESPAWN
			if respawn_room_draw:
				respawn_room_draw = false
				respawn_cell = offset
				
				match level:
					1:
						match direction:
							"up":
								$Map.build_room(Global.special_rooms["ForestRespawnUp.json"], offset)
								respawn_cell.y -= 20
							"down":
								$Map.build_room(Global.special_rooms["ForestRespawnDown.json"], offset)
								respawn_cell.y += 20
							"right":
								$Map.build_room(Global.special_rooms["ForestRespawnRight.json"], offset)
							"left":
								$Map.build_room(Global.special_rooms["ForestRespawnLeft.json"], offset)
								respawn_cell.x -=20
					2:
						match direction:
							"up":
								$Map.build_room(Global.special_rooms["CaveRespawnUp.json"], offset)
								respawn_cell.y -= 20
							"down":
								$Map.build_room(Global.special_rooms["CaveRespawnDown.json"], offset)
								respawn_cell.y += 20
							"right":
								$Map.build_room(Global.special_rooms["CaveRespawnRight.json"], offset)
							"left":
								$Map.build_room(Global.special_rooms["CaveRespawnLeft.json"], offset)
								respawn_cell.x -=20
					3:
						match direction:
							"up":
								$Map.build_room(Global.special_rooms["TempleRespawnUp.json"], offset)
								respawn_cell.y -= 20
							"down":
								$Map.build_room(Global.special_rooms["TempleRespawnDown.json"], offset)
								respawn_cell.y += 20
							"right":
								$Map.build_room(Global.special_rooms["TempleRespawnRight.json"], offset)
							"left":
								$Map.build_room(Global.special_rooms["TempleRespawnLeft.json"], offset)
								respawn_cell.x -=20
				
				respawn_pixel = cell_to_pixel(respawn_cell)
					
			match direction:
				"right":
					if $Mover.position.x + screen_size.x  >= offset.x * 32:
						var difficulty = choose_difficulty(time)
						pick_and_build_room(direction,difficulty)
				"left":
					if $Mover.position.x  <= offset.x * 32:
						pick_and_build_room(direction,"Easy")
				"up":
					if $Mover.position.y  <= offset.y * 32:
						pick_and_build_room(direction,"Easy")
				"down":
					if $Mover.position.y + screen_size.y  >= offset.y * 32:
						pick_and_build_room(direction,"Easy")
		DIRECTION_TRANSITION:
			var done = false
			match direction:
				"right":
					if $Mover.position.x >= transition_pixel.x:
						emit_signal("direction_change", new_direction)
						$Mover.position.x = transition_pixel.x
						done = true
				"left":
					if $Mover.position.x <= transition_pixel.x:
						emit_signal("direction_change", new_direction)
						$Mover.position.x = transition_pixel.x
						done = true
				"up":
					if $Mover.position.y <= transition_pixel.y:
						emit_signal("direction_change", new_direction)
						$Mover.position.y = transition_pixel.y
						done = true
				"down":
					if $Mover.position.y >= transition_pixel.y:
						
						emit_signal("direction_change", new_direction)
						$Mover.position.y = transition_pixel.y
						done = true
			if done:
				offset = transition_cell
				
				#speed change
				if !player_respawn and (new_direction == "up" or new_direction == "down"):
					change_speed(v_target_speed)
				elif !player_respawn and (new_direction == "right" or new_direction == "left") :
					change_speed(h_target_speed)
				
				if direction == "up" and new_direction == "right":
					offset.x += 32
				
				if direction == "down" and new_direction == "right":
					offset.x += 32
				
				direction = new_direction
				state = NORMAL
		BIOME_TRANSITION:
			var done = false
			match direction:
				"right":
					if $Mover.position.x + screen_size.x  >= offset.x * 32:
						var difficulty = choose_difficulty(time)
						pick_and_build_room(direction,difficulty)
				"left":
					if $Mover.position.x  <= offset.x * 32:
						pick_and_build_room(direction,"Easy")
				"up":
					if $Mover.position.y  <= offset.y * 32:
						pick_and_build_room(direction,"Easy")
				"down":
					if $Mover.position.y + screen_size.y  >= offset.y * 32:
						pick_and_build_room(direction,"Easy")
			
			match direction:
				"right":
					if $Mover.position.x >= transition_pixel.x:
						$Mover.position.x = transition_pixel.x
						done = true
				"left":
					if $Mover.position.x <= transition_pixel.x:
						$Mover.position.x = transition_pixel.x
						done = true
				"up":
					if $Mover.position.y <= transition_pixel.y:
						$Mover.position.y = transition_pixel.y
						done = true
				"down":
					if $Mover.position.y >= transition_pixel.y:
						$Mover.position.y = transition_pixel.y
						done = true
			if done:
				$Mover/MainCamera/ParallaxBackground.change_biome(level)
				state = NORMAL
				
		LEVEL_UP:
			if $PlayerBody.position.x >= levelup_pixel.x and level == 1:
				$CanvasLayer/FadeOut.play("FadeToBlack")
			elif $PlayerBody.position.y <= levelup_pixel.y and level == 2:
				$CanvasLayer/FadeOut.play("FadeToBlack")
			elif $PlayerBody.position.x >= levelup_pixel.x and level == 3:
				$CanvasLayer/FadeOut.play("FadeToBlack")


func _input(event):
	if lives < 0:
		return
	cheat(event)
	if Input.is_action_just_pressed("ui_pause") and can_pause:
		can_pause = false
		get_tree().paused = true
		$CanvasLayer/InGameMenu.activate()


func pick_and_build_room(build_direction:String, difficulty:String):
	#new room picking logic
	#Rooms are loaded according to their level array with no concern for direction or difficulty
	#The originally loaded room array is then pruned to find only rooms that correspond to the criteria
	#The remaining room array is shuffled and a random index is picked.
	var room_to_build
	var room_array = []
	var to_build_array = []
	match level:
		1:
			room_array = Global.lvl1_rooms
		2:
			room_array = Global.lvl2_rooms
		3:
			room_array = Global.lvl3_rooms
		4:
			room_array = Global.lvl4_rooms
	
	for room in room_array:
		var room_difficulty 
		var room_direction
		for element in room:
			if element["type"] == "RoomDefinition":
				room_direction = element["direction"]
				room_difficulty = element["difficulty"]
				break
			else:
				pass
		
		if room_direction == build_direction:
			to_build_array.append(room)
		
	var dice_roll = randi() % len(to_build_array)
	while dice_roll == previous_roll:
		dice_roll = randi() % len(to_build_array)
	
	previous_roll = dice_roll
	$Map.build_room(to_build_array[dice_roll],offset)


func choose_difficulty(time):
	#time must be split down into the seconds
	var seconds = round(time)
	
	#chances are an int from 0 to 100 that represent the % chance of a certain difficulty
	#being chosen
	var easy_chance = 0
	var med_chance = 0
	var hard_chance = 0
	
	if seconds < 30:
		easy_chance = 100
	elif seconds < 60:
		easy_chance = -2 * seconds + 160
		med_chance = 2 * seconds - 60
	elif seconds < 90:
		easy_chance = 40
		med_chance = 60
	elif seconds < 150:
		easy_chance = -(2.0/3.0) * seconds + 100 
		med_chance = -(1.0/3.0) * seconds + 90
		hard_chance = time - 90
	elif seconds < 180:
		med_chance = (-2/3) * seconds + 140
		hard_chance = (2/3) * seconds - 40
	else:
		med_chance = 20
		hard_chance = 80
	
	var dice_roll = randi() % 100
	
	if dice_roll <= easy_chance:
		return "Easy"
	elif dice_roll <= med_chance + easy_chance:
		return "Medium"
	else:
		return "Hard"


func update_score():
	$CanvasLayer/HUD.update_score(score)


func _on_PlayerBody_hurt():
	$CanvasLayer/HUD.update_health($PlayerBody.health)


func _on_PlayerBody_dead():
	lives -= 1
	
	$CanvasLayer/HUD.update_lives(lives)
	
	score -= 1000
	if score <= 0:
		score = 0
	$CanvasLayer/HUD.update_score(score)
	
	if lives < 0 :
		Global.final_score = score
		$CanvasLayer/FadeOut.play("FadeToBlack")
	else:
		player_respawn = true
		if state == LEVEL_UP:
			$CanvasLayer/FadeOut.play("FadeToBlack")
			return
		
		respawn_room_draw = true
		
		if direction == new_direction:
			respawn_direction = direction
		else:
			respawn_direction = new_direction
		
		print("respawn direction: ", respawn_direction)
		print("respawn cell: ", respawn_cell)
		respawn_cell = offset
		respawn_pixel = cell_to_pixel(respawn_cell)
		change_speed(600)
		var new_dir = ""

func _on_PlayerBody_CoinCollect():
	coins += 1
	if coins >= 100:
		coins = 0
		lives += 1
		$CanvasLayer/HUD.update_lives(lives)
	score += 100
	$CanvasLayer/HUD.update_coins(coins)
	$CanvasLayer/HUD.update_score(score)


func _on_PlayerBody_Heal():
	score += 100
	$CanvasLayer/HUD.update_health($PlayerBody.health)
	$CanvasLayer/HUD.update_score(score)


func respawn_player():
	match direction:
		"up":
			$PlayerBody.position.x = $Mover.position.x + screen_size.x / 2
			$PlayerBody.position.y = $Mover.position.y + screen_size.y / 2 - 128
			change_speed(v_target_speed)
		"down":
			$PlayerBody.position.x = $Mover.position.x + screen_size.x / 2
			$PlayerBody.position.y = $Mover.position.y + screen_size.y / 2 - 128
			change_speed(v_target_speed)
		"right":
			$PlayerBody.position.x = $Mover.position.x + 20 * 32 / 2
			$PlayerBody.position.y = $Mover.position.y + screen_size.y / 2
			change_speed(h_target_speed)
		"left":
			$PlayerBody.position.x = $Mover.position.x + 20 * 32 / 2
			$PlayerBody.position.y = $Mover.position.y + screen_size.y / 2
			change_speed(h_target_speed)
	$PlayerBody.health = 3
	$PlayerBody.state = $PlayerBody.FINE
	$PlayerBody.motion = Vector2(0,0)
	$CanvasLayer/HUD.update_health($PlayerBody.health)
	
	emit_signal("direction_change", direction)
	
	player_respawn = false


func change_direction(prospective_direction):
	#redo
	if state == DIRECTION_TRANSITION:
		return
	
	new_direction = prospective_direction
	var biome = "forest"
	var transition_index = 0
	match direction:
		"right":
			match new_direction:
				"up":
					transition_index = 1
				"down":
					transition_index = 0
		"left":
			match new_direction:
				"up":
					transition_index = 2
				"down":
					transition_index = 3
		"up":
			match new_direction:
				"right":
					transition_index = 7
				"left":
					transition_index = 4
		"down":
			match new_direction:
				"right":
					transition_index = 6
				"left":
					transition_index = 5
	
	match level:
		1:
			biome = "Forest"
		2:
			biome = "Cave"
		3:
			biome = "Temple"
		4:
			biome = "Tree"
	
	var room_name = biome + "Transition" + str(transition_index) + ".json"
	var transition_room = Global.special_rooms[room_name]
	transition_cell = offset
	
	$Map.build_room(Global.special_rooms[room_name],offset)
	
	if direction == "left":
		transition_cell.x -= 32
	if direction == "down":
		transition_cell.y += 19
	if direction == "up":
		transition_cell.y -= 19
	
	transition_pixel = cell_to_pixel(transition_cell)
	
	state = DIRECTION_TRANSITION


func go_to_caves():
	if level == 1:
		state = LEVEL_UP
		levelup_cell = offset
		
		levelup_cell.x += 2
		
		levelup_pixel = cell_to_pixel(levelup_cell)
		
		$Map.build_room(Global.special_rooms["CaveEntrance.json"], offset)


func cell_to_pixel(cell):
	var first_grid = $Map/Forest/Foreground1
	
	return first_grid.map_to_world(cell)


func pixel_to_cell(pixel):
	var first_grid = $Map/Forest/Foreground1
	
	return first_grid.world_to_map(pixel)


func change_speed(new_speed):
	scroll_speed = new_speed
	emit_signal("update_speed",new_speed)


func _on_StartTimer_timeout():
	$CanvasLayer/LevelAnimation.play("Level1")


func _on_FadeOut_animation_finished(anim_name):
	if anim_name == "FadeToBlack":
		if lives < 0:
			if mode == "endless":
				print("endless")
				get_tree().change_scene("res://HUD/EndlessGameOver.tscn")
			else:
				get_tree().change_scene("res://HUD/GameOverScreen.tscn")
		elif state == LEVEL_UP:
			Global.offload(score,lives)
			match level:
				1:
					get_tree().change_scene("res://cutscenes/CaveStartCutscene.tscn")
				2:
					get_tree().change_scene("res://cutscenes/TempleStartCutscene.tscn")
				3:
					get_tree().change_scene("res://cutscenes/EndCutscene.tscn")
	else:
		get_tree().change_scene("res://HUD/YouWinScreen.tscn")


func _on_PlayerBody_ChestCollect():
	coins += 10
	if coins >= 100:
		coins -= 100
		lives += 1
		$CanvasLayer/HUD.update_lives(lives)
	score += 1000
	$CanvasLayer/HUD.update_coins(coins)
	$CanvasLayer/HUD.update_score(score)


func _on_Map_room_constructed(room_size, direction, special, room_name):
	print("Built room '", room_name, "' at offset: ", offset)
	match direction:
		"right":
			offset.x += room_size
		"left":
			offset.x -= room_size
		"up":
			offset.y -= room_size
		"down":
			offset.y += room_size


func _on_InGameMenu_exit_menu():
	get_tree().paused = false


func _on_QuitPanel_quit_game():
	get_tree().change_scene("res://MainMenu.tscn")


func score_up(monster_score):
	score += monster_score
	update_score()


func cheat(event):
	if event.is_pressed() and !Global.cheated:
		match cheat_progress:
			0:
				if Input.is_action_pressed("ui_up"):
					cheat_progress += 1
				else:
					cheat_progress = 0
			1:
				if Input.is_action_pressed("ui_up"):
					cheat_progress += 1
				else:
					cheat_progress = 0
			2:
				if Input.is_action_pressed("ui_down"):
					cheat_progress += 1
				else:
					cheat_progress = 0
			3:
				if Input.is_action_pressed("ui_down"):
					cheat_progress += 1
				else:
					cheat_progress = 0
			4:
				if Input.is_action_pressed("ui_left"):
					cheat_progress += 1
				else:
					cheat_progress = 0
			5:
				if Input.is_action_pressed("ui_right"):
					cheat_progress += 1
				else:
					cheat_progress = 0
			6:
				if Input.is_action_pressed("ui_left"):
					cheat_progress += 1
				else:
					cheat_progress = 0
			7:
				if Input.is_action_pressed("ui_right"):
					cheat_progress += 1
				else:
					cheat_progress = 0
			8:
				if Input.is_action_pressed("ui_attack"):
					cheat_progress += 1
				else:
					cheat_progress = 0
			9:
				if Input.is_action_pressed("ui_jump"):
					cheat_progress = 0
					emit_signal("cheat")
					Global.cheated = true
					match level:
						1:
							if direction == "right":
								$Map.build_room(Global.special_rooms["READDUNE.json"], offset)
							elif direction == "left":
								$Map.build_room(Global.special_rooms["READDUNE2.json"], offset)
							if direction == "up":
								$Map.build_room(Global.special_rooms["No Bugs.json"], offset)
							if direction == "down":
								$Map.build_room(Global.special_rooms["No Bugs2.json"], offset)
						2:
							if direction == "right":
								$Map.build_room(Global.special_rooms["KikiAndRiddle.json"], offset)
							if direction == "left":
								$Map.build_room(Global.special_rooms["KikiAndRiddle2.json"], offset)
							if direction == "up":
								$Map.build_room(Global.special_rooms["TrueSTL2.json"], offset)
							if direction == "down":
								$Map.build_room(Global.special_rooms["TrueSTL.json"], offset)
						3:
							if direction == "right":
								$Map.build_room(Global.special_rooms["Too Hard.json"], offset)
							if direction == "left":
								$Map.build_room(Global.special_rooms["Too Hard2.json"], offset)
							if direction == "up":
								$Map.build_room(Global.special_rooms["SOT.json"], offset)
							if direction == "down":
								$Map.build_room(Global.special_rooms["SOT2.json"], offset)
				else:
					cheat_progress = 0
