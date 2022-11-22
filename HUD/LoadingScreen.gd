extends Control

var do_once = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if do_once:
		do_once = false
		Global.read_room_jsons()
		Persistant.load_game()
		print("done reading")
		get_tree().change_scene("res://MainMenu.tscn")
		queue_free()
		print("goodbye for real")
