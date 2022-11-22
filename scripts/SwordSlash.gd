extends AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SwordSlash_animation_finished():
	queue_free()


func _on_Timer_timeout():
	queue_free()
