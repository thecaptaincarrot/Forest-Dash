extends Node

var checkpoint = 0

var story_highscores = {1:{"name":"Carrot", "score":100000},
						2:{"name":"Peaches", "score":100000},
						3:{"name":"Friscoe", "score":100000},
						4:{"name":"Lafferty", "score":100000},
						5:{"name":"Kurry", "score":100000},}

var endless_highscores = {1:{"name":"Carrot", "score":100000},
						2:{"name":"Peaches", "score":100000},
						3:{"name":"Friscoe", "score":100000},
						4:{"name":"Lafferty", "score":100000},
						5:{"name":"Kurry", "score":100000},}

var previous_best = 0

var endless = false

var music_volume = 5 #Volume in decibels = ()(9 - volume) * -8) - 10
var sound_volume = 5 #Volume in decibels = ()(9 - volume) * -8) - 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func save_game():
	var save_dict = {"checkpoint" : checkpoint, #will this work?
	"music_volume": music_volume,
	"sound_volume": sound_volume,
	"story_highscores": story_highscores,
	"endless_highscores": endless_highscores,
	"previous_best": previous_best
	#add achievement information
	}
	
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	
	save_game.store_line(to_json(save_dict))
	
	save_game.close()
	print ("Saved")


func reset_save():
	checkpoint = 0
	
	story_highscores = {1:{"name":"Carrot", "score":100000},
						2:{"name":"Peaches", "score":100000},
						3:{"name":"Friscoe", "score":100000},
						4:{"name":"Lafferty", "score":100000},
						5:{"name":"Kurry", "score":100000},}
	
	endless_highscores = {1:{"name":"Carrot", "score":100000},
						2:{"name":"Peaches", "score":100000},
						3:{"name":"Friscoe", "score":100000},
						4:{"name":"Lafferty", "score":100000},
						5:{"name":"Kurry", "score":100000},}
	previous_best = 0
	save_game()
	#reset high scores too


func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		checkpoint = 0
		save_game()
		print("No Save Data Found")
		return #No existing save data
	
	save_game.open("user://savegame.save", File.READ)
	
	var parsed_file =  parse_json(save_game.get_line())
	
	checkpoint = parsed_file["checkpoint"]
	music_volume = parsed_file["music_volume"]
	sound_volume = parsed_file["sound_volume"]
	
	previous_best = parsed_file["previous_best"]


func update_story_highscore(score , player_name : String):
	#only called after high score is already called for and submitted
	if score > story_highscores[1]["score"]:
		for i in range(4,1):
			story_highscores[i + 1]["score"] = story_highscores[i]["score"]
			story_highscores[i + 1]["name"] = story_highscores[i]["name"]
		story_highscores[1]["score"] = score
		story_highscores[1]["name"] = player_name
	elif score > story_highscores[2]["score"]:
		for i in range(4,2):
			story_highscores[i + 1]["score"] = story_highscores[i]["score"]
			story_highscores[i + 1]["name"] = story_highscores[i]["name"]
		story_highscores[2]["score"] = score
		story_highscores[2]["name"] = player_name
	elif score > story_highscores[3]["score"]:
		for i in range(4,3):
			story_highscores[i + 3]["score"] = story_highscores[i]["score"]
			story_highscores[i + 3]["name"] = story_highscores[i]["name"]
		story_highscores[2]["score"] = score
		story_highscores[2]["name"] = player_name
	elif score > story_highscores[4]["score"]:
		story_highscores[5]["score"] = story_highscores[4]["score"]
		story_highscores[5]["name"] = story_highscores[4]["name"]
		story_highscores[4]["score"] = score
		story_highscores[4]["name"] = player_name
	elif score > story_highscores[5]["score"]:
		story_highscores[5]["score"] = score
		story_highscores[5]["name"] = player_name


func check_endless_highscore(score , player_name : String):
	#only called after high score is already called for and submitted
	if score > endless_highscores[1]["score"]:
		for i in range(4,1):
			endless_highscores[i + 1]["score"] = endless_highscores[i]["score"]
			endless_highscores[i + 1]["name"] = endless_highscores[i]["name"]
		endless_highscores[1]["score"] = score
		endless_highscores[1]["name"] = player_name
	elif score > endless_highscores[2]["score"]:
		for i in range(4,2):
			endless_highscores[i + 1]["score"] = endless_highscores[i]["score"]
			endless_highscores[i + 1]["name"] = endless_highscores[i]["name"]
		endless_highscores[2]["score"] = score
		endless_highscores[2]["name"] = player_name
	elif score > endless_highscores[3]["score"]:
		for i in range(4,3):
			endless_highscores[i + 3]["score"] = endless_highscores[i]["score"]
			endless_highscores[i + 3]["name"] = endless_highscores[i]["name"]
		endless_highscores[2]["score"] = score
		endless_highscores[2]["name"] = player_name
	elif score > endless_highscores[4]["score"]:
		endless_highscores[5]["score"] = endless_highscores[4]["score"]
		endless_highscores[5]["name"] = endless_highscores[4]["name"]
		endless_highscores[4]["score"] = score
		endless_highscores[4]["name"] = player_name
	elif score > endless_highscores[5]["score"]:
		endless_highscores[5]["score"] = score
		endless_highscores[5]["name"] = player_name
