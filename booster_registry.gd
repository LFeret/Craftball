extends Node


var speed_ball_booster_script = preload('res://leander/booster/speed_ball_booster.res')

var boosters = []


# Called when the node enters the scene tree for the first time.
func _ready():
	boosters.append(speed_ball_booster_script)

func get_booster_count():
	return boosters.size()

func get_booster(random_int):
	return boosters[random_int].instance()
