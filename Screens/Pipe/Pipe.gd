extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://World.tscn")
