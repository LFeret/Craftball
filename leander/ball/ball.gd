extends "res://leander/ball/ball_pickable.gd"

export var bouncing_count:int
var current_bounc_count:int
var color = 'red'
var current_player = null

var explosion
var bouncing_sound = null

var is_bot_ball = false

func _ready():
	current_bounc_count = 0
	explosion = preload('res://leander/explosions/explosion.tscn')
	bouncing_sound = preload("res://leander/ball/bounce_sound.ogg")
	get_node("audio").stream = bouncing_sound
