extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/Sprite/Lives.text = str(get_node("/root/Globals").player["lives"])
	$MarginContainer/Sprite/World.text = str(get_node("/root/Globals").player["current_scene"])
	
	if get_node("/root/Globals").player["current_scene"] == "1-1":
		get_node("/root/Globals").path = "res://Levels/1-1.csv"
	if get_node("/root/Globals").player["current_scene"] == "2-1":
		get_node("/root/Globals").path = "res://Levels/2-1.csv"
	if get_node("/root/Globals").player["current_scene"] == "1-2":
		get_node("/root/Globals").path = "res://Levels/1-2.csv"

	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://World.tscn")
	
