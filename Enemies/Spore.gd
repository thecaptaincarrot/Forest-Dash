extends Node2D

signal spore_dead


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TrapArea_area_entered(area):
	if area.name != "TrapArea" and area.name != "EnemyArea":
		emit_signal("spore_dead")
		queue_free()


func _on_TrapArea_body_entered(body):
	if body.name != "TrapArea" :
		emit_signal("spore_dead")
		queue_free()
