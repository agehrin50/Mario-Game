extends Node2D

onready var _player = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Calling this function will load the given track, and play it
func play(track_url : String):
	var track = load(track_url)
	_player.stream = track
	_player.play()

func stop():
	_player.stop()

#helper function to help store a position within the track
func get_playback_position():
	return _player.get_playback_position()

#sets track posiiton to the time_pasued	
func seek(time_paused):
	_player.seek(time_paused)
