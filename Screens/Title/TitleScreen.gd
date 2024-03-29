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

#When Play pressed, stage changing is delegated to the level screen
func _on_Play_pressed():
	get_tree().change_scene("res://Screens/Level/LevelScreen.tscn")

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

func _on_12_pressed():
	Pick_Level("1-2")
		
func _on_13_pressed():
	Pick_Level("1-3")
		
func _on_14_pressed():
	Pick_Level("1-4")

func _on_21_pressed():
	Pick_Level("2-1")

func _on_42_pressed():
	Pick_Level("4-2")

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
		
func Pick_Level(level):
	var x = get_node("/root/Globals").player["furthest_level"]
	var can_level_skip = get_node("/root/Globals").level_skip
	if x == level or can_level_skip:
		get_node("/root/Globals").player["current_scene"] = level
		$Popup.popup()
		$Popup/ColorRect/Label.text = "Loading level: " + level + "..."
		$PopupMenu2.hide()
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()
	else:
		$Popup.popup()
		$Popup/ColorRect/Label.text = "Level not available"
		yield(get_tree().create_timer(1.0), "timeout")
		$Popup.hide()
