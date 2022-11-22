extends Node2D

export (String, "right", "left", "top", "bottom") var side = "right"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func enter(delta):
	if $TextureRect.modulate.a < 1.0:
		$TextureRect.modulate.a += delta
	match side:
		"left":
			if $WallOfDeath.position.x <= -24:
				$WallOfDeath.position.x += delta * 20
			pass
		"right":
			if $WallOfDeath.position.x >= 1048:
				$WallOfDeath.position.x -= delta * 20
			pass
		"bottom":
			if $WallOfDeath.position.y >= 564 + 24:
				$WallOfDeath.position.y -= delta * 20
			pass
		"top":
			if $WallOfDeath.position.y <= -24:
				$WallOfDeath.position.y += delta * 20
			pass


func exit(delta):
	if $TextureRect.modulate.a > 0.0:
		$TextureRect.modulate.a -= delta
	match side:
		"left":
			if $WallOfDeath.position.x >= -24 - 64:
				$WallOfDeath.position.x -= delta * 20
			
			pass
		"right":
			if $WallOfDeath.position.x <= 1048 + 64:
				$WallOfDeath.position.x += delta * 20
			
			pass
		"bottom":
			if $WallOfDeath.position.y <= 564 + 64:
				$WallOfDeath.position.y += delta * 20
			
			pass
		"top":
			if $WallOfDeath.position.y >= -24 - 64:
				$WallOfDeath.position.y -= delta * 20
			
			pass
