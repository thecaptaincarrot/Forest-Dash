extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Play")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if $AnimationPlayer.current_animation_position < 4.0:
			$AnimationPlayer.seek(4.0,true)
		else:
			$AnimationPlayer.seek(8.0,true)
			$AnimationPlayer.play("GemSpinner")
			goto_next()


func goto_next():
	Loader.goto_scene("res://HUD/LoadingScreen.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play("GemSpinner")
	$AnimationPlayer.get_animation("GemSpinner").set_loop(true)
	goto_next()
