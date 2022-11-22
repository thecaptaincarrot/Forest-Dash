extends Control

onready var menu_items = [$Resume,$Options,$Quit]

var off_color = Color(0.25,0.25,0.25,1.0)
var on_color = Color(1.0,1.0,1.0,1.0)

var menu_index = 0

var focused = false

signal exit_menu
signal return_to_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	check_index()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if focused:
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_right"):
			menu_index += 1
			if menu_index > 2:
				menu_index = 0
			check_index()
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left"):
			menu_index -= 1
			if menu_index < 0:
				menu_index = 2
			check_index()
		
		if Input.is_action_just_pressed("ui_select"):
			#go to scene
			match menu_index:
				0:
					#resume
					hide()
					focused = false
					emit_signal("exit_menu")
				1:
					#options
					$OptionsPanel.show()
					focused = false
					$OptionsPanel.focused = true
				2:
					#quit
					#show second window to confirm, progress will not be saved
					focused = false
					$QuitPanel.activate()
		
	if Input.is_action_just_pressed("ui_pause"):
		#resume
		hide()
		$OptionsPanel.hide()
		$OptionsPanel.focused = false
		
		$QuitPanel.hide()
		$QuitPanel.focused = false
		
		focused = false
		emit_signal("exit_menu")


func activate():
	show()
	focused = true
	menu_index = 0
	check_index()


func check_index():
	for item in menu_items:
		item.modulate = off_color
	
	menu_items[menu_index].modulate = on_color


func _on_OptionsPanel_exit():
	$OptionsPanel.hide()
	$RefocusTimer.start()


func _on_RefocusTimer_timeout():
	focused = true


func _on_QuitPanel_close_menu():
	$QuitPanel.hide()
	$RefocusTimer.start()
