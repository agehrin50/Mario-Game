extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
	$MarginContainer/HBoxContainer/Coins/Current_Coins.text = str(get_node("/root/Globals").player["coins"])
	$MarginContainer/HBoxContainer/World/Current_World.text = get_node("/root/Globals").player["current_scene"]
	$MarginContainer/HBoxContainer/Time/Current_Time.text = str(get_node("/root/Globals").counter)
	if get_node("/root/Globals").loaded == true:
		get_node("/root/Globals").load()
	else:
		get_node("/root/Globals").player["score"] = 0
		get_node("/root/Globals").player["coins"] = 0
		get_node("/root/Globals").player["current_scene"] = "1-1"
		get_node("/root/Globals").player["furthest_scene"] = "1-1"
		get_node("/root/Globals").player["lives"] = 3
		
	var sfx = "game_over"
	$AudioStreamPlayer2D.playSound(sfx)
	yield(get_tree().create_timer(6.0), "timeout")
	get_tree().change_scene("res://TitleScreen.tscn")
