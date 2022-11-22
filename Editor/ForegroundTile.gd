extends TileMap

var level = 1
var direct_neighbors = [Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1)]
var screen_size
export var background = false
export var background1 = false

var room_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	room_size = 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reset(size, direction):
	clear()
	var bottom_row = floor(screen_size.y / 32)
	var left_column = floor(screen_size.x / 32)
	
	if direction == "up" or direction == "down":
		for i in range(-1,size + 1):
			set_cell(-1,i,0)
			set_cell(0,i,0)
			
			set_cell(left_column - 1,i,0)
			set_cell(left_column,i,0)
	elif direction == "right" or direction == "left":
		for i in range(-1,size + 1):
			set_cell(i,-1,0)
			set_cell(i,0,0)
			
			set_cell(i,bottom_row,0)
			set_cell(i,bottom_row + 1,0)
	else:
		print("tried to reset grid in invalid direciton")
	
	for cell_vector in get_used_cells():
		update_cell(cell_vector.x,cell_vector.y)
	
	room_size = size


func soft_reset(size,direction):
	if direction == "right" or direction == "left":
		for i in range(size, size + 20):
			clear_column(i)
		var bottom_row = floor(screen_size.y / 32)
		
		for i in range(-1,size + 1):
			set_cell(i,-1,0)
			set_cell(i,0,0)
			
			set_cell(i,bottom_row,0)
			set_cell(i,bottom_row + 1,0)

			if level == 2:
				set_cell(i,1,0)
				set_cell(i,2,0)
				set_cell(i,3,0)
				set_cell(i,4,0)
				set_cell(i,5,0)

				set_cell(i,bottom_row - 1,0)
				set_cell(i,bottom_row - 2,0)
				set_cell(i,bottom_row - 3,0)
				set_cell(i,bottom_row - 4,0)
				set_cell(i,bottom_row - 5,0)

			
			elif level == 3:
				set_cell(i,1,0)
				
				set_cell(i,bottom_row - 1,0)
			
		for cell_vector in get_used_cells():
			update_cell(cell_vector.x,cell_vector.y)
		
	if direction == "up" or direction == "down":
		for i in range(size, size + 20):
			clear_row(i)
		var front_column = floor(screen_size.x / 32)
		
		for i in range(-1,size + 1):
			set_cell(-1,i,0)
			set_cell(0,i,0)

			set_cell(front_column-1,i,0)
			set_cell(front_column,i,0)
			
			if level == 1:
				set_cell(1,i,0)
				set_cell(2,i,0)
				
				set_cell(front_column - 1,i,0)
				set_cell(front_column - 2,i,0)
				set_cell(front_column - 3,i,0)
				
			elif level == 2:
				set_cell(1,i,0)
				set_cell(2,i,0)
				set_cell(3,i,0)
				set_cell(4,i,0)
				set_cell(5,i,0)
				set_cell(6,i,0)
				set_cell(7,i,0)
				set_cell(8,i,0)
				set_cell(9,i,0)
				
				set_cell(front_column - 1,i,0)
				set_cell(front_column - 2,i,0)
				set_cell(front_column - 3,i,0)
				set_cell(front_column - 4,i,0)
				set_cell(front_column - 5,i,0)
				set_cell(front_column - 6,i,0)
				set_cell(front_column - 7,i,0)
				set_cell(front_column - 8,i,0)
				set_cell(front_column - 9,i,0)
				set_cell(front_column - 10,i,0)
			
			elif level == 3:
				set_cell(1,i,0)
				set_cell(2,i,0)
				
				set_cell(front_column - 2,i,0)
				set_cell(front_column - 3,i,0)
			
		for cell_vector in get_used_cells():
			update_cell(cell_vector.x,cell_vector.y)
	
	room_size = size


func soft_reset_non_primary(size,direction):
	if direction == "right" or direction == "left":
		for i in range(size, size + 20):
			clear_column(i)
		var bottom_row = floor(screen_size.y / 32)
			
		for cell_vector in get_used_cells():
			update_cell(cell_vector.x,cell_vector.y)
		
	if direction == "up" or direction == "down":
		for i in range(size, size + 20):
			clear_row(i)
		var front_column = floor(screen_size.x / 32)
			
		for cell_vector in get_used_cells():
			update_cell(cell_vector.x,cell_vector.y)
	
	room_size = size


func clear_column(column):
	var bottom_row = floor(screen_size.y / 32)
	
	for i in range(-1 , bottom_row + 2):
		set_cell(column,i,-1)


func clear_row(row):
	var last_column = floor(screen_size.x / 32)
	
	for i in range(-1 , last_column + 2):
		set_cell(i,row,-1)


func set_tile(mouse_position):	
	#gotta do some logic about how many sides are filled.
	#review and change that tiles, and any neighboring tiles.
	var grid_position = world_to_map(mouse_position)
	
	set_cell(grid_position.x, grid_position.y, 0)
	
	update_cell(grid_position.x, grid_position.y)
	
	update_cell(grid_position.x + 1, grid_position.y)
	update_cell(grid_position.x - 1, grid_position.y)
	update_cell(grid_position.x, grid_position.y + 1)
	update_cell(grid_position.x, grid_position.y - 1)
	
	update_cell(grid_position.x + 1, grid_position.y + 1)
	update_cell(grid_position.x - 1, grid_position.y + 1)
	update_cell(grid_position.x - 1, grid_position.y - 1)
	update_cell(grid_position.x + 1, grid_position.y - 1)


func unset_tile(mouse_position):
	#gotta do some logic about how many sides are filled.
	#review and change that tiles, and any neighboring tiles.
	var grid_position = world_to_map(mouse_position)
	
	set_cell(grid_position.x, grid_position.y, -1)
	
	update_cell(grid_position.x + 1, grid_position.y)
	update_cell(grid_position.x - 1, grid_position.y)
	update_cell(grid_position.x, grid_position.y + 1)
	update_cell(grid_position.x, grid_position.y - 1)
	
	update_cell(grid_position.x + 1, grid_position.y + 1)
	update_cell(grid_position.x - 1, grid_position.y + 1)
	update_cell(grid_position.x - 1, grid_position.y - 1)
	update_cell(grid_position.x + 1, grid_position.y - 1)


func update_cell(x,y):
	
	#1. update the cell you're in
	var bitwise = 0
	if get_cell(x,y) != INVALID_CELL:
		if get_cell(x+0,y-1) != INVALID_CELL:
			bitwise += 1
		if get_cell(x+1,y + 0) != INVALID_CELL:
			bitwise += 2
		if get_cell(x+0,y+1) != INVALID_CELL:
			bitwise += 4
		if get_cell(x-1,y+0) != INVALID_CELL:
			bitwise += 8
	else:
		return
	#default
	var new_index = 0
	if background1 and level == 3:
		match bitwise:
			0:
				new_index = 1
			2:
				new_index = 2
			8:
				new_index = 3
			1:
				new_index = 4
			5:
				new_index = 5
			4:
				new_index = 6
	else:
		match bitwise:
			#CORNERS
			3:
				new_index = 7
			6:
				new_index = 8
			9:
				new_index = 6
			12:
				new_index = 5
			#SIDES
			5: 
				new_index = 2
			13: 
				new_index = 2
			7: 
				new_index = 4
			11:
				new_index = 3
			14:
				new_index = 1
			#inside corners
			15:
				if get_cell(x + 1, y - 1) == INVALID_CELL:
					new_index = 11
				if get_cell(x + 1, y + 1) == INVALID_CELL:
					new_index = 12
				if get_cell(x - 1, y + 1) == INVALID_CELL:
					new_index = 9
				if get_cell(x - 1, y - 1) == INVALID_CELL:
					new_index = 10
			#Platforms
			2:
				new_index = 13
			8:
				new_index = 15
			10: 
				new_index = 14
	if level == 3 and background:
		new_index = 0
		match bitwise:
			14:
				new_index = 8
			13:
				new_index = 10
			7:
				new_index = 13
			12:
				new_index = 9
			9:
				new_index = 11
			3:
				new_index = 12
			6:
				new_index = 7
	set_cell(x,y,new_index)


func update_all():
	#ridiculously inefficient but fuck it
	for i in range(-2,100):
		for h in range(-2,100):
			update_cell(i,h)


func filp_cells_h():
	var midpoint = floor(room_size / 2)
	
	for i in range(-1, midpoint):
		for h in range(-1, screen_size.y / 32 + 2):
			var left_index = get_cell(i,h)
			var right_index = get_cell(room_size - i - 1,h)
			
			set_cell(i,h, right_index)
			set_cell(room_size - i - 1, h ,left_index)
	
	update_all()


func recave(size, direction):
	clear()
	var bottom_row = floor(screen_size.y / 32)
	var left_column = floor(screen_size.x / 32)
	
	if direction == "up" or direction == "down":
		for i in range(-1,size + 1):
			set_cell(-1,i,0)
			set_cell(0,i,0)
			set_cell(1,i,0)
			set_cell(2,i,0)
			set_cell(3,i,0)
			set_cell(4,i,0)
			set_cell(5,i,0)
			set_cell(6,i,0)
			set_cell(7,i,0)
			set_cell(8,i,0)
			set_cell(9,i,0)
			
			set_cell(left_column - 1,i,0)
			set_cell(left_column,i,0)
			set_cell(left_column - 2,i,0)
			set_cell(left_column - 3,i,0)
			set_cell(left_column - 4,i,0)
			set_cell(left_column - 5,i,0)
			set_cell(left_column - 6,i,0)
			set_cell(left_column - 7,i,0)
			set_cell(left_column - 8,i,0)
			set_cell(left_column - 9,i,0)
			set_cell(left_column - 10,i,0)
	elif direction == "right" or direction == "left":
		for i in range(-1,size + 1):
			set_cell(i,-1,0)
			set_cell(i,0,0)
			set_cell(i,1,0)
			set_cell(i,2,0)
			set_cell(i,3,0)
			set_cell(i,4,0)
			set_cell(i,5,0)
			
			set_cell(i,bottom_row,0)
			set_cell(i,bottom_row + 1,0)
			set_cell(i,bottom_row - 1,0)
			set_cell(i,bottom_row - 2,0)
			set_cell(i,bottom_row - 3,0)
			set_cell(i,bottom_row - 4,0)
			set_cell(i,bottom_row - 5,0)
	else:
		print("tried to reset grid in invalid direciton")
	
	for cell_vector in get_used_cells():
		update_cell(cell_vector.x,cell_vector.y)


func oops(size, direction):
	print(direction)
	var bottom_row = floor(screen_size.y / 32)
	var left_column = floor(screen_size.x / 32)
	if direction == "right" or direction ==  "left":
		for i in range(-1,size + 1):
			set_cell(i,-1,1)
			set_cell(i,bottom_row + 1,1)
		for i in range(-1,bottom_row + 1):
			set_cell(-1, i,1)
			set_cell(size,i,1)
	elif direction == "up" or direction == "down":
		print("up")
		for i in range(-1,size + 1):
			set_cell(-1,i,1)
			set_cell(left_column,i,1)
		for i in range(-1, left_column + 1):
			set_cell(i,-1,1)
			set_cell(i,size,1)
	for cell_vector in get_used_cells():
		update_cell(cell_vector.x,cell_vector.y)
