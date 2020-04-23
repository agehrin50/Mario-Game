extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/Play.grab_focus()
	$MarginContainer/VBoxContainer/Quit.grab_focus()

#If user hovers over the play or Quit button, the pointer will indicate that
#on the screen	
func _physics_process(delta):
	if $MarginContainer/VBoxContainer/Play.is_hovered() == true:
		$MarginContainer/VBoxContainer/Play.grab_focus()
	if $MarginContainer/VBoxContainer/Quit.is_hovered() == true:
		$MarginContainer/VBoxContainer/Quit.grab_focus()

#When Play pressed, the scene will change and game will start
func _on_Play_pressed():
	if get_node("/root/Globals").player["current_scene"] == "1-1":
		get_node("/root/Globals").path = "res://level_one.csv"
	if get_node("/root/Globals").player["current_scene"] == "2-1":
		get_node("/root/Globals").path = "res://level2-1.csv"
	#if get_node("/root/Globals").player["current_scene"] == "4-2":
	#	get_node("/root/Globals").path = "res://level4-2.csv"
	get_node("/root/Globals").counter = 300
	get_tree().change_scene("res://StageOne.tscn")

#Exiting the game if quit pressed
func _on_Quit_pressed():
	get_tree().quit()

func _on_Load_pressed():
	$PopupMenu.popup()
	
func _on_No_pressed():
	$PopupMenu.hide()
	
func _on_Yes_pressed():
	get_node("/root/Globals").loaded == true
	get_node("/root/Globals").load()
	$PopupMenu.hide()

func _on_11_pressed():
	get_node("/root/Globals").player["current_scene"] = "1-1"
	$Popup.popup()
	$Popup/ColorRect/Label.text = "Loading level: 1-1..."
	$PopupMenu2.hide()
	yield(get_tree().create_timer(1.0), "timeout")
	$Popup.hide()


func _on_Map_pressed():
	$PopupMenu2.popup()


func _on_21_pressed():
	var x = get_node("/root/Globals").player["furthest_level"]
	if x == "2-1" or x == "4-2":
		get_node("/root/Globals").player["current_scene"] = "2-1"
		$Popup.popup()
		$Popup/ColorRect/Label.text = "Loading level: 2-1..."
		$PopupMenu2.hide()
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()
	else:
		$Popup.popup()
		$Popup/ColorRect/Label.text = "Level not available"
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()


func _on_42_pressed():
	var x = get_node("/root/Globals").player["furthest_level"]
	if x == "4-2":
		get_node("/root/Globals").player["current_scene"] = "4-2"
		$Popup.popup()
		$Popup/ColorRect/Label.text = "Loading level: 4-2..."
		$PopupMenu2.hide()
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()
	else:
		$Popup.popup()
		$Popup/ColorRect/Label.text = "Level not available"
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()
