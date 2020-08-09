extends Spatial

var current_type = null
var current_player = null
var current_timeout = null
var current_time = 0


func _ready():
	pass

func setup_timer(timeout, type, player):
	current_type = type
	current_player = player
	current_timeout = timeout
	$Timer.autostart = true
	$Timer.start()

func _on_Timer_timeout():
	print('timeout')
	current_time += 1
	
	if current_time > current_timeout:
		match current_type:
			'ball':
				current_player.current_ball_type = 'normal_ball'
		
		queue_free()
	else:
		var minute_formatted = format_time(current_time)
		$Viewport/Control/Panel/Label.text = minute_formatted

func format_time(seconds):
	var minutes = 0 
	while seconds > 60:
		minutes += 1
		seconds -= 60
	
	return str(minutes) + ':' + str(seconds)
