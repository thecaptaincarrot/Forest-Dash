extends Control

var menu_index = 0
var focused = true #needed to navigate other menus

var on_color = Color(1.0,1.0,1.0,1.0)
var off_color = Color(0.25,0.25,0.25,1.0)
var deactivated_color = Color(.5,.5,.5,1.0)

onready var cooldown = $Cooldown

var time_x = 0.0
var pet_pressed = false
var pet_mode = false
var pet_index = 0
var pet_list = ["Kiki", "Riddle", "Barbas", "Peeky", "Bear", "Vi", "Ertugrul", "Mochi",
				"Charlie", "Saf", "Teenie", "Comet", "AAAAAAAAA"]

var starting_level = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	index_update()
	get_tree().paused = false
	$Menu/StoryMode.show()
	Global.cheated = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pet_pressed and !pet_mode:
		time_x += delta
		if time_x >= 10.0:
			pet_mode = true
			pet_index = 0
			update_pet_index()
			$Images/Gem.animation = "gemless"
			$Images/Gem/PetSprite.show()
	else:
		time_x = 0.0
	
	if $Warning.modulate.a > 0.0:
		$Warning.modulate.a -= delta


func _input(event):
	if !$Cooldown.is_stopped():
		return
	else:
		$Cooldown.start()
	
	if focused:
		if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_right"):
			menu_index += 1
			if menu_index > 4:
				menu_index = 0
			index_update()
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left"):
			menu_index -= 1
			if menu_index < 0:
				menu_index = 4
			index_update()
		
		if Input.is_action_just_pressed("ui_select"):
			#go to scene
			match menu_index:
				0:
					#Story Mode
					if Persistant.checkpoint <= 1:
						start_story_mode()
					else:
						yield($Cooldown,"timeout")
						focused = false
						$Windows/CheckpointPanel.open()
				1:
					if Persistant.checkpoint < 4:
						$Warning.modulate.a = 1.0
					else:
						get_tree().change_scene("res://main/Endless.tscn")
				2:
					#Option
					options_menu()
				3:
					credits_open()
					#credits
				4:
					get_tree().quit()
					#editor
				5:
					get_tree().change_scene("res://Editor/NewLevelEditor.tscn")
		
		if Input.is_action_just_pressed("ui_attack") and !pet_mode:
			pet_pressed = true
		
		if !Input.is_action_pressed("ui_attack") and !pet_mode:
			pet_pressed = false
		
		if Input.is_action_just_pressed("ui_attack") and pet_mode:
			pet_index += 1
			if pet_index > len(pet_list) - 1:
				pet_index = 0
			update_pet_index()


func _on_Options_pressed():
	$OptionsPanel.show()


func _on_Play_pressed():
	$FadeOut.play("FadeOut")
	$CanvasLayer.layer = 1


func _on_FadeOut_animation_finished(anim_name):
	print(starting_level)
	match starting_level:
		1:
			get_tree().change_scene("res://cutscenes/OpeningCutscene.tscn")
		2:
			get_tree().change_scene("res://cutscenes/CaveStartCutscene.tscn")
		3:
			get_tree().change_scene("res://cutscenes/TempleStartCutscene.tscn")


func _on_Credits_pressed():
	$CreditsPanel.show()


func index_update():
	#why pass the menu_index if it's a big old thing
	var options = [$Menu/StoryMode,$Menu/EndlessMode,$Menu/Options,$Menu/Credits,$Menu/Editor,$Menu/Exit]
	var chosen_option = null
	
	match menu_index:
		0:
			chosen_option = $Menu/StoryMode
			options.erase($Menu/StoryMode)
		1:
			chosen_option = $Menu/EndlessMode
			options.erase($Menu/EndlessMode)
		2:
			chosen_option = $Menu/Options
			options.erase($Menu/Options)
		3:
			chosen_option = $Menu/Credits
			options.erase($Menu/Credits)
		4:
			chosen_option = $Menu/Exit
			options.erase($Menu/Exit)
		5:
			pass
	
	for option in options:
		option.modulate = off_color
	
	chosen_option.modulate = on_color
	
	if menu_index == 1 and Persistant.checkpoint <4:
		chosen_option.modulate = deactivated_color


func start_story_mode():
	focused = false
	$FadeOut.play("FadeOut")
	$CanvasLayer.layer = 1
	Global.reset()
	starting_level = 1


func start_level_2():
	focused = false
	$FadeOut.play("FadeOut")
	$CanvasLayer.layer = 1
	Global.reset()
	
	starting_level = 2

func start_level_3():
	focused = false
	$FadeOut.play("FadeOut")
	$CanvasLayer.layer = 1
	Global.reset()
	
	starting_level = 3


func options_menu():
	if focused:
		focused = false
		$Windows/OptionsPanel.focused = true
		$Windows/OptionsPanel.show()
		
		print("Options")
		$Windows/OptionsPanel.option_index = 0
		$Windows/OptionsPanel.update_menuing()
		focused = false


func close_options():
	$Windows/OptionsPanel.hide()
	$RefocusTimer.start()


func credits_open():
	if focused:
		focused = false
		$CreditsRoll.activate()
		#credits


func close_storymode():
	print("Closed")
	$Windows/CheckpointPanel.hide()
	$RefocusTimer.start()


func update_pet_index():
	var top_word = $MenuElements/Forest
	top_word.word = pet_list[pet_index]
	$Images/Gem/PetSprite.frame = pet_index
	#


func _on_StorymodeButton_pressed():
	if focused:
		if Persistant.checkpoint <= 1:
			start_story_mode()
		else:
			focused = false
			$Windows/CheckpointPanel.open()


func _on_RefocusTimer_timeout():
	focused = true


func _on_CreditsRoll_credits_off():
	focused = true


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_EndlessButton_pressed():
	if Persistant.checkpoint < 4:
		$Warning.modulate.a = 1.0
	else:
		get_tree().change_scene("res://main/Endless.tscn")
	
