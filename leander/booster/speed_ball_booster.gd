extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$rotate_animation.play("rotate")


func get_type():
	return 'booster'

func get_power_up():
	return 'speed_ball'

func _on_booster_body_entered(body):
	pass # Replace with function body.


func _on_booster_body_exited(body):
	pass # Replace with function body.


func _on_timer_timeout():
	get_parent().current_booster = null
	queue_free()
