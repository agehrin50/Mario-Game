extends Node2D

onready var map = get_node("mario_tiles")
var music_pos

var enemy0 = preload("res://Enemies/Goomba/Goomba.tscn") #load enemy 0
var enemy1 = preload("res://Enemies/Koopa_Troopa/Koopa_Troopa.tscn") #load enemy 1
var enemy2 = preload("res://Enemies/Koopa_Paratroopa/Koopa_Paratroopa.tscn") #load enemy 2
var enemy3 = preload("res://Enemies/Beetle/Beetle.tscn") #load enemy 3
var enemy4 = preload("res://Enemies/Hammer_Bro/Hammer_Bro.tscn") #load enemy 4
var mountain_background_levels = ["1-1", "4-1",]
var black_background_levels = ["1-2", "1-4", "2-4", "3-1", "3-2", "3-3", "3-4", "4-2", "4-4",
"5-4", "6-1", "6-2", "6-3", "6-4", "7-4", "8-4"]
var sky_background_levels = ["1-3", "2-1", "2-3", "4-3", "5-1", "5-2", "5-3", "7-1",
 "7-3", "8-1", "8-2", "8-3"]
var water_background_levels = ["2-2", "7-2"]

func _ready():
	#Playing the Mario Background Music
	MusicController.play("res://music/Super_Mario_Bros_Music.ogg")
	#Represents the end of the level for camara purposes
	var right_limit =  calculate_x_bounds() -3 #calculates right bound plus 3 tiles of error
	get_node("player/Camera2D").limit_right = right_limit * 16 #adjusts camera window based on calculated bound
	#the bound is multiplied by 16 because of block width in pixels
	
	#changes background based on level
	if(get_node("/root/Globals").player["current_scene"] in black_background_levels):
		get_node("ParallaxBackground/ParallaxLayer/Sprite").texture = load("res://Mario-assets/Other/black_background.png")
		get_node("ParallaxBackground2/ParallaxLayer/Sprite").texture = load("res://Mario-assets/Other/black_background.png")
		
	if(get_node("/root/Globals").player["current_scene"] in sky_background_levels):
		get_node("ParallaxBackground/ParallaxLayer/Sprite").texture = load("res://Mario-assets/Other/Overworld_sky.png")
		get_node("ParallaxBackground2/ParallaxLayer/Sprite").texture = load("res://Mario-assets/Other/Overworld_sky.png")
	
	var ts = map.get_tileset()
	var uc = map.get_used_cells()
	for position in uc :
		var id = map.get_cell(position.x, position.y)
		var name = ts.tile_get_name(id)
		if name == "Sprite34":
			var node = enemy0.instance()
			add_child(node)
			node.set_position(Vector2(position.x *16 ,position.y *16)) #sets position of enemy in terms of pixels
			map.set_cell(position.x, position.y, -1) #this line remove the tile in TileMap
			
		if name == "Sprite35":
			var node = enemy1.instance()
			add_child(node)
			node.set_position(Vector2(position.x *16 ,position.y *16)) #sets position of enemy in terms of pixels
			map.set_cell(position.x, position.y, -1) #this line remove the tile in TileMap
			
		if name == "Sprite36":
			var node = enemy2.instance()
			add_child(node)
			node.set_position(Vector2(position.x *16 ,position.y *16)) #sets position of enemy in terms of pixels
			map.set_cell(position.x, position.y, -1) #this line remove the tile in TileMap
		
		if name == "Sprite37":
			var node = enemy3.instance()
			add_child(node)
			node.set_position(Vector2(position.x *16 ,position.y *16)) #sets position of enemy in terms of pixels
			map.set_cell(position.x, position.y, -1) #this line remove the tile in TileMap
		
		if name == "Sprite38":
			var node = enemy4.instance()
			add_child(node)
			node.set_position(Vector2(position.x *16 ,position.y *16)) #sets position of enemy in terms of pixels
			map.set_cell(position.x, position.y, -1) #this line remove the tile in TileMap
			
		if name == "Sprite66":
			var node = get_node("player")
			node.set_position(Vector2(position.x *16 ,(position.y-1) *16)) #sets position of enemy in terms of pixels
			map.set_cell(position.x, position.y, -1) #this line remove the tile in TileMap
			
		#dynamic background change
		if(name == "Sprite33" and get_node("/root/Globals").player["current_scene"] == "1-2"):
			var tile = map.tile_set.find_tile_by_name("Sprite52")
			var tile_pos = Vector2(position.x, position.y)
			map.set_cellv(tile_pos, tile) 
	
#Stop the music when the level ends
func _on_StageOne_tree_exited():
	MusicController.stop()
	
func _process(delta):
	if Input.is_action_just_pressed("pause_music") and MusicController.is_playing():
		music_pos = MusicController.get_playback_position()
		MusicController.stop()
	if Input.is_action_just_pressed("pause_music") and !MusicController.is_playing():
		MusicController.seek(music_pos)
		
#calculates how wide the level is
func calculate_x_bounds():
	var used_cells = map.get_used_cells()
	var max_x = 0
	var min_x = 0
	for position in used_cells:
		if position.x < min_x:
			min_x = int(position.x)
		elif position.x > max_x:
			max_x = int(position.x)
	return(max_x)
			
#calculates how tall the level is
func calculate_y_bounds():
	var used_cells = map.get_used_cells()
	var max_y = 0
	var min_y = 0
	for position in used_cells:
		if position.y < min_y:
			min_y = int(position.y)
		elif position.y > max_y: 
			max_y = int(position.y)
	return(max_y)
