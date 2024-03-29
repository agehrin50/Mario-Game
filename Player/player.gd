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
var health_level = 1	#Increases when Mario gets mushroom and decreases accordingly
var damage = 0  # Invincibility after getting hit
var timer
var hits_left  #used for multi-coin block to randomize how many hits you get
var luigi = preload("res://Player/luigi.tres")
var luigi_big = preload("res://Player/luigi_big.tres")
var stunableCharacters = ["Koopa_Troopa", "Beetle", "Koopa_Paratroopa", "Hammer_Bro"]

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
	get_node("/root/Globals").health_level = health_level
	
	if get_node("/root/Globals").luigi: #set luigi skin
		$AnimatedSprite.set_sprite_frames(luigi)
		$AnimatedSprite.scale = Vector2(2,2)
		$LevelUpAnimatedSprite.set_sprite_frames(luigi_big)
		$LevelUpAnimatedSprite.scale = Vector2(1.5,1.5)
		
	get_node("/root/Globals").counter = 300

	#sets initial label values upon start of level
	$CanvasLayer/HBoxContainer/Time/Current_Time.text = str(get_node("/root/Globals").counter)
	$CanvasLayer/HBoxContainer/World/Current_World.text = get_node("/root/Globals").player["current_scene"]
	update_scores()
	randomize() #seeds random number generator
	hits_left = randi() % 10 +  5 #sets the random variable

	#Disabling hitboxes of big Mario
	get_node("DeathDetector_level_up").set_collision_mask(0)
	get_node("DeathDetector_level_up").set_collision_layer(0)

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
		set_sprite_animation("run")
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
		$AnimatedSprite.flip_h = false
		$LevelUpAnimatedSprite.flip_h = false
		$FireAnimatedSprite.flip_h = false
		$StarAnimatedSprite.flip_h = false
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
		$FireAnimatedSprite.flip_h = true
		$StarAnimatedSprite.flip_h = true
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
		set_sprite_animation("run")
	else:
		velocity.x = 0
		if on_ground:
			set_sprite_animation("idle")
			
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
	if Input.is_action_just_pressed("ui_down") and health_level == 3:
		$AudioStreamPlayer2D.playSound("fireball")
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
			set_sprite_animation("jump")
		else:
			set_sprite_animation("fall")
	
	#If Mario falls off of the stage, he will die.	
	if position.y > 240:
		handle_death()
	
	#time runs out
	if get_node("/root/Globals").counter <= 0:
		handle_death()
		
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
		if collision != null and collision.collider is TileMap:
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
				update_scores()	
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				item = collision.collider.tile_set.find_tile_by_name("Sprite12")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				collision.collider.set_cellv(item_tile_pos, item)
				yield(get_tree().create_timer(0.25), "timeout")
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item)
				$AudioStreamPlayer2D.playSound("coin")
				
			if(tile_name == "Sprite17" or tile_name == "Sprite49"): #fire power-up
				update_health_level(3)
				get_node("/root/Globals").player["score"] += 1000
				$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
				handle_block_interaction(collision, "blank_tile")
				$AudioStreamPlayer2D.playSound("powerup")
								
			if(tile_name == "Sprite12"): # coin
				get_node("/root/Globals").player["coins"] += 1
				get_node("/root/Globals").player["score"] += 200
				if(get_node("/root/Globals").player["coins"]== 100):
					get_node("/root/Globals").player["coins"] = 0
					get_node("/root/Globals").player["lives"] += 1
				update_scores()
				handle_block_interaction(collision, "blank_tile")
				$AudioStreamPlayer2D.playSound("coin")
				
			if(tile_name == "Sprite15" or tile_name == "Sprite48"): #1up
				get_node("/root/Globals").player["lives"] += 1
				get_node("/root/Globals").player["score"] += 1000
				$CanvasLayer/HBoxContainer/Lives/Current_Lives.text = str(get_node("/root/Globals").player["lives"])
				$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
				handle_block_interaction(collision, "blank_tile")
				$AudioStreamPlayer2D.playSound("one_up")
				
			if(tile_name == "Sprite14" or tile_name == "Sprite47"): # PowerUp
				get_node("/root/Globals").player["score"] += 1000
				#If Mario gets the mushroom while small, make him bigger
				if health_level == 1:
					get_node("BodyCol").scale.x = 1
					get_node("BodyCol").scale.y = 1
					update_health_level(2)
				#Disables small mario hitbox and enables big mario hitbox
				get_node("DeathDetector").set_collision_mask(0)
				get_node("DeathDetector").set_collision_layer(0)
				get_node("DeathDetector_level_up").set_collision_mask(3)
				get_node("DeathDetector_level_up").set_collision_layer(3)
				$AnimatedSprite.play("disabled")
				$LevelUpAnimatedSprite.play("IDLE_level_up")
				$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
				handle_block_interaction(collision, "blank_tile")
				$AudioStreamPlayer2D.playSound("powerup")
				
			if(tile_name == "Sprite18" or tile_name == "Sprite50"): #star
				get_node("/root/Globals").player["score"] += 1000
				#Make Mario invincible for a period of time after getting star
				get_node("/root/Globals").invincible = 1
				var temp_health = health_level
				update_health_level(4)
				timer.start()
				$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
				handle_block_interaction(collision, "blank_tile")
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
				update_health_level(temp_health)
				
				
			if((tile_name == "Sprite6" or tile_name == "Sprite39") and Input.is_action_pressed("ui_up")): #brick
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
					$AudioStreamPlayer2D.playSound("break_block")

			if(tile_name == "Sprite20"): # flag middle
				get_node("/root/Globals").player["score"] += 500
				handle_end_of_level()

			if(tile_name == "Sprite22"): # flag top
				get_node("/root/Globals").player["score"] += 1000
				handle_end_of_level()

			if(tile_name == "Sprite23" and Input.is_action_pressed("ui_up")): #? block - PowerUp
				if(health_level == 1):
					item = "Sprite14"
				else:
					item = "Sprite17"
				handle_block_replace_interaction(collision, "Sprite4", item)
				$AudioStreamPlayer2D.playSound("powerup_appeared")
				
			if(tile_name == "Sprite24" and Input.is_action_pressed("ui_up")): #? block - star
				handle_block_replace_interaction(collision, "Sprite4", "Sprite18")
				$AudioStreamPlayer2D.playSound("powerup_appeared")
				
			if(tile_name == "Sprite25" and Input.is_action_pressed("ui_up")): #? block - 1up 
				handle_block_replace_interaction(collision, "Sprite4", "Sprite15")
				$AudioStreamPlayer2D.playSound("powerup_appeared")
				
			if(tile_name == "Sprite67"): #fire 
				handle_death()
				
			if(tile_name == "Sprite26" and Input.is_action_pressed("ui_up") and hits_left > 0):  #multi-coin box
				get_node("/root/Globals").player["coins"] += 1
				get_node("/root/Globals").player["score"] += 200
				if(get_node("/root/Globals").player["coins"] == 100):
					get_node("/root/Globals").player["coins"] = 0
					get_node("/root/Globals").player["lives"] += 1
					
				update_scores()
				item = collision.collider.tile_set.find_tile_by_name("Sprite12")
				item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
				collision.collider.set_cellv(item_tile_pos, item)
				$AudioStreamPlayer2D.playSound("coin")
				yield(get_tree().create_timer(0.25), "timeout")
				item = collision.collider.tile_set.find_tile_by_name("blank_tile")
				collision.collider.set_cellv(item_tile_pos, item)
				hits_left -= 1
				print(hits_left)
				
			if(tile_name == "Sprite26" and Input.is_action_pressed("ui_up") and hits_left <= 0):  #multi-coin box turning box into dead box
				new_id = collision.collider.tile_set.find_tile_by_name("Sprite4")
				collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
				
			if(tile_name == "Sprite27" and Input.is_action_pressed("ui_up")):  #brick - power-up
				if(health_level == 1):
					item = "Sprite14"
				else:
					item = "Sprite17"
				handle_block_replace_interaction(collision, "Sprite4", item)
				$AudioStreamPlayer2D.playSound("powerup_appeared")
				
			if(tile_name == "Sprite28" and Input.is_action_pressed("ui_up")):  #brick - 1-up
				handle_block_replace_interaction(collision, "Sprite4", "Sprite15")
				$AudioStreamPlayer2D.playSound("powerup_appeared")
				
			if(tile_name == "Sprite29" and Input.is_action_pressed("ui_up")):  # brick -star
				handle_block_replace_interaction(collision, "Sprite4", "Sprite18")
				$AudioStreamPlayer2D.playSound("powerup_appeared")
				
			if(tile_name == "Sprite30" and Input.is_action_pressed("ui_up")): #hidden power up
				if(health_level == 1):
					item = "Sprite14"
				else:
					item = "Sprite17"
				handle_block_replace_interaction(collision, "Sprite4", item)
				$AudioStreamPlayer2D.playSound("powerup_appeared")
				
			if(tile_name == "Sprite31" and Input.is_action_pressed("ui_up")):  #hidden 1-up
				handle_block_replace_interaction(collision, "Sprite4", "Sprite15")
				$AudioStreamPlayer2D.playSound("powerup_appeared")
				
			if(tile_name == "Sprite32" and Input.is_action_pressed("ui_up")):  #hidden star
				handle_block_replace_interaction(collision, "Sprite4", "Sprite18")
				$AudioStreamPlayer2D.playSound("powerup_appeared")
				
			if(tile_name == "Sprite69" and Input.is_action_pressed("ui_down")):  #player enters pipe
				handle_enter_pipe()
			if(tile_name == "Sprite70" and Input.is_action_pressed("ui_down")):  #player enters pipe
				handle_enter_pipe()
			
				
#Adding a jump after hitting the top of the enemy
func _on_StepDetector_area_entered(area):
	if "StompDetector" in area.name:
		$AudioStreamPlayer2D.playSound("stomp")
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
					
					#damage should not be taken if enemy is stunned
					var overlapping = get_node("DeathDetector").get_overlapping_areas()
					var overlappingParent = overlapping[0].get_parent()
					if (overlappingParent.get_name() in stunableCharacters):
						if overlappingParent.stunned == 0:
							return
					handle_death()
					
#Determening what happens to a big Mario when gets hit by an enemy.
func _on_DeathDetector_level_up_area_entered(area):
	if get_node("/root/Globals").invincible == 0:
			if health_level == 2:
				if "KillDetector" in area.name:
					
					#damage should not be taken if enemy is stunned
					var overlapping = get_node("DeathDetector_level_up").get_overlapping_areas()
					var overlappingParent = overlapping[0].get_parent()
					if (overlappingParent.get_name() in stunableCharacters):
						if overlappingParent.stunned == 0:
							return
							
					$AudioStreamPlayer2D.playSound("pipe")
					get_node("/root/Globals").damage = 1
					update_health_level(1)
					timer.wait_time = 1
					timer.start()
					#Reducing the hitbox to the size of the hitbox that small Mario uses
					get_node("BodyCol").scale.x = 0.8
					get_node("BodyCol").scale.y = 0.8
					get_node("DeathDetector/LeftCol").position.x = -10
					get_node("DeathDetector/RightCol").position.x = 10
					#Enabling the collision masks that small Mario uses,
					#and disabling the Big Mario collisions
					get_node("DeathDetector").set_collision_mask(3)
					get_node("DeathDetector").set_collision_layer(3)
					get_node("DeathDetector_level_up").set_collision_mask(0)
					get_node("DeathDetector_level_up").set_collision_layer(0)
					if area.global_position.y > get_node("DeathDetector").global_position.y:
						return

func update_scores():
	$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
	$CanvasLayer/HBoxContainer/Coins/Current_Coins.text = str(get_node("/root/Globals").player["coins"])
	$CanvasLayer/HBoxContainer/Lives/Current_Lives.text = str(get_node("/root/Globals").player["lives"])
	
func set_sprite_animation(state):
	if state == "idle":
		if(health_level == 1):
			$AnimatedSprite.play("idle")
			$LevelUpAnimatedSprite.play("disabled")
			$FireAnimatedSprite.play("disabled")
			$StarAnimatedSprite.play("disabled")
		elif(health_level == 2):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("IDLE_level_up")
			$FireAnimatedSprite.play("disabled")
			$StarAnimatedSprite.play("disabled")
		elif(health_level == 3):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("disabled")
			$FireAnimatedSprite.play("fire_idle")
			$StarAnimatedSprite.play("disabled")
		elif(health_level == 4):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("disabled")
			$FireAnimatedSprite.play("disabled")
			$StarAnimatedSprite.play("star_idle")
			
	elif state == "run":
		if(health_level == 1):
			$AnimatedSprite.play("run")
			$LevelUpAnimatedSprite.play("disabled")
			$FireAnimatedSprite.play("disabled")
			$StarAnimatedSprite.play("disabled")
		elif(health_level == 2):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("RUN_level_up")
			$FireAnimatedSprite.play("disabled")
			$StarAnimatedSprite.play("disabled")
		elif(health_level == 3):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("disabled")
			$FireAnimatedSprite.play("fire_run")
			$StarAnimatedSprite.play("disabled")
		elif (health_level == 4):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("disabled")
			$FireAnimatedSprite.play("disabled")
			$StarAnimatedSprite.play("star_run")
			
	elif state == "jump":
		if(health_level == 1):
			$AnimatedSprite.play("jump")
			$LevelUpAnimatedSprite.play("disabled")
			$FireAnimatedSprite.play("disabled")
			$StarAnimatedSprite.play("disabled")
		elif(health_level == 2):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("JUMP_level_up")
			$FireAnimatedSprite.play("disabled")
			$StarAnimatedSprite.play("disabled")
		elif(health_level == 3):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("disabled")
			$FireAnimatedSprite.play("fire_jump")
			$StarAnimatedSprite.play("disabled")
		elif(health_level == 4):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("disabled")
			$FireAnimatedSprite.play("disabled")
			$StarAnimatedSprite.play("star_jump")
			
	elif state == "fall":
		if(health_level == 1):
			$AnimatedSprite.play("fall")
			$LevelUpAnimatedSprite.play("disabled")
			$FireAnimatedSprite.play("disabled")
			$StarAnimatedSprite.play("disabled")
		elif(health_level == 2):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("FALL_level_up")
			$FireAnimatedSprite.play("disabled")
			$StarAnimatedSprite.play("disabled")
		elif(health_level == 3):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("disabled")
			$FireAnimatedSprite.play("fire_fall")
			$StarAnimatedSprite.play("disabled")
		elif(health_level == 4):
			$AnimatedSprite.play("disabled")
			$LevelUpAnimatedSprite.play("disabled")
			$FireAnimatedSprite.play("disabled")
			$StarAnimatedSprite.play("star_fall")

func handle_block_interaction(collision, new_block):
	var new_id = collision.collider.tile_set.find_tile_by_name(new_block)
	var item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y)
	collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)

func handle_block_replace_interaction(collision, new_block, new_item):
	var new_id = collision.collider.tile_set.find_tile_by_name(new_block)
	var item = collision.collider.tile_set.find_tile_by_name(new_item)
	var item_tile_pos = Vector2(get_node("/root/Globals").tile_pos.x, get_node("/root/Globals").tile_pos.y -1)
	collision.collider.set_cellv(get_node("/root/Globals").tile_pos, new_id)
	collision.collider.set_cellv(item_tile_pos, item)
	
func handle_death():
	get_node("BodyCol").disabled = true
	get_tree().paused = true
	MusicController.stop()
	$AnimatedSprite.play("death")
	$AudioStreamPlayer2D.playSound("mario_dies")
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().paused = false
	if get_node("/root/Globals").player["lives"] > 0:
		get_node("/root/Globals").player["lives"] -=1
		get_tree().change_scene("res://Screens/Level/LevelScreen.tscn")
	else:
		get_node("/root/Globals").player["lives"] = 3
		get_tree().change_scene("res://Screens/Game_Over/GameOver.tscn")
		
func handle_end_of_level():
	$AudioStreamPlayer2D.playSound("flagpole")
	$CanvasLayer/HBoxContainer/Score/Current_Score.text = str(get_node("/root/Globals").player["score"])
	get_node("BodyCol").disabled = true
	
	#todo: add level win animation
	var current_level = get_node("/root/Globals").player["current_scene"].split("-")
	var world = current_level[0]
	var level = current_level[1]
	level = str(int(level) + 1)
	
	if(int(level) > 4):
		level = "1"
		if(int(world) != 8):
			world = str(int(world) + 1)
		else:
			pass
			#todo: handle end of game
	
	get_node("/root/Globals").player["furthest_level"] = world + "-" + level
	get_node("/root/Globals").player["current_scene"] = world + "-" + level
	get_tree().change_scene("Screens/Level/LevelScreen.tscn")
	
func handle_enter_pipe():
	$AudioStreamPlayer2D.playSound("pipe")
	var hidden_pos = get_node("/root/Globals").hidden_area_position
	set_position(hidden_pos) 
	#get_tree().change_scene("res://Screens/Pipe/Pipe.tscn")
	
func update_health_level(health):
	health_level = health
	get_node("/root/Globals").health_level = health_level
	
#logic for the level countdown timer
func _on_counter_timeout():
	get_node("/root/Globals").counter -=1
	$CanvasLayer/HBoxContainer/Time/Current_Time.text = str(get_node("/root/Globals").counter)
	if(get_node("/root/Globals").counter == 100):
		MusicController.stop()
		MusicController.play("res://music/hurry-up.wav")
	if(get_node("/root/Globals").counter == 0):
		handle_death()
