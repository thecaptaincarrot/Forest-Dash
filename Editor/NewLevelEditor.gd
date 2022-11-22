extends Node2D
#packed scenes
export (PackedScene) var EditorItem
export (PackedScene) var EditorTrap
export (PackedScene) var EditorEnemy

#tilesets
#Background and Foreground are different based on collision
var forest_foreground_tileset = "res://MovingPieces/BiomeGrids/GrassForegroundTileset.tres"
var dirt_background_tileset = "res://MovingPieces/BiomeGrids/DirtBackgroundTileset.tres"
var rock_foreground_tileset = "res://MovingPieces/BiomeGrids/RockForegroundTileset.tres"
var tree_foreground_tileset = "res://MovingPieces/BiomeGrids/TreeForeground.tres"
var temple_foreground_tileset = "res://MovingPieces/BiomeGrids/TempleForegroundTileset.tres"
var temple_background_tileset = "res://MovingPieces/BiomeGrids/TempleBackgroundTileset.tres"

var set_mouse_down = false
var unset_mouse_down = false

var screen_size

var saving = false
var saving_flip = false

enum {TILE, ENEMY, ITEM, TRAP}
var placemode = TILE

var directions = ["right","left","up","down"]
var direction = "right"

var item_index = 0
var enemy_index = 0
var behaviour_index = 0
var trap_index = 0
var trap_rotation = 0
var biome_index = 1
var layer_index = 0

var behaviour_list = ["idle","idle_right","idle_left", "spore_shoot", "walk_left", "walk_right", "jump_in_place" ,"throwing_left", "throwing_right"]
var behaviour = "idle"

var difficulty_list = ["Easy", "Medium", "Hard"]
var difficulty = "Easy"
var difficulty_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	new_grid(20,direction)
	update_item_menu(0)
	update_behaviour(behaviour_index)
	
	$HUD/InfoPanel/DifficultyText.text = difficulty
	update_layer_index(layer_index)
	update_biome_index(biome_index)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match placemode:
		TILE:
			if set_mouse_down:
				var mouse_pos = get_global_mouse_position()
				match layer_index:
					0:
						$Foreground.set_tile(mouse_pos)
					1:
						$Background.set_tile(mouse_pos)
					2:
						$Background1.set_tile(mouse_pos)
			elif unset_mouse_down:
				var mouse_pos = get_global_mouse_position()
				match layer_index:
					#2 and 3 will be foreground and background 2 just in case
					0:
						$Foreground.unset_tile(mouse_pos)
					1:
						$Background.unset_tile(mouse_pos)
					2:
						$Background1.unset_tile(mouse_pos)
		ITEM:
			if set_mouse_down:
				var mouse_pos = get_global_mouse_position()
				var new_item = EditorItem.instance()
				new_item.index = item_index
				var offset = 16.0
				
				if item_index == 1: #chests go on the ground
					offset = 8.0
				
				var grid_position = Vector2(stepify(mouse_pos.x, offset), stepify(mouse_pos.y, offset))
				new_item.position = grid_position
				#verify overlap
				var overlap = false
				for item in $Items.get_children():
					if grid_position == item.position:
						overlap = true
				if !overlap:
					$Items.add_child(new_item)
		TRAP:
			if set_mouse_down:
				var mouse_pos = get_global_mouse_position()
				var new_trap = EditorTrap.instance()
				new_trap.index = trap_index
				var offset = 16.0
				
				var grid_position = Vector2(stepify(mouse_pos.x, offset), stepify(mouse_pos.y, offset))
				new_trap.position = grid_position
				new_trap.rotation_degrees = trap_rotation
				#verify overlap
				var overlap = false
				for trap in $Traps.get_children():
					if grid_position == trap.position:
						overlap = true
				if !overlap:
					$Traps.add_child(new_trap)
		ENEMY:
			if set_mouse_down:
				var mouse_pos = get_global_mouse_position()
				var new_enemy = EditorEnemy.instance()
				new_enemy.index = enemy_index
				var offset = 16.0
				
				var grid_position = Vector2(stepify(mouse_pos.x, offset), stepify(mouse_pos.y, offset))
				new_enemy.position = grid_position
				
				new_enemy.behaviour = behaviour
				
				#verify overlap
				var overlap = false
				for enemy in $Enemies.get_children():
					if grid_position == enemy.position:
						overlap = true
				if !overlap:
					$Enemies.add_child(new_enemy)


func _input(event):
	if Input.is_action_just_pressed("ui_pause"):
		$HUD/ConfirmSavePanel.hide()
		if !$HUD/LoadPanel.collapsed:
			$HUD/LoadPanel.collapse()
		if $HUD/Quit.visible:
			$HUD/Quit.hide()
			saving = false
		else:
			$HUD/Quit.show()
			saving = true
	
	
	if saving:
		$HUD/InfoPanel/clearbutton.disabled = true
		$HUD/InfoPanel/SaveButton.disabled = true
		
		$HUD/InfoPanel/NextDirection.disabled = true
		$HUD/InfoPanel/PreviousDirection.disabled = true
		
		$HUD/InfoPanel/Flip.disabled = true
		return
	else:
		$HUD/InfoPanel/clearbutton.disabled = false
		$HUD/InfoPanel/SaveButton.disabled = false
		
		$HUD/InfoPanel/NextDirection.disabled = false
		$HUD/InfoPanel/PreviousDirection.disabled = false
		
		$HUD/InfoPanel/Flip.disabled = false
		
	if event is InputEventMouse:
		var evLocal
		for child in $HUD.get_children():
			evLocal = child.make_input_local(event)
			if Rect2(Vector2(0,0),child.rect_size).has_point(evLocal.position) and child.is_visible():
				unset_mouse_down = false
				set_mouse_down = false
				return
			for grandchild in child.get_children():
				evLocal = grandchild.make_input_local(event)
				if Rect2(Vector2(0,0),grandchild.rect_size).has_point(evLocal.position) and grandchild.is_visible() and child.is_visible():
					unset_mouse_down = false
					set_mouse_down = false
					return
	
	if event.is_action_pressed("editor_set") and !saving:
		set_mouse_down = true
		unset_mouse_down = false
	elif event.is_action_released("editor_set"):
		set_mouse_down = false
	if event.is_action_pressed("editor_unset") and !saving:
		unset_mouse_down = true
		set_mouse_down = false
	elif event.is_action_released("editor_unset"):
		unset_mouse_down = false
	
	match placemode:
		TILE:
			if event.is_action_pressed("editor_raise"):
				next_layer()
			elif event.is_action_pressed("editor_lower"):
				previous_layer()
			
			elif event.is_action_pressed("editor_next"):
				next_biome()
			elif event.is_action_pressed("editor_previous"):
				previous_biome()
		ITEM:
			if event.is_action_pressed("editor_next"):
				_on_NextItem_pressed()
			elif event.is_action_pressed("editor_previous"):
				_on_PreviousItem_pressed()
				
		TRAP:
			if event.is_action_pressed("editor_raise"):
				rotate_trap()
			elif event.is_action_pressed("editor_lower"):
				derotate_trap()
			
			if event.is_action_pressed("editor_next"):
				next_trap()
			elif event.is_action_pressed("editor_previous"):
				previous_trap()
		ENEMY:
			if event.is_action_pressed("editor_raise"):
				next_behaviour()
			elif event.is_action_pressed("editor_lower"):
				previous_behaviour()
			
			if event.is_action_pressed("editor_next"):
				next_enemy()
			elif event.is_action_pressed("editor_previous"):
				previous_enemy()


func new_grid(size,direction):
	$Foreground.clear()
	$Foreground1.clear()
	$GridGude.regrid(size, direction)
	$Background.clear()
	$Background1.clear()
	for N in $Items.get_children():
		N.queue_free()
	
	for N in $Enemies.get_children():
		N.queue_free()
	
	for N in $Traps.get_children():
		N.queue_free()


func clear_all():
	$Foreground.clear()
	$Foreground1.clear()
	$Background.clear()
	$Background1.clear()
	for N in $Items.get_children():
		N.queue_free()
	
	for N in $Enemies.get_children():
		N.queue_free()
	
	for N in $Traps.get_children():
		N.queue_free()


func _on_SpinBox_value_changed(value):
	$Foreground.soft_reset(value,direction)
	$Foreground1.soft_reset_non_primary(value,direction)
	$Background.soft_reset_non_primary(value,direction)
	$Background1.soft_reset_non_primary(value,direction)
	$GridGude.regrid(value,direction)
	
	for N in $Traps.get_children():
		if direction == "right" or direction == "left":
			if N.position.x >= value * 32:
				N.queue_free()
		
		if direction == "up" or direction == "down":
			if N.position.y >= value * 32:
				N.queue_free()
			
	for N in $Enemies.get_children():
		if direction == "right" or direction == "left":
			if N.position.x >= value * 32:
				N.queue_free()
				
		if direction == "up" or direction == "down":
			if N.position.y >= value * 32:
				N.queue_free()
			
	for N in $Items.get_children():
		if direction == "right" or direction == "left":
			if N.position.x >= value * 32:
				N.queue_free()
				
		if direction == "up" or direction == "down":
			if N.position.y >= value * 32:
				N.queue_free()


func _on_Button_pressed():
	new_grid($HUD/InfoPanel/SpinBox.value,direction)


func save_level(level_name, biome_index):
	$Foreground.oops($HUD/InfoPanel/SpinBox.value,direction)
	var json_level_file = File.new()
	var json_level_path 
	
	if $HUD/ConfirmSavePanel/CheckBox.is_pressed():
		json_level_path = "res://new_level_info/special/" + level_name + ".json"
	else:
		json_level_path = "res://new_level_info/level" + str(biome_index) + "/"  + direction + "/" + level_name + ".json"
	
	json_level_file.open(json_level_path,File.WRITE)
	
	#var function_definition = "func " + str($Panel/LineEdit.text) + "():"
	#gd_level_file.store_line(function_definition)
	#determine size of level based on iterating through bottom tiles (never fall through world)
	#tile 18 is always the bottom
	var room_size = $HUD/InfoPanel/SpinBox.value
	
	var max_x = 0
	var max_y = 0
	
	if direction == "up" or direction == "down":
		max_y = room_size
		max_x = 32
	
	if direction == "right" or direction == "left":
		max_x = room_size
		max_y = 19
	
	#iterate through all cells to get cell_index
	#if index is not -1, write a line to the save file
	json_level_file.store_line(to_json({"type": "RoomDefinition", "size" : room_size, "name" : level_name, "direction" : direction, "biome" : biome_index, "special" : $HUD/ConfirmSavePanel/CheckBox.is_pressed(),"difficulty" : difficulty}))
	#Foreground
	for i in range(0,max_x):
		for j in range(0,max_y):
			var cell_index = $Foreground.get_cell(i,j)
			if cell_index != -1:
				var to_write = {
					"type" : "Tile",
					"layer" : 0,
					"x" : i,
					"y" : j,
					"index" : cell_index
				}
				json_level_file.store_line(to_json(to_write))
	#Foreground 1
	for i in range(0,max_x):
		for j in range(0,max_y):
			var cell_index = $Foreground1.get_cell(i,j)
			if cell_index != -1:
				var to_write = {
					"type" : "Tile",
					"layer" : 1,
					"x" : i,
					"y" : j,
					"index" : cell_index
				}
				json_level_file.store_line(to_json(to_write))
	#Background
	for i in range(0,max_x):
		for j in range(0,max_y):
			var cell_index = $Background.get_cell(i,j)
			if cell_index != -1:
				var to_write = {
					"type" : "Tile",
					"layer" : 2,
					"x" : i,
					"y" : j,
					"index" : cell_index
				}
				json_level_file.store_line(to_json(to_write))
	#Background2
	for i in range(0,max_x):
		for j in range(0,max_y):
			var cell_index = $Background1.get_cell(i,j)
			if cell_index != -1:
				var to_write = {
					"type" : "Tile",
					"layer" : 3,
					"x" : i,
					"y" : j,
					"index" : cell_index
				}
				json_level_file.store_line(to_json(to_write))
	#traps
	for trap in $Traps.get_children():
		print(trap.identity)
		print(trap.position)
		var save_trap = false
		if (direction == "right" or direction == "left") and trap.position.x > 0 and trap.position.x <= room_size * 32:
			save_trap = true
		elif (direction == "up" or direction == "down") and trap.position.y > 0 and trap.position.y <= room_size * 32:
			save_trap = true
		if save_trap:
			var to_write ={
				"type" : "Trap",
				"x": trap.position.x,
				"y": trap.position.y,
				"rotation" : trap.rotation,
				"name": trap.identity,
				}
			json_level_file.store_line(to_json(to_write))
	#enemies
	for enemy in $Enemies.get_children():
		var save_enemy = false
		if (direction == "right" or direction == "left") and enemy.position.x > 0 and enemy.position.x <= room_size * 32:
			save_enemy = true
		elif (direction == "up" or direction == "down") and enemy.position.y > 0 and enemy.position.y <= room_size * 32:
			save_enemy = true
		if save_enemy:
			#I don't think we need to change the export variables?
			var to_write = {
				"type" : "Enemy",
				"name" : enemy.identity,
				"behaviour" : enemy.behaviour,
				"x" : enemy.position.x,
				"y" : enemy.position.y,
			}
			json_level_file.store_line(to_json(to_write))
	#items
	for item in $Items.get_children():
		var save_item = false
		if (direction == "right" or direction == "left") and item.position.x > 0 and item.position.x <= room_size * 32:
			save_item = true
		elif (direction == "up" or direction == "down") and item.position.y > 0 and item.position.y <= room_size * 32:
			save_item = true
		if save_item:
			var to_write = {
				"type" : "Item",
				"name" : item.identity,
				"x" : item.position.x,
				"y" : item.position.y,
			}
			json_level_file.store_line(to_json(to_write))
	
	json_level_file.close()


func load_level(level):
	clear_all()
	
	var room_size = 0
	
	for element in level:
		if element["type"] == "RoomDefinition":
			room_size = element["size"]
			direction = element["direction"]
			
			$HUD/ConfirmSavePanel/LineEdit.text = element["name"]
			$HUD/InfoPanel/SpinBox.value = room_size
			
			biome_index = int(element["biome"])
			
			if element["special"]:
				$HUD/ConfirmSavePanel/CheckBox.pressed = true
			update_biome_index(biome_index)
			
			difficulty =  element["difficulty"]
			
			$HUD/InfoPanel/DifficultyText.text = difficulty
		
		elif element["type"] == "Tile":
			var target_layer = null
			var layer_index = int(element["layer"])
			match layer_index:
				0:
					target_layer = $Foreground
				1:
					target_layer = $Foreground1
				2:
					target_layer = $Background
				3:
					target_layer = $Background1
			var x = element["x"]
			var y = element ["y"]
			var index = element ["index"]
			target_layer.set_cell(x,y, index)
		
		elif element["type"] == "Trap":
			var to_add = EditorTrap.instance()
			match element["name"]:
				"Spikes":
					to_add.identity = "Spikes"
					to_add.index = 0
				"HiddenSpikes":
					to_add.identity = "HiddenSpikes"
					to_add.index = 1
				"SwingTrap":
					to_add.identity = "SwingTrap"
					to_add.index = 2
				"Platform1":
					to_add.identity = "Platform1"
					to_add.index = 3
				"Platform2":
					to_add.identity = "Platform2"
					to_add.index = 4
				"Platform3":
					to_add.identity = "Platform3"
					to_add.index = 5
				"Platform4":
					to_add.identity = "Platform4"
					to_add.index = 6
				"Platform5":
					to_add.identity = "Platform5"
					to_add.index = 7
			to_add.position = Vector2(element["x"],element["y"])
			to_add.rotation = element["rotation"]
			$Traps.add_child(to_add)
		elif element["type"] == "Enemy":
			var to_add = EditorEnemy.instance()
			match element["name"]:
				"Mushroom":
					to_add.identity = "Mushroom"
					to_add.index = 0
				"Blue Mushroom":
					to_add.identity = "Blue Mushroom"
					to_add.index = 1
				"Slime":
					to_add.identity = "Slime"
					to_add.index = 2
				"Goblin":
					to_add.identity = "Goblin"
					to_add.index = 3
				"Goblin Thrower":
					to_add.identity = "Goblin Thrower"
					to_add.index = 4
				"Fly":
					to_add.identity = "Fly"
					to_add.index = 5
				"Spore Shroom":
					to_add.identity = "Spore Shroom"
					to_add.index = 6

			to_add.position = Vector2(element["x"],element["y"])
			to_add.behaviour = element["behaviour"]
			$Enemies.add_child(to_add)
		elif element["type"] == "Item":
			var to_add = EditorItem.instance()
			match element["name"]:
				"Coin":
					to_add.identity = "Coin"
					to_add.index = 0
				"Potion":
					to_add.identity = "Potion"
					to_add.index = 2
				"Chest":
					to_add.identity = "Chest"
					to_add.index = 1
			to_add.position = Vector2(element["x"],element["y"])
			$Items.add_child(to_add)
	$GridGude.regrid(room_size,direction)
	
	$HUD/InfoPanel/DirectionText.text = direction


func flip_horizontally():
	#objects
	var h_size = $HUD/InfoPanel/SpinBox.value * 32
	var midway = h_size / 2
	#items
	for item in $Items.get_children():
		var current_x = item.position.x
		var offset = abs(midway - current_x)
		
		if current_x < midway:
			item.position.x = current_x + offset * 2
		else:
			item.position.x = current_x - offset * 2
	#traps
	for trap in $Traps.get_children():
		var current_x = trap.position.x
		var offset = abs(midway - current_x)
		
		if current_x < midway:
			trap.position.x = current_x + offset * 2
		else:
			trap.position.x = current_x - offset * 2
		
		if trap.rotation_degrees == 90.0:
			trap.rotation_degrees = 270
		elif trap.rotation_degrees == 270.0:
			trap.rotation_degrees = 90.0
	#enemies
	for enemy in $Enemies.get_children():
		var current_x = enemy.position.x
		var offset = abs(midway - current_x)
		
		if current_x < midway:
			enemy.position.x = current_x + offset * 2
		else:
			enemy.position.x = current_x - offset * 2
		#behaviour placeholder to do later
		#basically, need to switch direction which is just going to be a lot of if statements
		if enemy.behaviour == "walk_left":
			enemy.behaviour = "walk_right"
		elif enemy.behaviour == "walk_right":
			enemy.behaviour = "walk_left"
		
		elif enemy.behaviour == "idle_left":
			enemy.behaviour = "idle_right"
		elif enemy.behaviour == "idle_right":
			enemy.behaviour = "idle_left"
		
		elif enemy.behaviour == "throwing_right":
			enemy.behaviour = "throwing_left"
		elif enemy.behaviour == "throwing_left":
			enemy.behaviour = "throwing_right"
	#tiles oof
	$Foreground.filp_cells_h()
	$Foreground1.filp_cells_h()
	
	$Background.filp_cells_h()
	$Background1.filp_cells_h()
	
	if direction == "right":
		direction = "left"
	elif direction == "left":
		direction = "right"
	
	$HUD/InfoPanel/DirectionText.text = direction


func _on_SaveButton_pressed():
	$HUD/ConfirmSavePanel.show()
	saving = true


func _on_CommitButton_pressed():
	var level_name = $HUD/ConfirmSavePanel/LineEdit.text
	if $HUD/ConfirmSavePanel/FlipCheck.is_pressed() == true:
		saving_flip = true
	else:
		saving_flip = false
	
	save_level(level_name,biome_index)
	
	if saving_flip == true:
		if direction == "up" or direction == "down":
			if direction == "up":
				direction = "down"
			elif direction == "down":
				direction = "up"
			
			saving_flip = false
			
			save_level(level_name,biome_index)
			
			if direction == "up":
				direction = "down"
			elif direction == "down":
				direction = "up"
		else:
			saving_flip = false
			flip_horizontally()
			
			save_level(level_name, biome_index)
			flip_horizontally()
	
	saving = false
	
	$HUD/LoadPanel.update_loads()
	
	$HUD/ConfirmSavePanel/LineEdit.text = "LevelName"
	$HUD/ConfirmSavePanel.hide()
	$HUD/ConfirmSavePanel/CheckBox.pressed = false


func _on_CancelButton_pressed():
	saving = false
	$HUD/ConfirmSavePanel.hide()


func _on_Element_tab_changed(tab):
	match tab:
		0:
			placemode = TILE
		1:
			placemode = ENEMY
		2:
			placemode = ITEM
		3:
			placemode = TRAP


func _on_NextItem_pressed():
	var max_frame = $HUD/Element/Items/ItemSprite.frames.get_frame_count("default") - 1
	
	item_index += 1
	
	if item_index > max_frame:
		item_index = 0
	
	update_item_menu(item_index)


func _on_PreviousItem_pressed():
	var max_frame = $HUD/Element/Items/ItemSprite.frames.get_frame_count("default") - 1
	
	item_index -= 1
	
	if item_index < 0:
		item_index = max_frame
	
	update_item_menu(item_index)


func next_layer():
	#I'll need to know how many layers each biomes has.
	layer_index += 1
	match biome_index:
		1:
			if layer_index > 1:
				layer_index = 0
		2:
			if layer_index > 1:
				layer_index = 0
		3:
			if layer_index > 2:
				layer_index = 0
	update_layer_index(layer_index)
	


func previous_layer():
	#I'll need to know how many layers each biomes has.
	layer_index -= 1
	match biome_index:
		1:
			if layer_index < 0:
				layer_index = 1
		2:
			if layer_index < 0:
				layer_index = 1
		3:
			if layer_index < 0:
				layer_index = 2
	update_layer_index(layer_index)


func next_biome():
	biome_index += 1
	if biome_index > 3:
		biome_index = 1
	update_biome_index(biome_index)

func previous_biome():
	biome_index -= 1
	if biome_index < 1:
		biome_index = 3
	update_biome_index(biome_index)


func next_trap():
	trap_index += 1
	if trap_index > 7:
		trap_index = 0
	
	update_trap_index(trap_index)


func previous_trap():
	trap_index -= 1
	if trap_index < 0:
		trap_index = 7
	
	update_trap_index(trap_index)


func rotate_trap():
	trap_rotation += 90
	
	if trap_rotation >= 360:
		trap_rotation = 0
	
	update_trap_index(trap_index)


func derotate_trap():
	trap_rotation -= 90
	
	if trap_rotation < 0:
		trap_rotation = 270
	
	update_trap_index(trap_index)


func next_enemy():
	enemy_index += 1
	
	if enemy_index > 6:
		enemy_index = 0
		
	update_enemy_index(enemy_index)


func previous_enemy():
	enemy_index -= 1
	
	if enemy_index < 0:
		enemy_index = 6
	
	update_enemy_index(enemy_index)


func next_behaviour():
	behaviour_index += 1
	
	if behaviour_index > len(behaviour_list) - 1:
		behaviour_index = 0
	
	update_behaviour(behaviour_index)


func previous_behaviour():
	behaviour_index -= 1
	
	if behaviour_index < 0:
		behaviour_index = len(behaviour_list) - 1
	
	update_behaviour(behaviour_index)


func update_behaviour(index):
	behaviour = behaviour_list[index]
	
	$HUD/Element/Enemies/BehaviourLabel.text = behaviour


func update_item_menu(index):
	$HUD/Element/Items/ItemSprite.frame = item_index
	var new_item_name = "DEFAULT"
	match item_index:
		0:
			new_item_name = "Coin"
		1:
			new_item_name = "Chest"
		2:
			new_item_name = "Health Potion"
	$HUD/Element/Items/ItemLabel.text = new_item_name


func update_biome_index(index):
	$Foreground.level = index
	$Foreground1.level = index
	
	$Background.level = index
	$Background1.level = index
	match index:
		1:
			$Foreground.tile_set = load(forest_foreground_tileset)
			$Background.tile_set = load(dirt_background_tileset)
			$HUD/Element/Tiles/BiomeText.text = "Forest"
		2:
			$Foreground.tile_set = load(rock_foreground_tileset)
			$Background.tile_set = load(dirt_background_tileset)
			$HUD/Element/Tiles/BiomeText.text = "Cave"
		3:
			$Foreground.tile_set = load(temple_foreground_tileset)
			$Background.tile_set = load(temple_background_tileset)
			$HUD/Element/Tiles/BiomeText.text = "Temple"


func update_layer_index(index):
	match biome_index:
		1:
			match index:
				0:
					$HUD/Element/Tiles/LayerText.text = "Foreground"
				1:
					$HUD/Element/Tiles/LayerText.text = "Background"
		2:
			match index:
				0:
					$HUD/Element/Tiles/LayerText.text = "Foreground"
				1:
					$HUD/Element/Tiles/LayerText.text = "Background"
		3:
			match index:
				0:
					$HUD/Element/Tiles/LayerText.text = "Foreground"
				1:
					$HUD/Element/Tiles/LayerText.text = "Background"
				2:
					$HUD/Element/Tiles/LayerText.text = "Background2"

func update_trap_index(index):
	$HUD/Element/Traps/TrapSprite.frame = index
	
	if index == 5:
		$HUD/Element/Traps/TrapSprite.scale = Vector2(.75,.75)
	elif index == 6:
		$HUD/Element/Traps/TrapSprite.scale = Vector2(.5,.5)
	else:
		$HUD/Element/Traps/TrapSprite.scale = Vector2(1,1)
	
	match index:
		0:
			$HUD/Element/Traps/TrapLabel.text = "Spikes"
		1:
			$HUD/Element/Traps/TrapLabel.text = "HiddenSpikes"
		2:
			$HUD/Element/Traps/TrapLabel.text = "Swing Trap"
		3:
			$HUD/Element/Traps/TrapLabel.text = "Platform 1"
		4:
			$HUD/Element/Traps/TrapLabel.text = "Platform 2"
		5:
			$HUD/Element/Traps/TrapLabel.text = "Platform 3"
		6:
			$HUD/Element/Traps/TrapLabel.text = "Platform 4"
		7:
			$HUD/Element/Traps/TrapLabel.text = "Platform 5"
			
	$HUD/Element/Traps/Orientation.text = str(trap_rotation) + "°"
	
	$HUD/Element/Traps/TrapSprite.rotation_degrees = trap_rotation


func update_enemy_index(index):
	$HUD/Element/Enemies/EnemySprite.frame = index
	match index:
		0:
			$HUD/Element/Enemies/EnemyName.text = "Mushroom"
		1:
			$HUD/Element/Enemies/EnemyName.text = "Blue Mushroom"
		2:
			$HUD/Element/Enemies/EnemyName.text = "Slime"
		3:
			$HUD/Element/Enemies/EnemyName.text = "Goblin"
		4:
			$HUD/Element/Enemies/EnemyName.text = "Goblin Thrower"
		5:
			$HUD/Element/Enemies/EnemyName.text = "Fly"
		6:
			$HUD/Element/Enemies/EnemyName.text = "Spore Shroom"


func update_direction():
	new_grid($HUD/InfoPanel/SpinBox.value,direction)
	$HUD/InfoPanel/DirectionText.text = direction


func _on_PreviousDirection_pressed():
	#SPAGHETTI
	var direction_index = directions.find(direction)
	direction_index -= 1
	if direction_index < 0:
		direction_index = 3
	
	direction = directions[direction_index]
	
	print(direction_index)
	print(direction)
	
	update_direction()

#directions = ["right","up","left","down"]
func _on_NextDirection_pressed():
	#SPAGHETTI
	var direction_index = directions.find(direction)
	print(direction_index)
	direction_index += 1
	if direction_index > 3:
		direction_index = 0
	
	direction = directions[direction_index]
	
	print(direction_index)
	print(direction)
	update_direction()


func _on_Flip_pressed():
	#This is the easy part
	if direction == "up":
		direction = "down"
	elif direction =="down":
		direction = "up"
	#The hard part
	if direction == "right":
		flip_horizontally()
	elif direction == "left":
		flip_horizontally()
	
	$HUD/InfoPanel/DirectionText.text = direction


func _on_PreviousDifficulty_pressed():
	difficulty_index -= 1
	
	if difficulty_index < 0:
		difficulty_index = 2
	
	difficulty = difficulty_list[difficulty_index]
	$HUD/InfoPanel/DifficultyText.text = difficulty

func _on_NextDifficulty_pressed():
	difficulty_index += 1
	
	if difficulty_index > 2:
		difficulty_index = 0
	
	difficulty = difficulty_list[difficulty_index]
	$HUD/InfoPanel/DifficultyText.text = difficulty


func _on_Yes_pressed():
	get_tree().change_scene("res://MainMenu.tscn")


func _on_No_pressed():
	$HUD/Quit.hide()


func _on_recave_pressed():
	$Foreground.recave($HUD/InfoPanel/SpinBox.value, direction)


func _on_OopsButton_pressed():
	$Foreground.oops($HUD/InfoPanel/SpinBox.value,direction)
