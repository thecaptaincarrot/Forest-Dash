extends KinematicBody2D

export (PackedScene) var throwable
onready var spores = preload("res://Enemies/SporeHandler.tscn")
#onready var MainNode = get_node("/root/Game")

signal score_up

var motion = Vector2()
var gravity = 30
export var speed = 100

export var jump_height = -700

var up = Vector2(0,-1)

export(String, "idle", "idle_left","idle_right", "spore_shoot", "walk_left", "walk_right", "fly_left", "fly_right", "fly_idle",
		"dying", "jump_in_place" ,"throwing_left", "throwing_right") var behaviour = "idle"

var sporing = false

var hurt_vector = Vector2(150,0)

export var health = 1
export var max_health = 1

export var score = 500

export var type = ""

var hurt = false
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	pass # Replace with function body.


func _process(delta):
	if max_health == 2 and health == 1:
		if $HurtSprite != null:
			$HurtSprite.show()
	else:
		if $HurtSprite != null:
			$HurtSprite.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if hurt == false:
		collision_layer = 2
		match behaviour:
			"walk_left":
				motion.x = speed * -1
				motion.y += gravity
				if !is_on_floor():
					$AnimatedSprite.play("Falling")
				else:
					$AnimatedSprite.play("Walking")
				$AnimatedSprite.flip_h = true
			"walk_right":
				motion.x = speed * 1
				motion.y += gravity
				if !is_on_floor():
					$AnimatedSprite.play("Falling")
				else:
					$AnimatedSprite.play("Walking")
				$AnimatedSprite.flip_h = false
			"idle":
				$AnimatedSprite.play("Idle")
				if !hurt:
					motion.x = 0
				motion.y += gravity
			"idle_right":
				$AnimatedSprite.play("Idle")
				$AnimatedSprite.flip_h = false
				if !hurt:
					motion.x = 0
				motion.y += gravity
			"idle_left":
				$AnimatedSprite.play("Idle")
				$AnimatedSprite.flip_h = true
				if !hurt:
					motion.x = 0
				motion.y += gravity
			"spore_shoot":
				$AnimatedSprite.flip_h = false
				#$AnimatedSprite.play("Idle")
				motion.y += gravity
			"throwing_left":
				$AnimatedSprite.flip_h = true
				#$AnimatedSprite.play("Idle")
				motion.y += gravity
			"throwing_right":
				$AnimatedSprite.flip_h = false
				#$AnimatedSprite.play("Idle")
				motion.y += gravity
			"fly_idle":
				$AnimatedSprite.play("Idle")
			"dying":
				$AnimatedSprite.play("Dying")
			"jump_in_place":
				motion.y += gravity
				motion.x = 0
				if is_on_floor() and $Timer.is_stopped():
					motion.y = jump_height
					$Timer.start()
				if !is_on_floor():
					$AnimatedSprite.play("Falling")
				else:
					$AnimatedSprite.play("Idle")
		
		#Jump
		if is_on_wall() and is_on_floor() and (behaviour == "walk_left" or behaviour == "walk_right"):
			motion.y = jump_height
		#Turn Around
		if is_on_wall() and (behaviour == "fly_left" or behaviour == "fly_right"):
			if behaviour == "fly_left":
				behaviour = "fly_right"
				position.x += 10
			elif behaviour =="fly_right":
				behaviour = "fly_left"
				position.x -= 10
		
		
		motion = move_and_slide(motion,up)
	else:
		collision_layer = 0
		$AnimatedSprite.play("Hurt")
		motion = hurt_vector
		motion = move_and_slide(motion,up)


func _on_EnemyArea_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	if area == null:
		return
	
	if area.name == "SwordSlash":
		var slash_sprite = area.get_parent()
		var direction  = slash_sprite.scale.x
		
		hurt_vector = Vector2(100,0) * direction
		
		health -= 1
		hurt = true
		$HurtTimer.start()
		if health <= 0:
			collision_layer = 0
			collision_mask = 0
			emit_signal("score_up",score)
			$EnemyArea.queue_free()
			behaviour = "dying"


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Dying":
		queue_free()
	if $AnimatedSprite.animation == "Attacking":
		var weapon = throwable.instance()
		weapon.position = position + $Position2D.position
		get_parent().add_child(weapon)
		if !$AnimatedSprite.flip_h:
			weapon.flip_h = true
		$AnimatedSprite.animation = "Idle"
	if $AnimatedSprite.animation == "Shoot":
		spawn_spores()
		$RecoveryTimer.start()
		yield($RecoveryTimer,"timeout")
		$AnimatedSprite.animation = "Idle"
		$SporeTimer.start()


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()
	


func _on_HurtTimer_timeout():
	hurt = false


func _on_ThrowTimer_timeout():
	$AnimatedSprite.animation = "Attacking"


func _on_VisibilityNotifier2D_viewport_entered(viewport):
	set_process(true)


func _on_VisibilityNotifier2D_screen_entered():
	set_process(true)


func _on_SporeTimer_timeout():
	if behaviour == "spore_shoot":
		$AnimatedSprite.animation = "Shoot"
		
		


func spawn_spores():
	var new_spores = spores.instance()
	new_spores.position = position
	
	get_parent().add_child(new_spores)
