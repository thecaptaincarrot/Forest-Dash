extends Control

var escapable = false
var score

var menu_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	score = Global.final_score
	save_progress()
	if Global.cheated :
		Global.cheated = false
		$Word.hide()
		$Word2.hide()
		$Number.hide()
		$Cheated.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_score(score)
	update_menu()


func _input(event):
	if Input.is_action_pressed("ui_select") or Input.is_action_pressed("ui_pause") or Input.is_action_pressed("ui_cancel"):
		if escapable:
			match menu_index:
				0:
					restart_checkpoint()
				1:
					return_to_menu()
			
		else:
			escapable = true
			$Return.show()
			$Continue.show()
	
	if Input.is_action_pressed("ui_up"):
		menu_index += 1
		if menu_index > 1:
			menu_index = 0
		update_menu()
	
	if Input.is_action_pressed("ui_down"):
		menu_index -= 1
		if menu_index < 0:
			menu_index = 1
		update_menu()


func _on_BackToMenu_pressed():
	get_tree().change_scene("res://MainMenu.tscn")


func update_score(score):
	$Number.number = score


func _on_Timer_timeout():
	escapable = true
	$Continue.show()
	$Return.show()


func return_to_menu():
	#Do some saving
	get_tree().change_scene("res://MainMenu.tscn")


func restart_checkpoint():
	match Global.highest_level:
		1:
			Global.reset()
			get_tree().change_scene("res://StoryMode/Level1.tscn")
		2:
			Global.reset()
			get_tree().change_scene("res://StoryMode/Level2.tscn")
		3:
			Global.reset()
			get_tree().change_scene("res://StoryMode/Level3.tscn")


func restart_endless():
	Global.reset()
	get_tree().change_scene("res://main/Endless.tscn")


func restart_storymode():
	Global.reset()
	get_tree().change_scene("res://StoryMode/Level1.tscn")

func save_progress():
	if Persistant.checkpoint < Global.highest_level:
		Persistant.checkpoint = Global.highest_level
		Persistant.save_game()


func update_menu():
	match menu_index:
		0:
			$Continue.modulate = Color(1.0,1.0,1.0,1.0)
			$Return.modulate = Color(0.25,0.25,0.25,1.0)
		1:
			$Return.modulate = Color(1.0,1.0,1.0,1.0)
			$Continue.modulate = Color(0.25,0.25,0.25,1.0)
