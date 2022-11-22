extends Node2D

var direction = "right"
var directions = ["right","up","down","left"]

var on_direction = []
onready var off_directions = [$Right,$Left,$Top,$Bottom]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match direction:
		"right":
			on_direction = [$Left]
			off_directions = [$Right,$Top,$Bottom]
		"left":
			on_direction = [$Right]
			off_directions = [$Left,$Top,$Bottom]
		"up":
			on_direction = [$Bottom,$Top]
			off_directions = [$Right,$Left]
		"down":
			on_direction = [$Top,$Bottom]
			off_directions = [$Right,$Left]
	
	for wall in on_direction:
		wall.enter(delta)
	
	for wall in off_directions:
		wall.exit(delta)



func change_direction(new_direction):
	print("new direction ",new_direction)
	direction = new_direction



func _on_Game_direction_change(new_direction):
	print("new direction ",new_direction)
	direction = new_direction
