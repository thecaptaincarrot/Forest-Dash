extends Panel

var menu_index = 0
var focused = false

var off_color = Color(0.25,0.25,0.25,1.0)
var on_color = Color(1.0,1.0,1.0,1.0)

signal quit_game
signal close_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	focused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if focused:
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_right"):
			menu_index += 1
			if menu_index > 1:
				menu_index = 0
			check_index()
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left"):
			menu_index -= 1
			if menu_index < 0:
				menu_index = 1
			check_index()
		
		if Input.is_action_just_pressed("ui_select"):
			#go to scene
			match menu_index:
				0:
					#yes
					emit_signal("quit_game")
				1:
					#no
					hide()
					focused = false
					emit_signal("close_menu")


func activate():
	show()
	focused = true
	menu_index = 1 
	check_index()


func check_index():
	$Yes.modulate = off_color
	$No.modulate = off_color
	
	match menu_index:
		0:
			$Yes.modulate = on_color
		1:
			$No.modulate = on_color
