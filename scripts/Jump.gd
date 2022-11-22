extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	volume_db = (9 - Persistant.sound_volume) * -8 - 10
	if Persistant.sound_volume == 0:
		volume_db = -80


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	volume_db = (9 - Persistant.sound_volume) * -4 - 10
	if Persistant.sound_volume == 0:
		volume_db = -80
