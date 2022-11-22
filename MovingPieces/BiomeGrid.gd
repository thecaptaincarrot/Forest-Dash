extends Node2D

onready var foreground1 = $Foreground1
onready var foreground2 = $Foreground2
onready var background1 = $Background1
onready var background2 = $Background2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_tile(layer_index, x, y, tile_index, offset):
	match layer_index:
		0:
			foreground1.set_cell(x + offset.x,y + offset.y, tile_index)
		1:
			foreground2.set_cell(x + offset.x,y + offset.y, tile_index)
		2:
			background1.set_cell(x + offset.x,y + offset.y, tile_index)
		3:
			background2.set_cell(x + offset.x,y + offset.y, tile_index)
