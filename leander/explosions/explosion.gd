extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	$destroy.start()

func _on_destroy_timeout():
	queue_free()
