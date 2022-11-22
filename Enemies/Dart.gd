extends AnimatedSprite

var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flip_h:
		position.x += delta * speed
	else:
		position.x -= delta * speed


func _on_TrapArea_area_shape_entered(area_id, area, area_shape, self_shape):
	if area is TileMap:
		queue_free()
	if area.name == "PlayerArea" or area.name == "SwordSlash":
		queue_free()
	


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()


func _on_TrapArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body is TileMap:
		queue_free()
