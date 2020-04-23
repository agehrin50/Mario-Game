extends TileMap

var _tileset
onready var path = get_node("/root/Globals").path

func _ready():
	setMap()

#setMap auto-generates the level based on CSV file provided
func setMap():
	_tileset = get_tileset() #we store the mario_tiles tileset
	var mainData = [] #this array stores lines from the csv file
	var tile_pos = Vector2() #stores x, y coordinates of the tile
	var tile_type = ""
	var file = File.new() #file streaming object

	#this block performs the file streaming
	file.open(path, file.READ)
	while !file.eof_reached():
		mainData.append(Array(file.get_csv_line()))
	file.close()

	#adjusts array of data and variables to allow for iteration
	mainData.pop_back()
	var numRows = mainData.size()
	var numCols = mainData[0].size()
	
	#iterates over the 2-D array and checks for what type of tile is encountered based on encoding from csv file
	#after check is performed, generates a block within stageOne at tile_pos
	for i in range(numRows-1, 0, -1):
		for j in numCols:
			if(mainData[i][j] == 'a'): #Stone - color 1
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite13"))
				
			if(mainData[i][j] == 'b'): #block - color 1
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite19"))
				
			if(mainData[i][j] == 'c'): #Brick - color 1
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite6"))
				
			if(mainData[i][j] == 'd'): #Multi-coin - color 1
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite26"))
				
			if(mainData[i][j] == 'e'): #Power Up - c1
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite27"))
				
			if(mainData[i][j] == 'f'): #star - c1
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite28"))
				
			if(mainData[i][j] == 'g'): #1up - c1
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite29"))
				
			if(mainData[i][j] == 'h'): #Dead Box - c1
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite4"))
				
			if(mainData[i][j] == 'i'): #Vine - c1
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite5"))
				
			if(mainData[i][j] == 'j'):
				print("Stone - color 2")
				
			if(mainData[i][j] == 'k'):
				print("Block - color 2")
				
			if(mainData[i][j] == 'l'):
				print("Brick - color 2")
				
			if(mainData[i][j] == 'm'):
				print("multi-coin box - c2")
				
			if(mainData[i][j] == 'n'):
				print("Power Up - c2")
				
			if(mainData[i][j] == 'o'):
				print("star - c2")
				
			if(mainData[i][j] == 'p'):
				print("1up - c2")
				
			if(mainData[i][j] == 'q'):
				print("Dead Box - c2")
				
			if(mainData[i][j] == 'r'):
				print("Vine - c2")
				
			if(mainData[i][j] == 's'):
				print("Stone - color 3")
				
			if(mainData[i][j] == 't'):
				print("Stone - color 3")
				
			if(mainData[i][j] == 'u'):
				print("Brick - color 3")
				
			if(mainData[i][j] == 'v'):
				print("multi-coin box - c3")
				
			if(mainData[i][j] == 'w'):
				print("Power Up - c3")
				
			if(mainData[i][j] == 'x'):
				print("star - c3")
				
			if(mainData[i][j] == 'y'):
				print("1up - c3")
				
			if(mainData[i][j] == 'z'):
				print("Dead Box - c3")
				
			if(mainData[i][j] == '{'):
				print("Vine - c3")
				
			if(mainData[i][j] == '|'):
				print("Hidden Level Separator")	
				
			if(mainData[i][j] == '~'): #Flagpole
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite20"))
				
			if(mainData[i][j] == "^"): #flag
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite22"))
				
			if(mainData[i][j] == '_'): #blank
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite33"))
				
			if(mainData[i][j] == '0'):
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite34"))
				
			if(mainData[i][j] == '1'):
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite35"))
				
			if(mainData[i][j] == '2'):
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite36"))
				
			if(mainData[i][j] == '3'):
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite37"))
				
			if(mainData[i][j] == '4'):
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite38"))
				
			if(mainData[i][j] == '@'):
				print("Dead Box")
				
			if(mainData[i][j] == 'A'): #? - Single Coin Box
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite"))
				
			if(mainData[i][j] == 'B'): #? - Power Up
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite23"))
				
			if(mainData[i][j] == 'C'): #? - Star
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite24"))
				
			if(mainData[i][j] == 'D'): #? - 1up
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite25"))
				
			if(mainData[i][j] == 'E'): #Coin
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite12"))
				
			if(mainData[i][j] == 'F'): #hidden PowerUp
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite30"))
				
			if(mainData[i][j] == 'G'): #hidden Star
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite31"))
				
			if(mainData[i][j] == 'H'): #Hidden 1up
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite32"))
				
			if(mainData[i][j] == 'I'):
				print("Platform - Falling")
				
			if(mainData[i][j] == 'J'):
				print("Platform - Drops")
				
			if(mainData[i][j] == 'K'):
				print("Platform - Scrolling Up")
				
			if(mainData[i][j] == 'L'):
				print("Platform - Scrolling Down")
				
			if(mainData[i][j] == 'M'):
				print("Platform U/D")
				
			if(mainData[i][j] == 'N'):
				print("Platform R/L")
				
			if(mainData[i][j] == 'O'):
				print("Fire Floor")
				
			if(mainData[i][j] == 'P'): #Pipe
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite10"))
				
			if(mainData[i][j] == 'Q'):
				print("Pipe Jump Out")
				
			if(mainData[i][j] == 'R'): #Pipe Jump Back
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite21"))
				
			if(mainData[i][j] == 'S'):
				print("Side Pipe")
				
			if(mainData[i][j] == 'T'):
				print("Side Pipe Jump Out")
				
			if(mainData[i][j] == 'U'):
				print("Side Pipe Jump Back")
				
			if(mainData[i][j] == 'W'):
				print("Checkpoint")
				
			if(mainData[i][j] == 'X'):
				print("Reentry Point for cloud world")
				
			if(mainData[i][j] == 'Y'):
				print("Reentry Fire Box - clockwise")
				
			if(mainData[i][j] == 'Z'):
				print("Rotating Fire Box - clockwise")
	return mainData
