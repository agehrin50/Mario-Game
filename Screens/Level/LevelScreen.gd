extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/Sprite/Lives.text = str(get_node("/root/Globals").player["lives"])
	$MarginContainer/Sprite/World.text = str(get_node("/root/Globals").player["current_scene"])

	var current_scene = get_node("/root/Globals").player["current_scene"]
	get_node("/root/Globals").path = "res://Levels/" + current_scene + ".csv"

	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://World.tscn")
	
