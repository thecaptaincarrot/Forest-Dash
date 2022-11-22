extends Node2D

var live_spores = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if live_spores <= 0:
		queue_free()


func _on_Spore_spore_dead():
	live_spores -= 1
