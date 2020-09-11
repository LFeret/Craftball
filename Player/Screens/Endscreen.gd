extends Control

onready var ui : Node = get_node("/root/World/CanvasLayer/Ui")

func _ready():
	show_hit_score(ui.get_hit_score())

func show_hit_score(score):
#	pass
	get_node("VBoxContainer/CenterRow/VBoxContainer/HitScore").text = "HitScore: " + str(score)
	get_node("VBoxContainer/CenterRow/VBoxContainer/HitScore").show()
