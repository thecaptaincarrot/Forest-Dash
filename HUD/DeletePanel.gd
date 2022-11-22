extends Panel

var focused = false

var off_color = Color(.2,.2,.2,1.0)
var on_color = Color(1.0,1.0,1.0,1.0)

var menu_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if focused:
		if event.is_action_pressed("ui_left"):
			menu_index += 1
			if menu_index > 1:
				menu_index = 1
			update_menus()
		elif event.is_action_pressed("ui_right"):
			menu_index -= 1
			if menu_index < 0:
				menu_index = 0
			update_menus()
		
		elif event.is_action_pressed("ui_select"):
			match menu_index:
				0:
					
					deactivate()
				1:
					Persistant.reset_save()
					deactivate()


func activate():
	get_parent().focused = false
	focused = true
	menu_index = 0
	update_menus()
	show()


func deactivate():
	get_parent().get_node("timeout").start()
	focused = false
	get_parent().focused = true
	hide()


func update_menus():
	$Yes.modulate = off_color
	$No.modulate = off_color
	
	match menu_index:
		0:
			$No.modulate = on_color
		1:
			$Yes.modulate = on_color
