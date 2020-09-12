extends Control

onready var ui : Node = get_node("/root/World/CanvasLayer/Ui")
onready var hexGrid : Node = get_node("/root/World/board/HexGrid")
onready var player : Node = get_node("/root/World/Player")
var playerColor

func _ready():
	show_hit_score()
	show_color_score()
	
func set_player_color(color):
	playerColor = color

func show_color_score():
	var playerHitScore
	
	var redCount = 0
	var blueCount = 0
	var greenCount = 0
	var yellowCount = 0
	var whiteCount = 0
	var hexesTotal  = 0
	var hexes = hexGrid.get_hexes()
	
	hexesTotal = hexes.size()
	
	for hex in hexes:
		var farebe = hex.get_Color()
		var rtfghj
		match hex.get_Color():
			"red":
				redCount += 1
			"blue":
				blueCount += 1
			"green":
				greenCount += 1
			"yellow":
				yellowCount += 1
			"white":
				whiteCount += 1
				
	match playerColor:
		"red":
			playerHitScore = redCount
		"blue":
			playerHitScore = blueCount
		"green":
			playerHitScore = greenCount 
		"yellow":
			playerHitScore = yellowCount 
			
	get_node("VBoxContainer/CenterRow/VBoxContainer/ColorScore").text = "ColorScore: " + str(playerHitScore)
	get_node("VBoxContainer/CenterRow/VBoxContainer/ColorScore").show()

func show_hit_score():
	var score = ui.get_hit_score()
	
	get_node("VBoxContainer/CenterRow/VBoxContainer/HitScore").text = "HitScore: " + str(score)
	get_node("VBoxContainer/CenterRow/VBoxContainer/HitScore").show()
