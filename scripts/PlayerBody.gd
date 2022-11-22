extends KinematicBody2D

var floors = -2

export (PackedScene) var JumpDust
export (PackedScene) var LandingDust

export (PackedScene) var Slash

onready var SlideDust = preload("res://Scenes/SlideDust.tscn")

var up = Vector2(0,-1)
export (String) var direction

var gravity = 28
var acceleration = 25

var skid_friction = 1.0

var speed = 300
var scroll_speed = 400

var jump_impulse = -750
var jump_cut = -200

var can_jump = false
var is_jumping = false
var can_wall_jump = false

var reverse_protection = false

var wall_direction = "right"

var damage_vector = Vector2(-20,0)

var motion = Vector2(0,0)
var velocity = Vector2(0,0)

var ground_state = false
var wall_state = false

var health = 3

signal hurt
signal dead
signal CoinCollect
signal ChestCollect
signal Heal
signal ClearCondition

enum {FINE, HURT, DEAD, INVULN}
var state = FINE

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = "up"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale.y = 1
	up = Vector2(0,-1)


func _physics_process(delta):
	match state:
		FINE:
			movement(delta)
			actions()
		HURT:
			$PlayerSprite.play("Hurt")
			move_and_slide(Vector2(-20,0),up)
	if ground_state == false and is_on_floor():
		create_landing_dust()
		ground_state = true
	
	if is_on_wall() and !is_on_floor() and !wall_state:
		if $PlayerSprite.flip_h:
			wall_direction = "left"
		else:
			wall_direction = "right"
		wall_state = true
	
	if is_on_wall() == false:
		if wall_state and !is_on_ceiling():
			$CoyoteWalljumpTime.start()
		wall_state = false
	
	if is_on_floor() == false:
		if ground_state:
			$CoyoteTime.start()
		ground_state =false


func movement(delta):
	var base_speed
	var min_speed
	var max_speed
	
	match direction: #Speed clampings based on direction
		"up":
			base_speed = 0
			max_speed = base_speed + 300
			min_speed = base_speed - 300
		"down":
			base_speed = 0
			max_speed = base_speed + 300
			min_speed = base_speed - 300
		"right":
			base_speed = 0
			max_speed = base_speed + 300
			min_speed = -300
		"left":
			base_speed = 0
			min_speed = base_speed - 300
			max_speed = 300
	
	motion.y += gravity #gravity regardless of anything else
	
	if Input.is_action_pressed("ui_right"):
		if motion.x < base_speed: #friction from movement
			motion.x += acceleration + acceleration * skid_friction
		else:
			motion.x += acceleration #normal acceleration
	elif Input.is_action_pressed("ui_left"):
		if motion.x > base_speed: #friction from movement
			motion.x -= (acceleration + acceleration * skid_friction)
		else:
			motion.x -= acceleration #normal acceleration
	elif is_on_floor(): #ground Friction
		if motion.x < base_speed + 10 and motion.x > base_speed - 10: #jitter fix
			motion.x = base_speed
		
		if motion.x > base_speed: #Neutral Stick friction
			motion.x -= acceleration * 1.5
		elif motion.x < base_speed:
			motion.x += acceleration * 1.5
		

	else: #Air Friction
		if motion.x < base_speed + 10 and motion.x > base_speed - 10: #jitter fix
			motion.x = base_speed
		
		if $MomentumTimer.is_stopped():
			if motion.x > base_speed:
				motion.x -= acceleration * .5
			elif motion.x < base_speed:
				motion.x += acceleration * .5
	
	#ground Animations
	if is_on_floor():
		can_jump = true
		if $PlayerSprite.animation != "Attack":
			if abs(motion.x) > 20:
				if is_on_wall():
					$PlayerSprite.animation = "Push"
				else:
					$PlayerSprite.animation = "Run"
			else:
				motion.x = 0
				$PlayerSprite.animation = "Idle"
	
	#Animation Flipping
	if motion.x < -20:
		$PlayerSprite.flip_h = true
	elif motion.x > 20:
		$PlayerSprite.flip_h = false
	
	if can_jump:
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_jump"):
			can_jump = false
			if Input.is_action_pressed("ui_down"): #Semi-solid drop through
				set_collision_layer_bit(2, false)
				set_collision_mask_bit(2, false)
				$FallThroughTimer.start()
			else: #Jumping
				$Jump.play()
				create_jump_dust()
				motion.y += jump_impulse
				is_jumping = true
	
	if Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_jump"): #Analogue Jumping
		if motion.y < jump_cut:
			motion.y = jump_cut
	
	if can_wall_jump and !Input.is_action_pressed("ui_down") and motion.y > 0 and floors <= 0: #Wall Jump
		if Input.is_action_pressed("ui_jump"):
			can_wall_jump = false
			if motion.y >= 200:
				motion.y = 200
			$Jump.play()
			motion.y += jump_impulse
			$MomentumTimer.start()
			if wall_direction == "left":
				motion.x -= jump_impulse * 100
			elif wall_direction == "right":
				motion.x += jump_impulse * 100
	
	if is_on_floor() == false:
		#purely animations
		if motion.y > 0: # down
			if $PlayerSprite.animation != "Attack" and $PlayerSprite.animation != "DownAttack":
				#Wall slide
				if is_on_wall() and floors <= 0 :
					can_wall_jump = true
					
					if $PlayerSprite.flip_h:
							motion.x -= 50
					else:
							motion.x += 50
					$PlayerSprite.play("Slide")
					if $SlideDustTimer.is_stopped():
						var dust = SlideDust.instance()
						dust.position = position
						if $PlayerSprite.flip_h:
							dust.position.x += 10
							dust.flip_h = true
						else:
							dust.position.x -= 10
							
						get_parent().add_child(dust)
						
						$SlideDustTimer.start()
					
					if motion.y >= 200: #Wall Slide Timer
						motion.y = 200
				else:
					$PlayerSprite.play("Falling")
		else:
			if $PlayerSprite.animation != "Attack" and $PlayerSprite.animation != "DownAttack":
				$PlayerSprite.play("Jumping")
	
	#Clamp
	if is_on_floor():
		motion.x = clamp(motion.x, min_speed, max_speed)
	else: #Air Momentum Clamp
		motion.x = clamp(motion.x, min_speed * 1.25, max_speed * 1.25)
		
	motion = move_and_slide(motion,up)
	print(motion)


func actions():
	if Input.is_action_pressed("ui_attack") and $AttackCooldown.is_stopped():
		$Slash.play()
		$AttackCooldown.start()
		var new_slash = Slash.instance()
		
		if Input.is_action_pressed("ui_down") and !is_on_floor():
			$PlayerSprite.play("DownAttack")
			new_slash.position.y = 70
			new_slash.rotation_degrees = 90
			
			new_slash.scale.x = 1.75
			if $PlayerSprite.flip_h:
				new_slash.scale.y = -1
			else:
				new_slash.scale.y = 1
		else:
			if $PlayerSprite.flip_h:
				new_slash.position.x = -44
				new_slash.scale.x = -1
			else:
				new_slash.position.x = 44
				new_slash.scale.x = 1
			
			$PlayerSprite.play("Attack")
		add_child(new_slash)


func create_jump_dust():
	var dust = JumpDust.instance()
	dust.position = position
	get_parent().add_child(dust)


func create_landing_dust():
	$Land.play()
	var dust = LandingDust.instance()
	dust.position = position
	get_parent().add_child(dust)


func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
	if area == null:
		return
	if area.name == "EnemyArea" and $InvulnTimer.is_stopped():
		if area.get_parent().hurt == false:
			health -= 1
			state = HURT
			emit_signal("hurt")
			$HurtTimer.start()
			$InvulnTimer.start()
			check_health()
			$Hurt.play()
	if area.name == "TrapArea" and $InvulnTimer.is_stopped():
		health -= 1
		state = HURT
		emit_signal("hurt")
		$HurtTimer.start()
		$InvulnTimer.start()
		check_health()
		$Hurt.play()
	if area.name == "SwingingArea":
		if area.get_parent().get_parent().on and $InvulnTimer.is_stopped():
			health -= 1
			state = HURT
			emit_signal("hurt")
			$HurtTimer.start()
			$InvulnTimer.start()
			check_health()
			$Hurt.play()
	elif area.name == "DeathWallArea" and health > 0:
		health = 0
		emit_signal("hurt")
		check_health()
	elif area.name == "CoinArea":
		area.get_parent().play("Collect")
		emit_signal("CoinCollect")
		$Coin.play()
	elif area.name == "ChestArea":
		if area.get_parent().closed:
			area.get_parent().collect()
			emit_signal("ChestCollect")
			for n in range(5):
				$Coin.play()
				var t = Timer.new()
				t.wait_time = .08
				add_child(t)
				t.start()
				yield(t, "timeout")
				t.queue_free()
	elif area.name == "HealthArea":
		if health < 3:
			health += 1
			area.get_parent().queue_free()
			emit_signal("Heal")
			$Health.play()


func _on_InvulnTimer_timeout():
	state = FINE


func check_health():
	if health <= 0:
		$HurtTimer.stop()
		state = DEAD
		motion.x = scroll_speed
		motion.y = 0
		$PlayerSprite.play("Death")
		emit_signal("dead")
		$Die.play()


func _on_PlayerSprite_animation_finished():
	if $PlayerSprite.animation == "Attack":
		$PlayerSprite.play("Run")
	
	if $PlayerSprite.animation == "DownAttack":
		$PlayerSprite.play("Run")
	


func _on_FallThroughTimer_timeout():
	set_collision_layer_bit(2, true)
	set_collision_mask_bit(2, true)


func _on_CoyoteTime_timeout():
	can_jump = false


func _on_Game_direction_change(new_direction):
	direction = new_direction
	print("Player has seen the new direction: ", direction)


func _on_FloorDetector_body_shape_entered(body_id, body, body_shape, area_shape):
	floors += 1


func _on_FloorDetector_body_shape_exited(body_id, body, body_shape, area_shape):
	floors -= 1


func _on_CoyoteWalljumpTime_timeout():
	can_wall_jump = false # Replace with function body.
