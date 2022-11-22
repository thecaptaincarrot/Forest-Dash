extends Node2D


var identity = "Mushroom"
var behaviour = "idle"
#type is based on the creature, and cannot be set
#e.g. a mushroom will always be basic type, a fly is flying, a slime is sticky, etc

var index = 0 setget change_index

var moused_in


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = behaviour


func change_index(new_index):
	$EnemySprite.frame = new_index
	index = new_index
	
	match index:
		0:
			identity = "Mushroom"
		1:
			identity = "Blue Mushroom"
		2:
			identity = "Slime"
		3:
			identity = "Goblin"
		4:
			identity = "Goblin Thrower"
		5:
			identity = "Fly"
		6:
			identity = "Spore Shroom"


func _on_EnemyArea_Unset():
	queue_free()

