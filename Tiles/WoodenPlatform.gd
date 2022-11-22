extends StaticBody2D

var type = "platform"
onready var MainNode = get_node("/root/Game")

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if MainNode.modifier == MainNode.GRAVITY:
		$CollisionShape2D.rotation_degrees = 180
	else:
		$CollisionShape2D.rotation_degrees = 0
