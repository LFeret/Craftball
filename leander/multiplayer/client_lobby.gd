extends Control

var networking = null

func _ready():
	networking = get_node("/root/networking")

func _on_button_connect_pressed():
	networking.initiliaze_as_client()
	get_tree().change_scene("res://World.tscn")
	queue_free()
