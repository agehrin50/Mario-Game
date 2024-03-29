extends KinematicBody2D

const SPEED = 30		#Movement speed of the enemy
const GRAVITY = 10		#Gravity force
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://fireball.tscn")		#Referencing the fireball
var on_ground = false		#checking if on the ground
var velocity = Vector2()
var direction = -1		#Checking the direction ov movement
var stunned = 1		#checking if in stunned state
var falling = 0		#Checking if falling
var timer #Used to determine how long the enemy will be in the stunned state.
var expired = ["Sprite4", "Sprite42", "Sprite65"]

func _on_Ground_Enemy_2_ready():
	$AnimatedSprite.play("run")

#Initializing the timer
func _init():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5
	timer.connect("timeout", self, "_timeout")

#When the timer runs out the players go back to the running state	
func _timeout():
	stunned = 1
	get_node("BodyCol").scale.y = 1
	$AnimatedSprite.play("run")
			
func _physics_process(delta):
	
	velocity.x = SPEED*direction*stunned
	velocity = move_and_slide(velocity, FLOOR) 
	velocity.y += GRAVITY
	if falling >= 60:
		if !is_on_floor():
			if direction == 1:
				$AnimatedSprite.flip_h = false
				position.x -= 1
			else:
				$AnimatedSprite.flip_h = true
				position.x += 1
			direction *= -1
	else:
		falling += 1

	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
			
	#Collision with blocks
	var tile_id
	var collision
	var tile_name
	var new_id
	var item
	var item_tile_pos
	var item_collision
	var health_level

	#Determening on what tile the enemy is. This is needed for Mario to be able
	#to kill the enemy when he hits the same block from the bottom.
	for i in range(get_slide_count()):
		collision = get_slide_collision(i)
					
		if collision.collider is TileMap:
			get_node("/root/Globals").enemy2_tile_pos = collision.collider.world_to_map(position)
			get_node("/root/Globals").enemy2_tile_pos -= collision.normal
			tile_name = collision.collider.tile_set.tile_get_name(collision.collider.get_cellv(get_node("/root/Globals").enemy3_tile_pos))
			health_level = get_node("/root/Globals").health_level
		
	#If Mario is hitting the same block the enemy is on, the enemy is going to die.	
	if get_node("/root/Globals").enemy2_tile_pos == get_node("/root/Globals").tile_pos and get_node("/root/Globals").damage == 0 and health_level > 1:
		queue_free()

#Collisions on the top of the enemy
func _on_StompDetector_body_entered(body):
	#ensure enemies don't kill or stun each other	
	if body.get_name() != "player":
		return
	
	if stunned == 0:
		if body.global_position.y > get_node("StompDetector").global_position.y:
			return
		get_node("BodyCol").disabled = true
		queue_free()
	else:
		stunned = 0
		$AnimatedSprite.play("stunned")
		get_node("BodyCol").scale.y = 0.58
		timer.start()

#Collisions on the side of the enemy
func _on_KillDetector_area_entered(area):
	if get_node("/root/Globals").invincible == 0:
		if direction == -1:
			$AnimatedSprite.flip_h = true
			direction = 1
		else:
			$AnimatedSprite.flip_h = false
			direction = -1
	else:
		if "DeathDetector" in area.name:
			queue_free()

#Collision with walls
func _on_KillDetector_body_entered(body):
	if direction == -1:
		$AnimatedSprite.flip_h = true
		direction = 1
	else:
		$AnimatedSprite.flip_h = false
		direction = -1

#Collision with the fireball
func _on_Body_area_entered(area):
	if "enemyAttack" in area.name:
		direction = direction
	elif "Body" in area.name:
		direction = direction
	else:
		queue_free()
