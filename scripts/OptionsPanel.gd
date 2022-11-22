extends Control

var option_index = 0
var focused = false

signal exit

# Called when the node enters the scene tree for the first time.
func _ready():
	update_music(Persistant.music_volume)
	update_sound(Persistant.sound_volume)
	update_menuing()
	option_index = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$Left_Volume/Number.frame = Persistant.volume
	pass


func _input(event):
	if focused:
		if Input.is_action_just_pressed("ui_pause"):
			print("I tried to unpause")
		
		if Input.is_action_pressed("ui_down"):
			if option_index < 2:
				option_index += 1
			update_menuing()
		elif Input.is_action_pressed("ui_up"):
			if option_index > 0:
				option_index -= 1
			update_menuing()
		
		elif Input.is_action_pressed("ui_right"):
			match option_index:
				0:
					sound_up()
				1:
					music_up()
			
		elif Input.is_action_pressed("ui_left"):
			match option_index:
				0:
					sound_down()
				1:
					music_down()
		
		elif Input.is_action_just_pressed("ui_select"):
			if option_index == 2:
				exit_menu()
		
		elif Input.is_action_just_pressed("ui_pause"):
			exit_menu()


func update_menuing():
	$SoundVolume/Right_Volume.self_modulate = Color(.1,.1,.1,1.0)
	$SoundVolume/Left_Volume.self_modulate = Color(.1,.1,.1,1.0)
	
	$MusicVolume/Right_Volume.self_modulate = Color(.1,.1,.1,1.0)
	$MusicVolume/Left_Volume.self_modulate = Color(.1,.1,.1,1.0)
	
	$Return.modulate = Color(.2,.2,.2,1.0)
	match option_index:
		0:
			#sound
			$SoundVolume/Right_Volume.self_modulate = Color(1.0,1.0,1.0,1.0)
			$SoundVolume/Left_Volume.self_modulate = Color(1.0,1.0,1.0,1.0)
		1:
			#Music
			$MusicVolume/Right_Volume.self_modulate = Color(1.0,1.0,1.0,1.0)
			$MusicVolume/Left_Volume.self_modulate = Color(1.0,1.0,1.0,1.0)
		2:
			#return
			$Return.modulate = Color(1.0,1.0,1.0,1.0)


func sound_up():
	if Persistant.sound_volume < 9:
		Persistant.sound_volume += 1
	else:
		Persistant.sound_volume = 9
	
	update_sound(Persistant.sound_volume)
	$AudioStreamPlayer.play()


func sound_down():
	if Persistant.sound_volume > 0:
		Persistant.sound_volume -= 1
	else:
		Persistant.sound_volume = 0
	
	update_sound(Persistant.sound_volume)
	$AudioStreamPlayer.play()


func update_sound(volume):
	$SoundVolume/SoundNumber.frame = volume


func music_up():
	if Persistant.music_volume < 9:
		Persistant.music_volume += 1
	else:
		Persistant.music_volume = 9
	
	update_music(Persistant.music_volume)
	$AudioStreamPlayer2.play()


func music_down():
	if Persistant.music_volume > 0:
		Persistant.music_volume -= 1
	else:
		Persistant.music_volume = 0
	
	update_music(Persistant.music_volume)
	$AudioStreamPlayer2.play()


func update_music(volume):
	$MusicVolume/MusicNumber.frame = volume


func exit_menu():
	Persistant.save_game()
	emit_signal("exit")
	focused = false
