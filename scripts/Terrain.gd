extends Node2D

export (PackedScene) var TestMap

var current_tilemap
var next_tilemap

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	current_tilemap = TestMap.instance()
	add_child(current_tilemap)
	add_new_map(TestMap)



func _process(delta):
	if next_tilemap.position.x <= 0:
		current_tilemap.queue_free()
		current_tilemap = next_tilemap
		add_new_map(TestMap)


func add_new_map(map):
	next_tilemap = map.instance()
	next_tilemap.position.x = screen_size.x
	add_child(next_tilemap)
	
