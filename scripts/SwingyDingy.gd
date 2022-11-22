extends AnimatedSprite


var shape

var left0 = Vector2(-27.5, -3.5)
var left1 = Vector2(-26.25, -1.5)
var left2 = Vector2(-20.5, 7.5)
var left3 = Vector2(-11.75,12.75)
var center = Vector2(0,15.25)
var right3 = Vector2(11.25,12.25)
var right2 = Vector2(21, 7.5)
var right1 = Vector2(26.25, -1.5)
var right0 = Vector2(27,-4)

var on = true

var type = "swing"

# Called when the node enters the scene tree for the first time.
func _ready():
	shape = $SwingNode


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match animation:
		"SwingLeft":
			match frame:
				0:
					#shape.position = right0
					shape.rotation_degrees = -70
				1:
					#shape.position = right1
					shape.rotation_degrees = -65
				2:
					#shape.position = right2
					shape.rotation_degrees = -45
				3:
					#shape.position = right3
					shape.rotation_degrees = -22.5
				4:
					#shape.position = center
					shape.rotation_degrees = 0
				5:
					#shape.position = left3
					shape.rotation_degrees = 22.5
				6:
					#shape.position = left2
					shape.rotation_degrees = 45
				7:
					#shape.position = left1
					shape.rotation_degrees = 65
				8:
					#shape.position = left0
					shape.rotation_degrees = 70
		"SwingRight":
			match frame:
				0:
					#shape.position = left0
					shape.rotation_degrees = 70
				1:
					#shape.position = left1
					shape.rotation_degrees = 65
				2:
					#shape.position = left2
					shape.rotation_degrees = 45
				3:
					#shape.position = left3
					shape.rotation_degrees = 22.5
				4:
					#shape.position = center
					shape.rotation_degrees = 0
				5:
					#shape.position = right3
					shape.rotation_degrees = -22.5
				6:
					#shape.position = right2
					shape.rotation_degrees = -45
				7:
					#shape.position = right1
					shape.rotation_degrees = -65
				8:
					#shape.position = right0
					shape.rotation_degrees = -70


func _on_ReverseTimer_timeout():
	match animation:
		"SwingRight":
			play("SwingLeft")
		"SwingLeft":
			play("SwingRight")
