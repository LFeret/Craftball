extends Node


var time = 0
var time_mult = 1.0
var paused = false

func _ready():
  set_process(true)

func _process(delta):
	if not paused:
		time += delta * time_mult

func get_time():
	return time
