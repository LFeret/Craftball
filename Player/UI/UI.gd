extends Control

onready var healthBar : TextureProgress = get_node("HealthBar")
onready var scoreText : Label = get_node("Score")
var hitScore
var greenBot: int = 0
var redBot: int = 0
var blueBot: int = 0
var yellowBot: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_health_bar (curHp, maxHp):
 
	healthBar.max_value = maxHp
	healthBar.value = curHp
 
func update_score_text (score):
	hitScore = score
	scoreText.text = "Hitscore: " + str(score)
	
func get_hit_score():
	return hitScore
	
func update_bot_score(score, color):
	match color:
				"red":
					redBot += 10
				"blue":
					blueBot += 10
				"green":
					greenBot += 10
				"yellow":
					yellowBot += 10

func get_bot_score(color):
	match color:
				"red":
					return redBot
				"blue":
					return blueBot
				"green":
					return greenBot
				"yellow":
					return yellowBot
