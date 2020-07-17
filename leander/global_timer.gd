extends Node


var time = 0
var timerVar = 0

var start_growing_time
var growing_rate
var start_power_up_time
var power_spawn_time

var global = null
var config = null

func _ready():
	global = get_node("/root/global")
	config = get_node("/root/config")
	
	start_growing_time = config.start_grow_time
	start_power_up_time = config.start_power_up_time
	growing_rate = config.growing_rate
	power_spawn_time = config.power_spawn
	
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
				global.board.grow()
		
		if time >= start_power_up_time:
			var current_spawn = ((time - start_power_up_time)%power_spawn_time)
			if current_spawn == 0:
				global.board.spawn_booster()

func get_time():
	return time
