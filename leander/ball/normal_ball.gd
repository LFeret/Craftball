extends "res://leander/ball/ball.gd"

export var max_shots:int
var current_shot_count:int

var colorFirstShot = 'yellow'
var colorSecondShot = 'red'

# setzt den Player, wenn der Ball vom Spieler geworfen wurde (nicht Bot)
var player_ball

func _ready():
	bouncing_count = 3
	
# Player
func set_player(playerObject):
	player_ball = playerObject


func _on_ball_body_entered(body):	
	# Painting Floor Stuff
	if body.get_type() == 'HexTile':
		body.paint_self(color)
	elif body.get_type() == 'ball':
		# TODO: Particle explosion!
		body.queue_free()
		self.queue_free()
	elif body.get_type() == 'Cube':
		body.count_hit()
	elif body.get_type() == 'booster':
		current_player.pick_up_booster(body.get_power_up())
		body.queue_free()
	elif body.get_type() == 'Player':
		body.hit()
		if(current_player.get_type() == "bot"):
			current_player.add_score(10)
	elif body.get_type() == 'bot':
		if player_ball != null:
			player_ball.add_score(10)
			if body.get_lifes() == 1 :
				player_ball.count_destroyed_bots()
				if player_ball.get_destroyed_bots() == 3:
					player_ball.win()
		if not is_bot_ball:
			body.hit()
	
	# Bouncing Stuff
	current_bounc_count += 1
	
	if current_bounc_count >= bouncing_count:
		
		var current_explosion = explosion.instance()
		
		var ball_position = get_global_transform().origin
		current_explosion.translate(ball_position)
		
		get_parent().get_parent().add_child(current_explosion)
		
		if is_instance_valid(self):
			self.queue_free()
	else:
		# play bounce sound
		get_node("audio").stop()
		get_node("audio").play(0)

func get_type():
	return 'ball'

func _on_ball_body_exited(body):
	pass
