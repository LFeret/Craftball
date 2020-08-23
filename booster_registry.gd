extends Node


var speed_ball_booster_script
var block_ball_booster_script

var boosters


# Called when the node enters the scene tree for the first time.
func _ready():
	speed_ball_booster_script = load('res://leander/booster/speed_ball_booster.res')
	block_ball_booster_script = load('res://leander/booster/block_ball_booster.res')
	boosters = []
	boosters.append(speed_ball_booster_script)
	boosters.append(block_ball_booster_script)

func get_booster_count():
	return boosters.size()

func get_booster(random_int):
	return boosters[random_int].instance()
