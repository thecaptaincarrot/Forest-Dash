extends Panel

var collapsed = false
var directions = ["right","left","up","down"]

var rooms = []
signal load_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	rect_size.y = 0
	$CollapseButton.text = "v"
	
	collapse()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func collapse():
	if collapsed:
		collapsed = false
		rect_size.y = 160
		$CollapseButton.text = "^"
		update_loads()
	else:
		collapsed = true
		rect_size.y = 0
		$CollapseButton.text = "v"


func update_loads():
	rooms.clear()
	
	var directories = []
	
	var folder_paths = ["res://new_level_info/level1/","res://new_level_info/level2/", "res://new_level_info/level3/", "res://new_level_info/level4/"]
	var folder_index = 0
	
	for N in $ScrollContainer/ButtonContainer.get_children():
		N.queue_free()
	
	var room_index = 0
	
	for folder in folder_paths:
		
		var temp_rooms = []
		
		var new_label = Label.new()
		
		$ScrollContainer/ButtonContainer.add_child(HSeparator.new())
		$ScrollContainer/ButtonContainer.add_child(new_label)
		$ScrollContainer/ButtonContainer.add_child(HSeparator.new())
		
		match folder_index:
			0:
				new_label.text = "Forest"
			1:
				new_label.text = "Tree"
			2:
				new_label.text = "Underground"
			3:
				new_label.text = "Temple"
			4:
				new_label.text = "Special"
		
		folder_index += 1
		
		for direction in directions:
			var newer_label = Label.new()
			
			$ScrollContainer/ButtonContainer.add_child(newer_label)
			
			newer_label.text = "    " + direction
			
			var files = []
			
			var dir = Directory.new()
			
			dir.open(folder + direction + "/")
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
				var path_to_file = folder + direction + "/" + file
				file_to_read.open(path_to_file, File.READ)
				var parsed_data = []
				while file_to_read.get_position() < file_to_read.get_len():
					parsed_data.append(parse_json(file_to_read.get_line()))
				rooms.append(parsed_data)
				temp_rooms.append(parsed_data)
				
				directories.append(path_to_file)
			
			files.clear()
			
			for room in temp_rooms:
				var new_button = Button.new()
				
				for element in room:
					if element["type"] == "RoomDefinition":
						new_button.text = element["name"]
						break
				
				new_button.connect("pressed",self,"load_level",[room_index])
				
				$ScrollContainer/ButtonContainer.add_child(new_button)
				#delete button
				var delete_button = Button.new()
				var folder_path = ""
				
				new_button.add_child(delete_button)
				delete_button.rect_position.x = rect_size.x - 30
				delete_button.text = "X"
				
				delete_button.connect("pressed",self,"delete_level",[directories[room_index]])
				
				room_index += 1
			
			temp_rooms.clear()
	
	var new_folder = "res://new_level_info/special/"
	var temp_rooms = []
	
	var new_label = Label.new()
	
	$ScrollContainer/ButtonContainer.add_child(HSeparator.new())
	$ScrollContainer/ButtonContainer.add_child(new_label)
	$ScrollContainer/ButtonContainer.add_child(HSeparator.new())
	
	new_label.text = "Special"
	
	var files = []
	var dir = Directory.new()
	
	dir.open(new_folder)
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
		var path_to_file = new_folder + file
		file_to_read.open(path_to_file, File.READ)
		var parsed_data = []
		while file_to_read.get_position() < file_to_read.get_len():
			parsed_data.append(parse_json(file_to_read.get_line()))
		rooms.append(parsed_data)
		temp_rooms.append(parsed_data)
	
	files.clear()
	
	for room in temp_rooms:
		var new_button = Button.new()
		
		for element in room:
			if element["type"] == "RoomDefinition":
				new_button.text = element["name"]
				break
		
		new_button.connect("pressed",self,"load_level",[room_index])
		
		room_index += 1
		
		$ScrollContainer/ButtonContainer.add_child(new_button)
	
	temp_rooms.clear()

func load_level(index):
	emit_signal("load_signal",rooms[index])


func delete_level(delete_path):
	var directory = Directory.new()
	if directory.file_exists(delete_path):
		var error = directory.remove(delete_path)
		if error:
			print("Error deleting file!")
	else:
		print("File not found")
	
	update_loads()
