extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("OpeningCutscene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func to_next_scene():
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://StoryMode/Level1.tscn")

func _input(event):
	if Input.is_action_pressed("ui_pause"):
		get_tree().change_scene("res://StoryMode/Level1.tscn")
