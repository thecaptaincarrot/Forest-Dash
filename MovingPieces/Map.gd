extends Node2D

export (PackedScene) var Spikes = preload("res://Tiles/Spikes.tscn")
var HiddenSpikes = preload("res://Tiles/Hidden Spikes.tscn")
export (PackedScene) var SwingTrap = preload("res://Tiles/SwingyDingy.tscn")
export (PackedScene) var Platform = preload("res://Tiles/Platform3.tscn")

export (PackedScene) var Mushroom = preload("res://Enemies/Mushroom.tscn")
export (PackedScene) var BlueMushroom = preload("res://Enemies/BlueMushroom.tscn")
export (PackedScene) var Slime = preload("res://Enemies/Slime.tscn")
export (PackedScene) var Goblin = preload("res://Enemies/Goblin.tscn")
export (PackedScene) var GoblinThrower = preload("res://Enemies/ThrowingGoblin.tscn")
export (PackedScene) var SporeShroom = preload("res://Enemies/SporeMushroom.tscn")

export (PackedScene) var Fly = preload("res://Enemies/Fly.tscn")

export (PackedScene) var Coin = preload("res://collectibles/Coin.tscn")
export (PackedScene) var Chest = preload("res://collectibles/Chests.tscn")
export (PackedScene) var Potion = preload("res://collectibles/HealthPotion.tscn")

var Platform1 =  preload("res://Tiles/Platform1.tscn")
var Platform2 =  preload("res://Tiles/Platform2.tscn")
var Platform3 =  preload("res://Tiles/Platform3.tscn")
var Platform4 =  preload("res://Tiles/Platform4.tscn")
var Platform5 =  preload("res://Tiles/Platform5.tscn")

var room_number = 0
#emit signal when room has cleared
var room_end_to_number = []

signal room_constructed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#move in direction at speed
	pass


func move(distance, direction):
	#speed needs to be a function of delta
	#direction is vector 2
	position = distance * direction


func build_room(room_def, offset):
	#Called at game level
	#offset is the upper left point
	var working_offset = offset
	
	var room_size = 0
	var biome = 1
	var direction
	var identity
	var special = false
	
	var room_name
	
	for element in room_def:
		match element["type"]:
			"RoomDefinition":
				room_size = element["size"]
				biome = int(element["biome"])
				direction = element["direction"]
				identity = element["name"]
				room_name = element["name"]
				if direction == "up":
					working_offset.y -= room_size
				elif direction == "left":
					working_offset.x -= room_size
				elif direction == "down":
					working_offset.y += 19
				
				special = element["special"]
		#tiles
			"Tile":
				var x = element["x"]
				var y = element["y"]
				var index = int(element["index"])
				var layer = int(element["layer"])
				match biome:
					1:
						$Forest.set_tile(layer, x, y, index, working_offset)
					2:
						$Cave.set_tile(layer, x, y, index, working_offset)
					3:
						$Temple.set_tile(layer, x, y, index, working_offset)
		#Item
			"Item":
				var new_item
				match element["name"]:
					"Coin":
						new_item = Coin.instance()
					"Chest":
						new_item = Chest.instance()
					"Potion":
						new_item = Potion.instance()
				var pos = Vector2(element["x"], element["y"]) + working_offset * 32
				new_item.position = pos
				
				$Items.add_child(new_item)
		#enemies
			"Enemy":
				var new_enemy
				match element["name"]:
					"Mushroom":
						new_enemy = Mushroom.instance()
					"Blue Mushroom":
						new_enemy = BlueMushroom.instance()
					"Slime":
						new_enemy = Slime.instance()
					"Goblin":
						new_enemy = Goblin.instance()
					"Goblin Thrower":
						new_enemy = GoblinThrower.instance()
					"Spore Shroom":
						new_enemy = SporeShroom.instance()
				new_enemy.position = Vector2(element["x"], element["y"]) + working_offset * 32
				new_enemy.behaviour = element["behaviour"]
				new_enemy.connect("score_up",get_parent(),"score_up")
				$Enemies.add_child(new_enemy)
		#Traps
			"Trap":
				var new_trap
				match element["name"]:
					"Spikes":
						new_trap = Spikes.instance()
					"HiddenSpikes":
						new_trap = HiddenSpikes.instance()
					"SwingTrap":
						new_trap = SwingTrap.instance()
					"Platform1":
						new_trap = Platform1.instance()
					"Platform2":
						new_trap = Platform2.instance()
					"Platform3":
						new_trap = Platform3.instance()
					"Platform4":
						new_trap = Platform4.instance()
					"Platform5":
						new_trap = Platform5.instance()
				new_trap.position = Vector2(element["x"], element["y"]) + working_offset * 32
				new_trap.rotation = element["rotation"]
				$Traps.call_deferred("add_child", new_trap)
	
	
	emit_signal("room_constructed", room_size, direction, special, room_name)


func clear_column(clear_cell,direction):
	var x = clear_cell.x
	var y = clear_cell.y
	
	#go from -1 to 19 for y
	#go from -1 to 33 for x
	
	for i in range(y - 2, y + 20):
		for N in [$Forest,$Cave,$Tree,$Temple]: #?
			if N.get_node("Foreground1").get_cell(x,i) != -1:
				N.get_node("Foreground1").set_cell(x,i,-1)
			if N.get_node("Foreground2").get_cell(x,i) != -1:
				N.get_node("Foreground2").set_cell(x,i,-1)
			if N.get_node("Background1").get_cell(x,i) != -1:
				N.get_node("Background1").set_cell(x,i,-1)
			if N.get_node("Background2").get_cell(x,i) != -1:
				N.get_node("Background2").set_cell(x,i,-1)
		
	for N in $Items.get_children():
		match direction:
			"left":
				if N.position.x >=  $Forest/Foreground1.map_to_world(clear_cell).x:
					N.queue_free()
			"right":
				if N.position.x <=  $Forest/Foreground1.map_to_world(clear_cell).x:
					N.queue_free()
			"up":
				if N.position.y >= $Forest/Foreground1.map_to_world(clear_cell).y:
					N.queue_free()
			"down":
				if N.position.y <= $Forest/Foreground1.map_to_world(clear_cell).y:
					N.queue_free()


	for N in $Enemies.get_children():
		match direction:
			"left":
				if N.position.x >=  $Forest/Foreground1.map_to_world(clear_cell).x:
					N.queue_free()
			"right":
				if N.position.x <=  $Forest/Foreground1.map_to_world(clear_cell).x:
					N.queue_free()
			"up":
				if N.position.y >= $Forest/Foreground1.map_to_world(clear_cell).y:
					N.queue_free()
			"down":
				if N.position.y <= $Forest/Foreground1.map_to_world(clear_cell).y:
					N.queue_free()
					
	for N in $Traps.get_children():
		match direction:
			"left":
				if N.position.x >=  $Forest/Foreground1.map_to_world(clear_cell).x:
					N.queue_free()
			"right":
				if N.position.x <=  $Forest/Foreground1.map_to_world(clear_cell).x:
					N.queue_free()
			"up":
				if N.position.y >= $Forest/Foreground1.map_to_world(clear_cell).y:
					N.queue_free()
			"down":
				if N.position.y <= $Forest/Foreground1.map_to_world(clear_cell).y:
					N.queue_free()


func clear_row(clear_cell,direction):
	var x = clear_cell.x
	var y = clear_cell.y
	#go from -1 to 19 for y
	#go from -1 to 33 for x
	
	for i in range(x - 2, x + 34):
		for N in [$Forest,$Cave,$Tree,$Temple]: #?
			if N.get_node("Foreground1").get_cell(i,y) != -1:
				N.get_node("Foreground1").set_cell(i,y,-1)
			if N.get_node("Foreground2").get_cell(i,y) != -1:
				N.get_node("Foreground2").set_cell(i,y,-1)
			if N.get_node("Background1").get_cell(i,y) != -1:
				N.get_node("Background1").set_cell(i,y,-1)
			if N.get_node("Background1").get_cell(i,y) != -1:
				N.get_node("Background2").set_cell(i,y,-1)
	
	for N in $Items.get_children():
		match direction:
			"up":
				if N.position.y >=  $Forest/Foreground1.map_to_world(clear_cell).y:
					N.queue_free()
			"down":
				if N.position.y <=  $Forest/Foreground1.map_to_world(clear_cell).y:
					N.queue_free()
	
	for N in $Enemies.get_children():
		match direction:
			"up":
				if N.position.y >=  $Forest/Foreground1.map_to_world(clear_cell).y:
					N.queue_free()
			"down":
				if N.position.y <=  $Forest/Foreground1.map_to_world(clear_cell).y:
					N.queue_free()
	
	for N in $Traps.get_children():
		match direction:
			"up":
				if N.position.y >=  $Forest/Foreground1.map_to_world(clear_cell).y:
					N.queue_free()
			"down":
				if N.position.y <=  $Forest/Foreground1.map_to_world(clear_cell).y:
					N.queue_free()


func map_to_world(cell):
	return $Cave/Foreground1.map_to_world(cell)
