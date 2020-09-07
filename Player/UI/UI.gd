extends Control

onready var healthBar : TextureProgress = get_node("HealthBar")
onready var scoreText : Label = get_node("Score")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_health_bar (curHp, maxHp):
 
	healthBar.max_value = maxHp
	healthBar.value = curHp
 
func update_score_text (score):
 
	scoreText.text = "Hitscore: " + str(score)
