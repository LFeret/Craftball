extends Node


var time = 0
var timerVar = 0

const start_growing_time = 500000000 # seconds
const growing_rate = 5

func _ready():
	set_process(true)
	

func _process(delta):
	timerVar += delta
	
	if timerVar >= 1:
		# ~ 1 Second gone
		time += 1
		timerVar = 0
		
		if time >= start_growing_time:
			var current_growing = ((time - start_growing_time)%growing_rate)
			if current_growing == 0:
				get_node("/root/global").board.grow()

func get_time():
	return time
