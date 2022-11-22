extends Node2D


var identity = "coin"
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
			identity = "Coin"
		1:
			identity = "Chest"
		2:
			identity = "Potion"


func _on_EditorArea2D_Unset():
	queue_free()
