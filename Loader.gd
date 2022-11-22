extends Node

var loader
var wait_frames
var time_max = 100 #msec
var current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			#current_scene.queue_free()
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # Error during loading.
			print("Something Fucked during Loading")
			loader = null
			break


func goto_scene(path):
	loader = ResourceLoader.load_interactive(path)
	if loader == null:
		print("something is fucked")
		return
	set_process(true)
	
	 # Start your "loading..." animation.
	#get_node("animation").play("loading")
	
	wait_frames = 1


func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)


func update_progress():
	var anim = get_node("/root/SaltySquad/AnimationPlayer")
	var current_place = anim.current_animation_position
	
	var new_place = 0.0
	
	if current_place == 0.40:
		new_place = 0.0
	else:
		new_place = current_place + 0.05
	
	get_node("/root/SaltySquad/AnimationPlayer").seek(new_place, true)
