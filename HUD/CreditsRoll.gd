extends Control

signal credits_off

var do_once

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if do_once:
		$VBoxContainer.rect_position.y -= delta * 100
	if $VBoxContainer.rect_position.y <= -1750 and do_once:
		deactivate()


func _input(event):
	if Input.is_action_pressed("ui_pause"):
		deactivate()


func activate():
	show()
	do_once = true
	$VBoxContainer.rect_position.y = 650


func deactivate():
	hide()
	do_once = false
	emit_signal("credits_off")
