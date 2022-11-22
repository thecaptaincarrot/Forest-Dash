extends AnimatedSprite



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DetectionArea_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.name == "PlayerArea" and (animation == "Idle" or animation == "Retracting"):
		animation = "Tease"
		$TrapTimer.wait_time = 0.5
		$TrapTimer.start()
		yield($TrapTimer, "timeout")
		
		animation = "Emerging"
		
		$TrapArea.collision_layer = 1
		
		$TrapTimer.wait_time = 1.25
		$TrapTimer.start()
		
		yield($TrapTimer,"timeout")
		
		$TrapArea.collision_layer = 0	
		animation = "Retracting"
