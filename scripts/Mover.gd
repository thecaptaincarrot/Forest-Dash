extends Node2D

var direction = "right"


var scroll_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	scroll_speed = 200
	direction = "right"


func _process(delta):
	match direction:
		"right":
			position.x += scroll_speed * delta
		"left":
			position.x -= scroll_speed * delta
		"up":
			position.y -= scroll_speed * delta
		"down":
			position.y += scroll_speed * delta


func _on_Game_direction_change(new_direction):
	direction = new_direction


func _on_Game_update_speed(new_speed):
	scroll_speed = new_speed
