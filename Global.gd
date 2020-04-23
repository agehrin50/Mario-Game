extends Node
var current_scene
var invincible = 0		#Checking if Mario is invincible
var damage = 0  #Checking if mario is invincible after getting hit by enemy
var tile_pos = Vector2(0,0)#keeps the position of the tile the player colided with
var enemy1_tile_pos = Vector2(1,1) #keeps the position of the tile the enemy 1 colided with
var enemy2_tile_pos = Vector2(2,2) #keeps the position of the tile the enemy 2 colided with
var enemy3_tile_pos = Vector2(3,3) #keeps the position of the tile the enemy 3 colided with
var enemy4_tile_pos = Vector2(4,4) #keeps the position of the tile the enemy 4 colided with
var enemy5_tile_pos = Vector2(5,5) #keeps the position of the tile the flying enemy colided with
var counter = 300	#Counter for level's time limit
var loaded = false
var path = "res://level2-1.csv"
var in_pipe = 0  # check if mario is coming out of a pipe
var pipe = [0, 0]  # tells which pipe mario went down (stage, pipe#)

var player = {
	"coins": 0,
	"current_scene": "1-1",
	"furthest_level": "2-1",
	"lives": 3,
	"score": 0,
}

const FILE_NAME = "res://Save/savedgame.json"
func load():
	var file = File.new()
	file.open(FILE_NAME, File.READ)
	var text = file.get_as_text()
	var data = JSON.parse(text)
	player = data.result
	file.close()
