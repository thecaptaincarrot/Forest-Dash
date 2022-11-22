extends Camera2D


var direction

enum{LEFT, RIGHT, UP, DOWN}


# Called when the node enters the scene tree for the first time.
func _ready():
	direction = RIGHT



func _process(delta):
	match direction:
		RIGHT:
			position.x += 400 * delta
