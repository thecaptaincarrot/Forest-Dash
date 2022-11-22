extends AudioStreamPlayer

export var PlayInstantly = false

# Called when the node enters the scene tree for the first time.
func _ready():
	volume_db = (9 - Persistant.music_volume) * -4 - 10
	if Persistant.music_volume == 0:
		volume_db = -80
	
	if PlayInstantly:
		play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	volume_db = (9 - Persistant.music_volume) * -4 - 10
	if Persistant.music_volume == 0:
		volume_db = -80
