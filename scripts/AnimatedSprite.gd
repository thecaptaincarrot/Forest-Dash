extends AnimatedSprite

var type = "Chest"
var closed = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func collect():
	if closed:
		animation = "Open"
		closed = false


func _on_AnimatedSprite_animation_finished():
	if animation == "Open":
		animation = "Used"
		$CoinParticles.emitting = true
