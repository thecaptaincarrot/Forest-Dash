extends Node

var final_score = 0

var rooms

var highest_level = 0

var cheated = false

var lvl1_rooms = []
var lvl2_rooms = []
var lvl3_rooms = []
var lvl4_rooms = []

var special_rooms = {}

var directions = ["Right","Left","Up","Down"]

var saved_score = 0
var saved_lives = 0

func read_room_jsons():
	var files = []
	var dir = Directory.new()
	
	var level_directories = ["res://new_level_info/level1/", "res://new_level_info/level2/", "res://new_level_info/level3/", "res://new_level_info/level4/"]
	var level_index = 0
	
	#level 1
	for directory in level_directories:
		level_index += 1
		for direction in directions:
			dir.open(directory + "/" + direction)
			dir.list_dir_begin()
			while true:
				var file = dir.get_next()
				if file == "":
					break
				elif file.ends_with(".json"):
					files.append(file)
			dir.list_dir_end()
			for file in files:
				#print(file)
				var file_to_read = File.new()
				var path_to_file = directory + direction + "/" + file
				file_to_read.read(path_to_fileD)
				
				var parsed_data = []
				while file_to_read.get_position() < file_to_read.get_len():
					parsed_data.append(parse_json(file_to_read.get_line()))
				
				match level_index:
					1:
						lvl1_rooms.append(parsed_data)
					2:
						lvl2_rooms.append(parsed_data)
					3:
						lvl3_rooms.append(parsed_data)
					4:
						lvl4_rooms.append(parsed_data)
			files.clear()
	
	#special rooms
	var special_directory = "res://new_level_info/special/"
	
	dir.open(special_directory)
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
		var path_to_file = special_directory + file
		file_to_read.open(path_to_file, File.READ)
		
		var parsed_data = []
		while file_to_read.get_position() < file_to_read.get_len():
			parsed_data.append(parse_json(file_to_read.get_line()))
		
		special_rooms[file] = parsed_data


func reset():
	saved_lives = 2
	saved_score = 0
	highest_level = 1


func offload (score, lives):
	saved_score = score
	saved_lives = lives
