extends TileMap


var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	buildout(30, "right")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func regrid(size, direction):
	clear()
	buildout(size, direction)
	#direction to come later


func buildout(padding, direction):
	var tiles_x = ceil(screen_size.x) / cell_size.x
	var tiles_y = 1 + ceil(screen_size.y) / cell_size.y
	
	if direction == "right" or direction == "left":
		for i in range(-40,padding + 40):
			for h in range (-40, tiles_y + 40):
				set_cell(i,h,1)
	
		for i in range(0,padding):
			for h in range (0, tiles_y):
				set_cell(i,h,0)
	else:
		for i in range(-40,tiles_x + 40):
			for h in range (-40, padding + 40):
				set_cell(i,h,1)
	
		for i in range(0,tiles_x):
			for h in range (0, padding):
				set_cell(i,h,0)
