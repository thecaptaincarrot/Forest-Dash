extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	volume_db = (9 - Persistant.sound_volume)
	if Persistant.sound_volume == 0:
		volume_db = -80


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	volume_db = (9 - Persistant.sound_volume) * -2 - 10
	if Persistant.sound_volume == 0:
		volume_db = -80
