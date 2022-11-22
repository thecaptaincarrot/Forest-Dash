extends "res://scripts/Game.gd"


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
	
	if Global.highest_level < 1:
		Global.highest_level = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
