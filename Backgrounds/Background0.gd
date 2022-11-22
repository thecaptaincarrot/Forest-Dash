extends Sprite


var scroll_speed = 400


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= delta * scroll_speed
	if position.x <= 1000:
		queue_free()
