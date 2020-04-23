extends Popup

var selected_menu

func change_menu_color(selected_menu):
	$Resume.color = Color.gray
	$Save_Game.color = Color.gray
	$Quit.color = Color.gray
	
	match selected_menu:
		0:
			$Resume.color = Color.greenyellow
		1:
			$Save_Game.color = Color.greenyellow
		2:
			$Quit.color = Color.greenyellow


func _input(event):
	if not visible:
		if Input.is_action_just_pressed("menu"):
			get_tree().paused = true
			selected_menu = 0
			change_menu_color(selected_menu)
			popup()
	else:
		if Input.is_action_just_pressed("menu"):
			get_tree().paused = false
			hide()
			
		elif Input.is_action_just_pressed("ui_down"):
			selected_menu = (selected_menu + 1) % 3;
			change_menu_color(selected_menu)
		elif Input.is_action_just_pressed("ui_up"):
			if selected_menu > 0:
				selected_menu = selected_menu - 1
			else:
				selected_menu = 2
			change_menu_color(selected_menu)
		elif Input.is_action_just_pressed("enter"):
			match selected_menu:
				0:
					get_tree().paused = false
					hide()
				1:
					#Save game
					$Popup.popup()
					save_game()
					yield(get_tree().create_timer(1.0), "timeout")
					$Popup.hide()
				2:
					# Quit game
					get_tree().paused = false
					get_tree().change_scene("res://TitleScreen.tscn")
	
const FILE_NAME = "res://Save/savedgame.json"
func save():
	var save_dict = {
		"score" : get_node("/root/Globals").player["score"],
		"coins" : get_node("/root/Globals").player["coins"],
		"lives" : get_node("/root/Globals").player["lives"],
		"furthest_level" : get_node("/root/Globals").player["furthest_level"],
		"current_scene" : get_node("/root/Globals").player["current_scene"],
	}
	return save_dict

func save_game():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(save()))
	file.close()
