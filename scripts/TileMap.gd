extends TileMap


var delete_cell = Vector2(-1,0)
var add_cell = Vector2(1,0)
var player_position

var screen_size

var i = 0

var draw_cell = Vector2(44,0)

var rooms = [] #don't need a dictionary if we're not choosing them by name
#Possible_Levels is an array of an array of dictionaries.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	read_room_jsons()
	
	pick_a_room()


func _process(delta):
	offscreen_cell_delete()
	#cell_add()
	if get_parent().get_node("Camera2D").position.x + screen_size.x  >= draw_cell.x * 32:
		pick_a_room()
	
	
func offscreen_cell_delete(): #Done
	var delete_cell_position =  map_to_world(delete_cell)
	
	if  get_parent().get_node("Camera2D").position.x - 32 >= delete_cell_position.x * 2:
		for i in range(0,1 + screen_size.y / 16):
			set_cell(delete_cell.x, i, -1)
		delete_cell.x += 1


func cell_add(): #Unneeded
	var add_cell_position = map_to_world(add_cell)
	
	if get_parent().get_node("Camera2D").position.x + screen_size.x >= add_cell_position.x * 2:
		set_cell(add_cell.x, 18, 1)
		add_cell.x += 1


func read_room_jsons(): #Done
	var files = []
	var dir = Directory.new()
	dir.open("res://level_info")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".json"):
			files.append(file)
	dir.list_dir_end()
	
	for file in files:
		var file_to_read = File.new()
		var path_to_file = "res://level_info/" + file
		file_to_read.open(path_to_file, File.READ)
		
		var parsed_data = []
		while file_to_read.get_position() < file_to_read.get_len():
			parsed_data.append(parse_json(file_to_read.get_line()))
		rooms.append(parsed_data)


func pick_a_room():
	randomize()
	var rooms_length = len(rooms)
	var card_draw = randi()  % rooms_length
	
	var chosen_room = rooms[card_draw]
	
	var room_size = 0
	
	for element in chosen_room:
		if element["type"] == "Tile":
			var x = element["x"]
			var y = element ["y"]
			var index = element ["index"]
			
			set_cell(x + draw_cell.x, y + draw_cell.y, index)
		elif element["type"] == "RoomDefinition":
			room_size = element["size"]
	
	draw_cell.x += room_size
