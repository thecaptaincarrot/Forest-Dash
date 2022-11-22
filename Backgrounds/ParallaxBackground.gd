extends ParallaxBackground

export (String, "forest", "cave", "temple") var biome = "forest"


# Called when the node enters the scene tree for the first time.
func _ready():
	match biome:
		"forest":
			for N in get_children():
				N.get_node("ForestSprite").modulate.a = 1.0
				N.get_node("CaveSprite").modulate.a = 0.0
		"temple":
			for N in get_children():
				N.get_node("ForestSprite").modulate.a = 1.0
				N.get_node("CaveSprite").modulate.a = 0.0
		"cave":
			for N in get_children():
				N.get_node("ForestSprite").modulate.a = 0.0
				N.get_node("CaveSprite").modulate.a = 1.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match biome:
		"forest":
			for N in get_children():
				if N.get_node("ForestSprite").modulate.a < 1.0:
					N.get_node("ForestSprite").modulate.a += delta
				if N.get_node("CaveSprite").modulate.a > 0.0:
					N.get_node("CaveSprite").modulate.a -= delta
		"temple":
			for N in get_children():
				if N.get_node("ForestSprite").modulate.a < 1.0:
					N.get_node("ForestSprite").modulate.a += delta
				if N.get_node("CaveSprite").modulate.a > 0.0:
					N.get_node("CaveSprite").modulate.a -= delta
		"cave":
			for N in get_children():
				if N.get_node("ForestSprite").modulate.a > 0.0:
					N.get_node("ForestSprite").modulate.a -= delta
				if N.get_node("CaveSprite").modulate.a < 1.0:
					N.get_node("CaveSprite").modulate.a += delta


func change_biome(level):
	match level:
		1:
			biome = "forest"
		2:
			biome = "cave"
		3:
			biome = "temple"
