extends RigidBody


# Called when the node enters the scene tree for the first time.
func _ready():
	$rotate_animation.play("rotate")

func get_type():
	return 'booster'

func get_power_up():
	return 'long_life_cube'

func _on_booster_body_entered(body):
	if body.get_type() == 'Player':
		body.pick_up_booster(get_power_up())
	elif body.get_type() == 'Cube':
		pass
	elif body.get_type() == 'ball':
		pass

func _on_booster_body_exited(body):
	pass # Replace with function body.


func _on_timer_timeout():
	get_parent().current_booster = null
	queue_free()
