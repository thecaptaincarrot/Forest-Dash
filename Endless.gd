extends "res://scripts/Game.gd"

var current_room_count = 0
var total_room_count = 0

var next_transition = 0

export var min_rooms = 7
export var max_rooms = 12

export var biome_change_rooms = 50
var biome_changes = 1

export var speedup_rooms = 200
var speedup_changes = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	state = NORMAL
	change_speed(0)
	
	screen_size = get_viewport_rect().size
	
	$CanvasLayer/HUD.update_lives(lives)
	$CanvasLayer/HUD.update_health($PlayerBody.health)
	
	$CanvasLayer/HUD.update_score(score)
	$CanvasLayer/HUD.update_coins(coins)
	
	$Map.build_room(Global.special_rooms["ForestStart.json"], offset)
	
	next_transition = (randi() % (max_rooms - min_rooms)) + min_rooms
	print("next transition at ",next_transition, " rooms built")
	
	mode = "endless"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func endless_room_count(room_size, direction, special, room_name):
	if special:
		return
	
	var T = Timer.new()
	T.wait_time = 1.0
	add_child(T)
	T.start()
	yield(T,"timeout")
	T.queue_free()
	
	current_room_count += 1
	total_room_count += 1
	
	if current_room_count > next_transition:
		print("transition Activate")
		current_room_count = 0
		next_transition = (randi() % (max_rooms - min_rooms)) + min_rooms
		print("next transition at ",next_transition, " rooms built")
		
		var coin = randi() % 2
		
		if coin == 0:
			#biome change
			
			biome_changes += 1
			
			var possibles = [1,2,3]
			possibles.erase(level)
			possibles.shuffle()
			change_biomes(possibles.front())
		else:
			direction_shift()


func direction_shift():
	print("changing direction")
	var coin = randi()%2
	
	
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


func change_biomes(new_level):
	state = HOLD
	var biome = ""
	var new_biome = ""
	#new_level is 1 or 2
	match level:
		1:
			biome = "Forest"
		2:
			biome = "Cave"
		3:
			biome = "Temple"
	
	match new_level:
		1:
			new_biome = "Forest"
		2:
			new_biome = "Cave"
		3:
			new_biome = "Temple"
	
	var direction_fix = "Right"
	match direction:
		"right":
			direction_fix = "Right"
		"left":
			direction_fix = "Left"
		"up":
			direction_fix = "Up"
		"down":
			direction_fix = "Down"
	
	var room_lookup = biome + new_biome + direction_fix+".json"
	
	transition_cell = offset
	if direction == "left":
		transition_cell.x -= 32
	if direction == "down":
		transition_cell.y += 18
	if direction == "up":
		transition_cell.y -= 18
	transition_pixel = cell_to_pixel(transition_cell)
	
	$Map.build_room(Global.special_rooms[room_lookup], offset)
	
	state = BIOME_TRANSITION
	level = new_level
