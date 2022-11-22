extends Area2D

signal Unset
var unset_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("editor_unset"):
		emit_signal("Unset")


func _input(event):
	if event.is_action_pressed("editor_unset"):
		unset_pressed = true
	elif event.is_action_released("editor_unset"):
		unset_pressed = false


func _on_EnemyArea_mouse_entered():
	if unset_pressed:
		emit_signal("Unset")
