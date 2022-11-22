extends Node2D

export(String, "Endless", "Story") var mode = "Endless"

var current_display = 1

var fade_out = false
var fade_speed = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	display_highscore(1)
	show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade_out:
		if modulate.a >= 0:
			modulate.a -= delta
		else:
			current_display += 1
			if current_display > 5:
				current_display = 1
			display_highscore(current_display)
			fade_out = false
			$DisplayTimer.start()
	else:
		if modulate.a < 1.0:
			modulate.a += delta
		else:
			pass


func display_highscore(rank):
	var score_dict = {}
	match mode:
		"Endless":
			score_dict = Persistant.endless_highscores
		"Story":
			score_dict = Persistant.story_highscores
	
	$Word.word = str(rank) + "." + score_dict[rank]["name"]
	$Number.number = score_dict[rank]["score"]
	
	$Word.position.x  = (len($Word.word) + 1) * -12


func _on_DisplayTimer_timeout():
	fade_out = true
