extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	$audio.stream = load("res://leander/explosions/breaking.wav")
	$audio.play(0)
	$destroy.start()

func _on_destroy_timeout():
	queue_free()
