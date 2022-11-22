extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frame = Persistant.volume


func _on_Left_Volume_pressed():
	pass # Replace with function body.


func _on_Right_Volume_pressed():
	pass # Replace with function body.
