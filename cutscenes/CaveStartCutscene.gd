extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Cutscene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if Input.is_action_pressed("ui_pause"):
		get_tree().change_scene("res://StoryMode/Level2.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://StoryMode/Level2.tscn")
