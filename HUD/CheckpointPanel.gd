extends Panel

var menu_index = 0
var max_index = 1

signal exit

signal level1
signal level2
signal level3

var focused = false

var on_color = Color(1.0,1.0,1.0,1.0)
var off_color = Color(0.25,0.25,0.25,1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if !$Cooldown.is_stopped():
		return
	else:
		$Cooldown.start()
	
	if focused:
		if Input.is_action_pressed("ui_select"):
			focused = false
			match menu_index:
				0:
					emit_signal("level1")
				1:
					emit_signal("level2")
				2:
					emit_signal("level3")
		
		if Input.is_action_pressed("ui_cancel"):
			emit_signal("exit")
			focused = false
		
		if Input.is_action_pressed("ui_down"):
			menu_index += 1
			if menu_index > max_index:
				menu_index = 0
			update_menu()
		
		if Input.is_action_pressed("ui_up"):
			menu_index -= 1
			if menu_index < 0:
				menu_index = max_index
			update_menu()


func update_menu():
	var options = [$Level1/Word,$Level2/Word,$Level3/Word]
	var chosen_option = null
	
	match menu_index:
		0:
			chosen_option = $Level1/Word
			options.erase($Level1/Word)
		1:
			chosen_option = $Level2/Word
			options.erase($Level2/Word)
		2:
			chosen_option = $Level3/Word
			options.erase($Level3/Word)

	
	for option in options:
		option.modulate = off_color
	
	$Sprite.frame = menu_index
	
	chosen_option.modulate = on_color


func check_levels():
	$Level2.hide()
	$Level3.hide()
	if Persistant.checkpoint >=2:
		$Level2.show()
		max_index = 1
	
	if Persistant.checkpoint >= 3:
		$Level3.show()
		max_index = 2


func open():
	show()
	focused = true
	menu_index = 0
	check_levels()
	update_menu()
	$Cooldown.start()
