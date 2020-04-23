extends KinematicBody2D
const SPEED = 60 #Mario's walking speed
const GRAVITY = 10	#Force of Gravity
const JUMP_POWER = -225		
const FLOOR = Vector2(0,-1)		#Used to calculate velocity 
const FIREBALL = preload("res://fireball.tscn")		#Refferencing the fireball scene
const BRICK_PARTICLE = preload("res://brickParticle.tscn") #Referencing the brick particle scene
var on_ground = false		#Checking if Mario is on the ground
var velocity = Vector2()	
var direction = 1	#Checking the direction Mario is moving to 
var jump_timer = 0		#Used to increase the jump power of Mario when holding the up arrow
var sprint_timer = 0 #Used to increase the speed of Mario when holding the down arrow
var health_level = 1	#Increases when Mario gets mashroom and decreases accordingly
var damage = 0  # Invincibility after getting hit
var timer
var hits_left  #used for multi-coin block to randomize how many hits you get


## Picks where player comes out of pipe
func exit_pipe():
	get_node("/root/Globals").in_pipe = 0
	var scene = get_node("/root/Globals").player["current_scene"]
	var stage_in = get_node("/root/Globals").pipe[0]
	var pipe_number = get_node("/root/Globals").pipe[1]

	if scene == "1-1":
		# pipe 1: (209, 173)  |--|  (226, 173)
		# pipe 2: (449, 173)  |--|  (466, 173)
		# pipe 3: (644, 173)  |--|  (660, 173)
		if pipe_number == 1:
			global_position = Vector2(228, 173)
		elif pipe_number == 2:
			global_position = Vector2(468, 173)
		else:
			global_position = Vector2(660, 173)
	if scene == "2-1":
		print(get_node("/root/Globals").pipe)
		# pipe 1: (464, 143)  |--|  (478, 143)
		# pipe 2: (780, 143)  |--|  (795, 143)
		# pipe 2: (1048, 143)  |--|  (1066, 143)
		if pipe_number == 1:
			global_position = Vector2(480, 143)
		elif pipe_number == 2:
			global_position = Vector2(797, 143)
		else:
			global_position = Vector2(1066, 143)

#Initializing the timer
func _init():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 10
	timer.connect("timeout", self, "_timeout")

#Time used for the invinsibility of Mario when pick up the red mushroom or colides 
#with an enemy
func _timeout():
	get_node("/root/Globals").invincible = 0
	get_node("/root/Globals").damage = 0
	timer.wait_time = 10
	timer.stop()

func _ready():
	if get_node("/root/Globals").in_pipe:
		exit_pipe()

	#sets initial label values upon start of level
	$CanvasLayer/HBoxContainer/Time/Current_Time.text = str(get_node("/root/Globals").counter)
	$CanvasLayer/HBoxContainer/World/Current_World.text = get_node("/root/Globals").player["current_scene"]
	$CanvasLayer/HBoxContainer/Lives/Current_Lives.text = str(get_node("/root/Globals").player["lives"])
	$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
	$CanvasLayer/HBoxContainer/Coins/Current_Coins.text = str(get_node("/root/Globals").player["coins"])
	randomize() #seeds random number generator
	hits_left = randi() % 10 +  5 #sets the random variable

		#Disabling hitboxes of big Mario
	get_node("DeathDetector_level_up").set_collision_mask(0)
	get_node("DeathDetector_level_up").set_collision_layer(0)

## Sends the player to a pipe from another level
func pipe_level():
	get_node("/root/Globals").in_pipe = 1
	get_node("BodyCol").disabled = true
	var x = get_node("/root/Globals").player["current_scene"]
	var pipe_number

	if x == "1-1":
		get_node("/root/Globals").player["furthest_level"] = "2-1"
		get_node("/root/Globals").player["current_scene"] = "2-1"
		get_node("/root/Globals").path = "res://level2-1.csv"
		# pipe 1: (209, 173)  |--|  (226, 173)
		# pipe 2: (449, 173)  |--|  (466, 173)
		# pipe 3: (644, 173)  |--|  (660, 173)
		if position.x > 209 and position.x < 226:
			pipe_number = 3
		elif position.x > 449 and position.x < 466:
			pipe_number = 3
		elif position.x > 644 and position.x < 660:
			pipe_number = 3
		get_node("/root/Globals").pipe = ["1-1", pipe_number]
		print(get_node("/root/Globals").pipe)
	elif x == "2-1":
		get_node("/root/Globals").player["furthest_level"] = "1-1"
		get_node("/root/Globals").player["current_scene"] = "1-1"
		get_node("/root/Globals").path = "res://level_one.csv"
		# pipe 1: (464, 143)  |--|  (478, 143)
		# pipe 2: (780, 143)  |--|  (795, 143)
		# pipe 2: (1048, 143)  |--|  (1066, 143)
		if position.x > 464 and position.x < 478:
			pipe_number = 1
		elif position.x > 780 and position.x < 795:
			pipe_number = 1
		elif position.x > 1048 and position.x < 1066:
			pipe_number = 1
		get_node("/root/Globals").pipe = ["2-1", pipe_number]

	get_tree().change_scene("res://StageOne.tscn")

## called on player input
func _input(event):
	var tilemap = get_node("../mario_tiles")
	var tilemap_position = (global_position/tilemap.cell_size).floor()

	# if attempting to go through pipe
	if event.is_action_pressed("ui_down"):
		# check if tile below is "pipe top" which is 32 on our tilemap
		if tilemap.get_cell(tilemap_position.x, tilemap_position.y+1) == 32:
			pipe_level()

#Used to run Mario
func _physics_process(delta):
		
	jump_timer += 1
	if Input.is_action_pressed("ui_right"):
		if 	direction == -1:
			sprint_timer = 0
		direction = 1
		if !Input.is_action_pressed("ui_down"):
			velocity.x = SPEED
			sprint_timer = 0
		elif sprint_timer < 90:
			velocity.x = SPEED + (SPEED*sprint_timer)/90
			sprint_timer += 1
		if(health_level == 1):
			$AnimatedSprite.play("run")
			$LevelUpAnimatedSprite.play("disabled")
		elif(health_level == 2):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("RUN_level_up")
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
		$AnimatedSprite.flip_h = false
		$LevelUpAnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		if 	direction == 1:
			sprint_timer = 0
		direction = -1
		if !Input.is_action_pressed("ui_down"):
			velocity.x = -SPEED
			sprint_timer = 0
		elif sprint_timer < 90:
			velocity.x = -SPEED - (SPEED*sprint_timer)/90
			sprint_timer += 1
		$AnimatedSprite.flip_h = true
		$LevelUpAnimatedSprite.flip_h = true
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
		if(health_level == 1):
			$AnimatedSprite.play("run")
			$LevelUpAnimatedSprite.play("disabled")
		elif(health_level == 2):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("RUN_level_up")
	else:
		velocity.x = 0
		if on_ground:
			if(health_level == 1):
				$AnimatedSprite.play("idle")
				$LevelUpAnimatedSprite.play("disabled")
			elif(health_level == 2):
				$AnimatedSprite.play("disabled")
				$LevelUpAnimatedSprite.play("IDLE_level_up")
			
	#jumping 
	if Input.is_action_pressed("ui_up") and jump_timer < 90:
		if Input.is_action_pressed("ui_up") and on_ground:
			var sfx = "jumping_small"
			$AudioStreamPlayer2D.playSound(sfx)
		velocity.y = JUMP_POWER - (jump_timer*JUMP_POWER)/90
		on_ground = false
		jump_timer += 1
	elif on_ground == false:
		jump_timer = 90
	else:
		jump_timer = 0
	#fireball
	if Input.is_action_just_pressed("ui_down"):
		var sfx = "fireball"
		$AudioStreamPlayer2D.playSound(sfx)
		var fireball = FIREBALL.instance()
		if sign($Position2D.position.x) == 1:
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		get_parent().add_child(fireball)
		if direction == 1:
			fireball.position = $Position2D.global_position
		else:
			fireball.position.x = $Position2D.global_position.x - 10
			fireball.position.y = $Position2D.global_position.y
	velocity.y += GRAVITY 
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
		if velocity.y < 0:
			if(health_level == 1):
				$AnimatedSprite.play("jump")
				$LevelUpAnimatedSprite.play("disabled")
			elif(health_level == 2):
				$AnimatedSprite.play("disabled")
				$LevelUpAnimatedSprite.play("JUMP_level_up")
		else:
			if(health_level == 1):
				$AnimatedSprite.play("fall")
				$LevelUpAnimatedSprite.play("disabled")
			elif(health_level == 2):
				$AnimatedSprite.play("disabled")
				$LevelUpAnimatedSprite.play("FALL_level_up")
	
	#If Mario falls off of the stage, he will die.		
	if position.y > 240:
		get_node("BodyCol").disabled = true
		queue_free()
		if get_node("/root/Globals").player["lives"] > 0:
			get_node("/root/Globals").player["lives"] -=1
			get_tree().reload_current_scene()
		else:
			get_node("/root/Globals").player["lives"] = 3
			get_tree().change_scene("GameOver.tscn")
	
	if get_node("/root/Globals").counter <= 0:
		get_tree().paused = true
		health_level -=1
		get_node("BodyCol").disabled = true
		MusicController.stop()
		$AnimatedSprite.play("death")
		var sfx = "mario_dies"
		$AudioStreamPlayer2D.playSound(sfx)
		yield(get_tree().create_timer(3.0), "timeout")
		get_tree().paused = false
		if get_node("/root/Globals").player["lives"] > 0:
			get_tree().reload_current_scene()
			get_node("/root/Globals").player["lives"] -=1 
		else:
			get_tree().change_scene("res://GameOver.tscn")
			
		
	velocity = move_and_slide(velocity, FLOOR)
	
	#code to deal with block-player interactions
	var tile_id # position of tile
	var collision #collision info
	var tile_name #the name of the tile within the tile set
	var new_id #block changes based on case
	var item #if there is an item associated with a case, item type is stored here
	var item_tile_pos #position of the item
	var item_collision 
	
	
	if on_ground == false:
		get_node("/root/Globals").tile_pos = Vector2(0,0)
	
	#iterate over list of collisions that happen at each frame
	for i in range(get_slide_count()):
		collision = get_slide_collision(i) #info about collision is stored in collision var
					
		#check to make sure player is colliding with a tile from tile map
		if collision.collider is TileMap:
			get_node("/root/Globals").tile_pos = collision.collider.world_to_map(position)
			get_node("/root/Globals").tile_pos -= collision.normal
			tile_id = collision.collider.get_cellv(get_node("/root/Globals").tile_pos)
			tile_name = collision.collider.tile_set.tile_get_name(tile_id)

			#if some enemy is colliding with the same block kill the enemy
			#for each case below, all applicable labels and counters must be updated
			#additionally, sound effects (sfx) will be played on a separate audio channel than the background music

			if(tile_name == "Sprite" and Input.is_action_pressed("ui_up")): #? block - coin
				get_node("/root/Globals").player["coins"] += 1
				get_node("/root/Globals").player["score"] += 200
				if(get_node("/root/Globals").player["coins"] == 100):
					get_node("/root/Globals").player["coins"] = 0
					get_node("/root/Globals").player["lives"] += 1
				$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
				$CanvasLayer/HBoxContainer/Coins/Current_Coins.text = str(get_node("/root/Globals").player["coins"])
				$CanvasLayer/HBoxContainer/Lives/Current_Lives.text = str(get_node("/root/Globals").player["lives"])
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite12")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "coin"
				$AudioStreamPlayer2D.playSound(sfx)
				yield(get_tree().create_timer(0.25), "timeout")
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item)
			
			
				
			if(tile_name == "Sprite12"): # coin
				get_node("/root/Globals").player["coins"] += 1
				get_node("/root/Globals").player["score"] += 200
				if(get_node("/root/Globals").player["coins"]== 100):
					get_node("/root/Globals").player["coins"] = 0
					get_node("/root/Globals").player["lives"] += 1
				$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
				$CanvasLayer/HBoxContainer/Coins/Current_Coins.text = str(get_node("/root/Globals").player["coins"])
				$CanvasLayer/HBoxContainer/Lives/Current_Lives.text = str(get_node("/root/Globals").player["lives"])
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y)
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item) #block is set to empty
				var sfx = "coin"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite15"): #1up
				get_node("/root/Globals").player["lives"] += 1
				get_node("/root/Globals").player["score"] += 1000
				$CanvasLayer/HBoxContainer/Lives/Current_Lives.text = str(get_node("/root/Globals").player["lives"])
				$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y)
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item) #block is set to empty
				var sfx = "one_up"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite14"): # PowerUp
				get_node("/root/Globals").player["score"] += 1000
				#If Mario gets the mushroom while small, make him bigger
				if health_level == 1:
					get_node("BodyCol").scale.x = 1
					get_node("BodyCol").scale.y = 1
					health_level += 1
				#Disables small mario hitbox and enables big mario hitbox
				get_node("DeathDetector").set_collision_mask(0)
				get_node("DeathDetector").set_collision_layer(0)
				get_node("DeathDetector_level_up").set_collision_mask(3)
				get_node("DeathDetector_level_up").set_collision_layer(3)
				$AnimatedSprite.play("disabled")
				$LevelUpAnimatedSprite.play("IDLE_level_up")
				$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y)
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item) #block is set to empty
				var sfx = "powerup"
				$AudioStreamPlayer2D.playSound(sfx)
				
			
			if(tile_name == "Sprite18"): #star
				get_node("/root/Globals").player["score"] += 1000
				#Make Mario invincible for a period of time after getting star
				get_node("/root/Globals").invincible = 1
				timer.start()
				$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y)
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item) #block is set to empty
				#star music is longer than sfx, so background music is paused 
				#current position of background music must be stored so it can be resumed
				#after star music is done playing
				var temp = MusicController.get_playback_position()
				MusicController.stop()
				MusicController.play("res://music/star.wav")
				#this timer is to ensure that all star music plays
				yield(get_tree().create_timer(12), "timeout") 
				MusicController.play("res://music/Super_Mario_Bros_Music.ogg")
				MusicController.seek(temp)
				
				
			if(tile_name == "Sprite6" and Input.is_action_pressed("ui_up")): #brick
				if(health_level > 1): #only powered-up Mario can break bricks
					#code to create brick breaking effect
					var particleEffect = BRICK_PARTICLE.instance()
					particleEffect.get_node(".").emitting = true
					particleEffect.get_node(".").one_shot = true
					particleEffect.position.y = $Position2D.global_position.y - 20
					particleEffect.position.x = $Position2D.global_position.x + 15
					get_tree().get_root().add_child(particleEffect)
					get_node("/root/Globals").player["score"] += 50
					$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
					new_id = collision.collider.tile_set.find_tile_by_name("blank_tile") #block is set to empty
					collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
					var sfx = "break_block"
					$AudioStreamPlayer2D.playSound(sfx)

			if(tile_name == "Sprite20"): # flag middle
				var sfx = "flagpole"
				$AudioStreamPlayer2D.playSound(sfx)
				get_node("/root/Globals").player["score"] += 500
				$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
				#get_node("BodyCol").disabled = true
				#yield(get_tree().create_timer(5), "timeout")
				var x = get_node("/root/Globals").player["furthest_level"]
				if x == "1-1":
					get_node("/root/Globals").player["furthest_level"] = "2-1"
					get_node("/root/Globals").player["current_scene"] = "2-1"
					get_tree().change_scene("TitleScreen.tscn")
				elif x == "2-1":
					get_node("/root/Globals").player["furthest_level"] = "2-1"
					get_node("/root/Globals").player["current_scene"] = "2-1"
					get_tree().change_scene("TitleScreen.tscn")

			if(tile_name == "Sprite22"): # flag top
				var sfx = "flagpole"
				$AudioStreamPlayer2D.playSound(sfx)
				get_node("/root/Globals").player["score"] += 1000
				$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
				get_node("BodyCol").disabled = true
				var x = get_node("/root/Globals").player["furthest_level"]
				if x == "1-1":
					get_node("/root/Globals").player["furthest_level"] = "2-1"
					get_node("/root/Globals").player["current_scene"] = "2-1"
					get_tree().change_scene("TitleScreen.tscn")
				elif x == "2-1":
					get_node("/root/Globals").player["furthest_level"] = "2-1"
					get_node("/root/Globals").player["current_scene"] = "2-1"
					get_tree().change_scene("TitleScreen.tscn")

			if(tile_name == "Sprite23" and Input.is_action_pressed("ui_up")): #? block - PowerUp
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite14")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite24" and Input.is_action_pressed("ui_up")): #? block - star
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite18")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite25" and Input.is_action_pressed("ui_up")): #? block - 1up 
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite15")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite26" and Input.is_action_pressed("ui_up") and hits_left > 0):  #multi-coin box
				#yield(get_tree().create_timer(2), "timeout")
				#new_id = collision.collider.tile_set.find_tile_by_name("Sprite34")
				#tile_name = "Sprite34"
				#collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				get_node("/root/Globals").player["coins"] += 1
				get_node("/root/Globals").player["score"] += 200
				if(get_node("/root/Globals").player["coins"] == 100):
					get_node("/root/Globals").player["coins"] = 0
					get_node("/root/Globals").player["lives"] += 1
				$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
				$CanvasLayer/HBoxContainer/Coins/Current_Coins.text = str(get_node("/root/Globals").player["coins"])
				$CanvasLayer/HBoxContainer/Lives/Current_Lives.text = str(get_node("/root/Globals").player["lives"])
				item = collision.collider.tile_set.find_tile_by_name("Sprite12")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "coin"
				$AudioStreamPlayer2D.playSound(sfx)
				yield(get_tree().create_timer(0.25), "timeout")
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item)
				hits_left -= 1
				print(hits_left)
				
				
			if(tile_name == "Sprite26" and Input.is_action_pressed("ui_up") and hits_left <= 0):  #multi-coin box turning box into dead box
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				
			if(tile_name == "Sprite27" and Input.is_action_pressed("ui_up")):  #brick - power-up
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite14")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite28" and Input.is_action_pressed("ui_up")):  #brick - 1-up
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite15")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite29" and Input.is_action_pressed("ui_up")):  # brick -star
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite18")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
				
			if(tile_name == "Sprite30" and Input.is_action_pressed("ui_up")): #hidden power up
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite14")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
				
			if(tile_name == "Sprite31" and Input.is_action_pressed("ui_up")):  #hidden 1-up
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite15")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
			if(tile_name == "Sprite32" and Input.is_action_pressed("ui_up")):  #hidden star
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite18")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				var sfx = "powerup_appeared"
				$AudioStreamPlayer2D.playSound(sfx)
				
#Adding a jump after hitting the top of the enemy
func _on_StepDetector_area_entered(area):
	if "StompDetector" in area.name:
		var sfx = "stomp"
		$AudioStreamPlayer2D.playSound(sfx)
		velocity.y = JUMP_POWER

#Determening damage of small Mario when hit by enemy
func _on_DeathDetector_area_entered(area):
	if get_node("/root/Globals").invincible == 0:
		if get_node("/root/Globals").damage == 0:
			if health_level == 1:
				#Determening what happens when hit by a fireball
				if "fireball" in area.name:
					on_ground = on_ground
				else:
					if area.global_position.y > get_node("DeathDetector").global_position.y:
						return
					get_tree().paused = true
					health_level -=1
					get_node("BodyCol").disabled = true
					MusicController.stop()
					$AnimatedSprite.play("death")
					var sfx = "mario_dies"
					$AudioStreamPlayer2D.playSound(sfx)
					yield(get_tree().create_timer(3.0), "timeout")
					get_tree().paused = false
					if get_node("/root/Globals").player["lives"] > 0:
						get_tree().reload_current_scene()
						get_node("/root/Globals").player["lives"] -=1 
					else:
						get_tree().change_scene("res://GameOver.tscn")
					
#Determening what happens to a big Mario when gets hit by an enemy.
func _on_DeathDetector_level_up_area_entered(area):
	if get_node("/root/Globals").invincible == 0:
			if health_level == 2:
				if "KillDetector" in area.name:
					var sfx = "pipe"
					$AudioStreamPlayer2D.playSound(sfx)
					get_node("/root/Globals").damage = 1
					health_level -= 1
					timer.wait_time = 1
					timer.start()
					#Reducing the hitbox to the size of the hitbox that small Mario uses
					get_node("BodyCol").scale.x = 0.863
					get_node("BodyCol").scale.y = 0.753
					#Enabling the collision masks that small Mario uses,
					#and disabling the Big Mario collisions
					get_node("DeathDetector").set_collision_mask(3)
					get_node("DeathDetector").set_collision_layer(3)
					get_node("DeathDetector_level_up").set_collision_mask(0)
					get_node("DeathDetector_level_up").set_collision_layer(0)
					if area.global_position.y > get_node("DeathDetector").global_position.y:
						return


func _on_counter_timeout():
	get_node("/root/Globals").counter -=1
	$CanvasLayer/HBoxContainer/Time/Current_Time.text = str(get_node("/root/Globals").counter)
