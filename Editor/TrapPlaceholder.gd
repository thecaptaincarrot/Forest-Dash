extends Node2D


var identity = "Spikes"
var index = 0 setget change_index

var moused_in


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func change_index(new_index):
	$AnimatedSprite.frame = new_index
	index = new_index
	
	match index:
		0:
			identity = "Spikes"
		1:
			identity = "HiddenSpikes"
		2:
			identity = "SwingTrap"
		3:
			identity = "Platform1"
		4:
			identity = "Platform2"
		5:
			identity = "Platform3"
		6:
			identity = "Platform4"
		7:
			identity = "Platform5"
		


func _on_TrapArea_Unset():
	queue_free()
