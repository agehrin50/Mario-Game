extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$Play.grab_focus()
	$Quit.grab_focus()

#If user hovers over the play or Quit button, the pointer will indicate that
#on the screen	
func _physics_process(delta):
	if $Play.is_hovered() == true:
		$Play.grab_focus()
	if $Quit.is_hovered() == true:
		$Quit.grab_focus()

#When Play pressed, the scene will change and game will start
func _on_Play_pressed():
	if get_node("/root/Globals").player["current_scene"] == "1-1":
		get_node("/root/Globals").path = "res://level_one.csv"
	if get_node("/root/Globals").player["current_scene"] == "2-1":
		get_node("/root/Globals").path = "res://level2-1.csv"
	if get_node("/root/Globals").player["current_scene"] == "1-2":
		get_node("/root/Globals").path = "res://level1-2.csv"
	if get_node("/root/Globals").player["current_scene"] == "1-3":
		get_node("/root/Globals").path = "res://level1-3.csv"
	if get_node("/root/Globals").player["current_scene"] == "1-4":
		get_node("/root/Globals").path = "res://level1-4.csv"
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
	if get_node("/root/Globals").level_skip:
		get_node("/root/Globals").player["furthest_level"] = "4-2"

func _on_12_pressed():
	var x = get_node("/root/Globals").player["furthest_level"]
	if x == "1-2" or x == "4-2":
		get_node("/root/Globals").player["current_scene"] = "1-2"
		$Popup.popup()
		$Popup/ColorRect/Label.text = "Loading level: 1-2..."
		$PopupMenu2.hide()
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()
	else:
		$Popup.popup()
		$Popup/ColorRect/Label.text = "Level not available"
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()

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


func _on_block_secret_pressed():
	$secret_menu.popup()
	get_node("secret_menu/LineEdit").clear() #resets user input box
	get_node("secret_menu/LineEdit").set_global_position(Vector2(10,15)) #position user input box

func _on_LineEdit_text_entered(new_text):
	if new_text == "b178669": #cheat code enabled
		get_node("/root/Globals").luigi = true
		$Popup.popup()
		$Popup/ColorRect/Label.text = "LUIGI TIME"
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()
		$secret_menu.hide()
	elif new_text == "lemon": #level select cheat code
		get_node("/root/Globals").level_skip = true
		$Popup.popup()
		$Popup/ColorRect/Label.text = "LEVEL SELECT"
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()
		$secret_menu.hide()
	else:
		$Popup.popup()
		$Popup/ColorRect/Label.text = "INVALID CODE"
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()
		$secret_menu.hide()


func _on_14_pressed():
	var x = get_node("/root/Globals").player["furthest_level"]
	if x == "1-4" or x == "4-2":
		get_node("/root/Globals").player["current_scene"] = "1-4"
		$Popup.popup()
		$Popup/ColorRect/Label.text = "Loading level: 1-4..."
		$PopupMenu2.hide()
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()
	else:
		$Popup.popup()
		$Popup/ColorRect/Label.text = "Level not available"
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()


func _on_13_pressed():
	var x = get_node("/root/Globals").player["furthest_level"]
	if x == "1-3" or x == "4-2":
		get_node("/root/Globals").player["current_scene"] = "1-3"
		$Popup.popup()
		$Popup/ColorRect/Label.text = "Loading level: 1-3..."
		$PopupMenu2.hide()
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()
	else:
		$Popup.popup()
		$Popup/ColorRect/Label.text = "Level not available"
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()
