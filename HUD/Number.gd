tool
extends Node2D

export var number : int

var current_number = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if number != current_number:
		get_node("NumberCotainer/1").frame = number % 10
		get_node("NumberCotainer/10").frame = floor(number % 100 / 10)
		get_node("NumberCotainer/100").frame = floor(number % 1000 / 100)
		get_node("NumberCotainer/1000").frame = floor(number % 10000 / 1000)
		get_node("NumberCotainer/10000").frame = floor(number % 100000 / 10000)
		get_node("NumberCotainer/100000").frame = floor(number % 1000000 / 100000)
		current_number = number
