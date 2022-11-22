extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_health(health):
	#Animate hearts later
	
	if health >= 3:
		$MainHUD/HealthBar/Heart0.frame = 0
		$MainHUD/HealthBar/Heart1.frame = 0
		$MainHUD/HealthBar/Heart2.frame = 0
	elif health == 2:
		$MainHUD/HealthBar/Heart0.frame = 0
		$MainHUD/HealthBar/Heart1.frame = 0
		$MainHUD/HealthBar/Heart2.frame = 5
	elif health == 1:
		$MainHUD/HealthBar/Heart0.frame = 0
		$MainHUD/HealthBar/Heart1.frame = 5
		$MainHUD/HealthBar/Heart2.frame = 5
	elif health == 0:
		$MainHUD/HealthBar/Heart0.frame = 5
		$MainHUD/HealthBar/Heart1.frame = 5
		$MainHUD/HealthBar/Heart2.frame = 5


func update_lives(lives):
	if lives < 7:
		$MainHUD/HighLife.hide()
		$MainHUD/GridContainer.show()
	
	if lives >= 7:
		$MainHUD/GridContainer.hide()
		$MainHUD/HighLife.show()
		$MainHUD/HighLife/Number2.frame = lives % 10
		$MainHUD/HighLife/Number.frame = floor(lives % 100 / 10)
	elif lives >= 6:
		$MainHUD/GridContainer/Life0.show()
		$MainHUD/GridContainer/Life1.show()
		$MainHUD/GridContainer/Life2.show()
		$MainHUD/GridContainer/Life3.show()
		$MainHUD/GridContainer/Life4.show()
		$MainHUD/GridContainer/Life5.show()
	elif lives == 5:
		$MainHUD/GridContainer/Life0.show()
		$MainHUD/GridContainer/Life1.show()
		$MainHUD/GridContainer/Life2.show()
		$MainHUD/GridContainer/Life3.show()
		$MainHUD/GridContainer/Life4.show()
		$MainHUD/GridContainer/Life5.hide()
	elif lives == 4:
		$MainHUD/GridContainer/Life0.show()
		$MainHUD/GridContainer/Life1.show()
		$MainHUD/GridContainer/Life2.show()
		$MainHUD/GridContainer/Life3.show()
		$MainHUD/GridContainer/Life4.hide()
		$MainHUD/GridContainer/Life5.hide()
	elif lives == 3:
		$MainHUD/GridContainer/Life0.show()
		$MainHUD/GridContainer/Life1.show()
		$MainHUD/GridContainer/Life2.show()
		$MainHUD/GridContainer/Life3.hide()
		$MainHUD/GridContainer/Life4.hide()
		$MainHUD/GridContainer/Life5.hide()
	elif lives == 2:
		$MainHUD/GridContainer/Life0.show()
		$MainHUD/GridContainer/Life1.show()
		$MainHUD/GridContainer/Life2.hide()
		$MainHUD/GridContainer/Life3.hide()
		$MainHUD/GridContainer/Life4.hide()
		$MainHUD/GridContainer/Life5.hide()
	elif lives == 1:
		$MainHUD/GridContainer/Life0.show()
		$MainHUD/GridContainer/Life1.hide()
		$MainHUD/GridContainer/Life2.hide()
		$MainHUD/GridContainer/Life3.hide()
		$MainHUD/GridContainer/Life4.hide()
		$MainHUD/GridContainer/Life5.hide()
	elif lives <= 0:
		$MainHUD/GridContainer/Life0.hide()
		$MainHUD/GridContainer/Life1.hide()
		$MainHUD/GridContainer/Life2.hide()
		$MainHUD/GridContainer/Life3.hide()
		$MainHUD/GridContainer/Life4.hide()
		$MainHUD/GridContainer/Life5.hide()


func update_score(score):
	score = int(score)
	get_node("Score/100000/10000/1000/100/10/1").frame = score % 10
	get_node("Score/100000/10000/1000/100/10").frame = floor(score % 100 / 10)
	get_node("Score/100000/10000/1000/100").frame = floor(score % 1000 / 100)
	get_node("Score/100000/10000/1000").frame = floor(score % 10000 / 1000)
	get_node("Score/100000/10000/").frame = floor(score % 100000 / 10000)
	get_node("Score/100000/").frame = floor(score % 1000000 / 100000)


func update_coins(coins):
	$Coins/Sprite/coin10.frame = floor( coins % 100 / 10)
	$Coins/Sprite/coin10/coin1.frame = coins % 10


func cheated():
	get_node("Score/100000/").hide()
	$Score/Cheater.show()


func _on_Game_cheat():
	cheated()
