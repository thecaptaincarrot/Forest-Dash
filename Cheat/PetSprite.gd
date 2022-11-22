extends AnimatedSprite


var default_position

var up_position
var down_position

export var position_offset = .8
export var speed = 3

var direction = true

# Called when the node enters the scene tree for the first time.
func _ready():
	default_position = position
	up_position = default_position.y - position_offset
	down_position = default_position.y + position_offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction:
		position.y -= speed * delta
		if position.y <= up_position:
			direction = !direction
	else:
		position.y += speed * delta
		if position.y >= down_position:
			direction = !direction
