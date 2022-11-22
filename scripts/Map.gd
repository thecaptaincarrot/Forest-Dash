extends TileMap

var delete_cell = Vector2(-1,0)
var draw_cell = Vector2(82,0)
#Enemies
export (PackedScene) var Mushroom
export (PackedScene) var Goblin
export (PackedScene) var Fly
#Traps
export (PackedScene) var Spikes
export (PackedScene) var Swing
export (PackedScene) var Platform
#Collectibles
export (PackedScene) var Coin
export (PackedScene) var Health
export (PackedScene) var Chest

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offscreen_cell_delete()


func offscreen_cell_delete():
	var delete_cell_position =  map_to_world(delete_cell)
	
	if  get_parent().get_node("Mover").position.x - 32 >= delete_cell_position.x * 32:
		for i in range(0,1 + screen_size.y / 16):
			set_cell(delete_cell.x, i, -1)
		delete_cell.x += 1
	

func pick_a_room():
	randomize()
	var rooms
	if get_parent().level == 1:
		rooms = get_parent().lvl1_rooms
	elif get_parent().level == 2:
		rooms = get_parent().lvl2_rooms
	elif get_parent().level == 3:
		rooms = get_parent().lvl3_rooms
	
	var rooms_length = len(rooms)
	var card_draw = randi()  % rooms_length
	
	var chosen_room = rooms[card_draw]
	
	var room_size = 0
	
	var offset = map_to_world(draw_cell)
	for element in chosen_room:
		if element["type"] == "Tile":
			var x = element["x"]
			var y = element ["y"]
			var index = element ["index"]
			
			set_cell(x + draw_cell.x, y + draw_cell.y, index)
		elif element["type"] == "RoomDefinition":
			room_size = element["size"]
		elif element["type"] == "Trap":
			var to_add
			match element["name"]:
				"swing":
					to_add = Swing.instance()
				"spikes":
					to_add = Spikes.instance()
				"platform":
					to_add = Platform.instance()
			to_add.position = Vector2(element["x"],element["y"]) + offset
			to_add.rotation = element["rotation"]
			$Traps.add_child(to_add)
		elif element["type"] == "Enemy":
			var to_add
			match element["name"]:
				"Mushroom":
					to_add = Mushroom.instance()
				"Goblin":
					to_add = Goblin.instance()
				"Fly":
					to_add = Fly.instance()
			to_add.position = Vector2(element["x"],element["y"]) + offset
			to_add.state = element["state"]
			$Enemies.add_child(to_add)
		elif element["type"] == "item":
			var to_add
			match element["name"]:
				"coin":
					to_add = Coin.instance()
				"health":
					to_add = Health.instance()
				"Chest":
					to_add = Chest.instance()
			to_add.position = Vector2(element["x"],element["y"]) + offset
			$Collectibles.add_child(to_add)
			
	draw_cell.x += room_size
#	print(draw_cell)


func draw_respawn_room():
	set_cell(draw_cell.x, 0, 23)
	set_cell(draw_cell.x, 18, 1)
	draw_cell.x += 1
