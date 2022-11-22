extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Left_Volume/Number.frame = Persistant.sound_volume
	


func _on_Left_Volume_pressed():
	if Persistant.sound_volume > 0:
		Persistant.sound_volume -= 1
	


func _on_Right_Volume_pressed():
	if Persistant.sound_volume < 9:
		Persistant.sound_volume += 1


func _on_Return_pressed():
	get_tree().paused = false
	hide()
	
func _input(event):
	if Input.is_action_pressed("ui_pause"):
		get_tree().paused = false
		hide()
