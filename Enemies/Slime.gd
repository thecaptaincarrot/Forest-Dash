extends KinematicBody2D

export (PackedScene) var throwable
#onready var MainNode = get_node("/root/Game")

var motion = Vector2()
var gravity = 20
export var speed = 50

export var jump_height = -500

var up = Vector2(0,-1)

var tiles_inside = 0

export(String, "idle", "walk_left", "walk_right", "dying", "jump_in_place" ,"throwing","sticky") var behaviour = "idle"

var hurt_vector = Vector2(150,0)

var down_direction = Vector2(0, -1)
var go_direction = Vector2(1,0)

export var health = 1

export var score = 500

export var type = ""

var hurt = false
# Called when the node enters the scene tree for the first time.
func _ready():
	match behaviour:
		"walk_left":
			go_direction = Vector2(-1,0)
		"walk_right":
			go_direction = Vector2(1,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !visible:
		return
	
	if hurt == false:
		match behaviour:
			"walk_left":
				$AnimatedSprite.flip_h = false
				motion = go_direction * speed
				motion += -up * gravity
				var on_tile = false
				
				for body in $FloorDetector.get_overlapping_bodies():
					if body is TileMap:
						on_tile = true
						
				if !on_tile and $Cooldown.is_stopped():
					$Cooldown.start()

			"walk_right":
				$AnimatedSprite.flip_h = true
				motion = go_direction * speed
				motion += -up * gravity
				var on_tile = false
				
				for body in $FloorDetector.get_overlapping_bodies():
					if body is TileMap:
						on_tile = true
				
				if !on_tile and $Cooldown.is_stopped():
					$Cooldown.start()

			
			"idle":
				$AnimatedSprite.play("Idle")
				motion.y += gravity
			"dying":
				$AnimatedSprite.play("Dying")
			"jump_in_place":
				motion.y += gravity
				if is_on_floor() and $Timer.is_stopped():
					motion.y = jump_height
					$Timer.start()
				if !is_on_floor():
					$AnimatedSprite.play("Falling")
				else:
					$AnimatedSprite.play("Idle")
		
		motion = move_and_slide(motion,up)
	else:
		$AnimatedSprite.play("Hurt")
		motion = hurt_vector
		motion = move_and_slide(motion,up)
		

func test_direction():
	if motion.x > 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true


func _on_EnemyArea_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	if area.name == "SwordSlash":
		var slash_sprite = area.get_parent()
		
		hurt_vector = Vector2(0,0)
		
		health -= 1
		hurt = true
		$HurtTimer.start()
		if health <= 0:
#			MainNode.score += score
#			MainNode.update_score()
			$EnemyArea.queue_free()
			behaviour = "dying"


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Dying":
		queue_free()


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()
	


func _on_HurtTimer_timeout():
	hurt = false


func _on_WallDetector_body_shape_entered(body_id, body, body_shape, area_shape):
	if body is TileMap:
		match behaviour:
			"walk_left":
				match up:
					Vector2(0,-1):
						rotation_degrees = 90
						up = Vector2(1,0)
						go_direction = Vector2(0,-1)
						position.y -= 0
					Vector2(-1,0):
						rotation_degrees = 0
						up = Vector2(0,-1)
						go_direction = Vector2(-1,0)
						position.x -= 0
					Vector2(0,1):
						rotation_degrees = 270
						up = Vector2(-1,0)
						go_direction = Vector2(0,1)
						position.y += 0
					Vector2(1,0):
						rotation_degrees = 180
						up = Vector2(0,1)
						go_direction = Vector2(1,0)
						position.x += 0
			"walk_right":
				match up:
					Vector2(0,-1):
						rotation_degrees = 270
						up = Vector2(-1,0)
						go_direction = Vector2(0,-1)
						position.y -= 0
					Vector2(-1,0):
						rotation_degrees = 180
						up = Vector2(0,1)
						go_direction = Vector2(-1,0)
						position.x -= 0
					Vector2(0,1):
						rotation_degrees = 90
						up = Vector2(1,0)
						go_direction = Vector2(0,1)
						position.y += 0
					Vector2(1,0):
						rotation_degrees = 0
						up = Vector2(0,-1)
						go_direction = Vector2(1,0)
						position.x += 0


func _on_FloorDetector_body_shape_entered(body_id, body, body_shape, area_shape):
	if body is TileMap:
		tiles_inside += 1


func _on_FloorDetector_body_shape_exited(body_id, body, body_shape, area_shape):
	if body is TileMap:
		tiles_inside -= 1
	
	if tiles_inside == 0:
		match behaviour:
			"walk_left":
				match up:
					Vector2(0,-1):
						rotation_degrees = 270
						up = Vector2(-1,0)
						go_direction = Vector2(0,1)
						position.y += 15
					Vector2(-1,0):
						rotation_degrees = 180
						up = Vector2(0,1)
						go_direction = Vector2(1,0)
						position.x += 15
					Vector2(0,1):
						rotation_degrees = 90
						up = Vector2(1,0)
						go_direction = Vector2(0,-1)
						position.y -= 15
					Vector2(1,0):
						rotation_degrees = 0
						up = Vector2(0,-1)
						go_direction = Vector2(-1,0)
						position.x -= 15
			"walk_right":
				match up:
					Vector2(0,-1):
						rotation_degrees = 90
						up = Vector2(1,0)
						go_direction = Vector2(0,1)
						position.y += 15
					Vector2(1,0):
						rotation_degrees = 180
						up = Vector2(0,1)
						go_direction = Vector2(-1,0)
						position.x -= 15
					Vector2(0,1):
						rotation_degrees = 270
						up = Vector2(-1,0)
						go_direction = Vector2(0,-1)
						position.y -= 15
					Vector2(-1,0):
						rotation_degrees = 0
						up = Vector2(0,-1)
						go_direction = Vector2(1,0)
						position.x += 15
