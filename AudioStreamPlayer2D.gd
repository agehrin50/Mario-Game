extends AudioStreamPlayer2D

var coin = load("res://music/coin.wav")
var one_up = load("res://music/1-up.wav")
var powerup = load("res://music/powerup.wav")
var break_block = load("res://music/breakblock.wav")
var powerup_appeared = load("res://music/powerup_appears.wav")
var fireball = load("res://music/fireball.wav")
var flagpole = load("res://music/flagpole.wav")
var jumping_small = load("res://music/jump_small.wav")
var mario_dies = load("res://music/mario_dies.wav")
var game_over = load("res://music/game_over.wav")
var stomp = load("res://music/stomp.wav")
var pipe = load("res://music/pipe.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#this audio stream player is specifically used for sound effects
#this function uses essentially a Godot switch case to set the stream based on passed parameter
func playSound(soundName):
	match(soundName):
		"coin":
			stream = coin
		"one_up":
			stream = one_up
		"powerup":
			stream = powerup
		"break_block":
			stream = break_block
		"powerup_appeared":
			stream = powerup_appeared
		"fireball":
			stream = fireball
		"flagpole":
			stream = flagpole
		"jumping_small":
			stream = jumping_small
		"mario_dies":
			stream = mario_dies
		"game_over":
			stream = game_over
		"pipe":
			stream = pipe
		"stomp":
			stream = stomp
		
	play()
	   
signal timeout

const TIME_PERIOD = 2.0 # 500ms

var time = 0

func _process(delta):
	time += delta
	if time > TIME_PERIOD:
		emit_signal("timeout")
		# Reset timer
		time = 0
