extends Node2D

onready var map = get_node("mario_tiles")

var enemy0 = preload("res://Ground Enemy.tscn") #load enemy 0
var enemy1 = preload("res://Ground Enemy 2.tscn") #load enemy 1
var enemy2 = preload("res://Flying Enemy.tscn") #load enemy 2
var enemy3 = preload("res://Ground Enemy 3.tscn") #load enemy 3
var enemy4 = preload("res://Ground Enemy 4.tscn") #load enemy 4

func _ready():
	#Playing the Mario Background Music
	MusicController.play("res://music/Super_Mario_Bros_Music.ogg")
	#Represents the end of the level for camara purposes
	var right_limit =  calculate_x_bounds() -3 #calculates right bound plus 3 tiles of error
	get_node("player/Camera2D").limit_right = right_limit * 16 #adjusts camera window based on calculated bound
	#the bound is multiplied by 16 because of block width in pixels
	
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
	
#Stop the music when the level ends
func _on_StageOne_tree_exited():
	MusicController.stop()

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
