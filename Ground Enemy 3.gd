extends KinematicBody2D

const SPEED = 30	#Movement speed
const GRAVITY = 10		#Force of gravity
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://fireball.tscn")		#Referencing the fireball
var on_ground = false		#Checking if on the ground
var velocity = Vector2()
var direction = 1		#Checking the dirrection
var stunned = 1			#Checking of stunned
var falling = 0		#Checking of falling
var timer	#Used to determine how long the enemy will be in the stunned state.

func _on_Ground_Enemy_3_ready():
	$AnimatedSprite.play("run")
	$AnimatedSprite.flip_h = true

#Initializing the timer	
func _init():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5
	timer.connect("timeout", self, "_timeout")
	
#When the timer runs out the players go back to the running state
func _timeout():
	stunned = 1
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

	#Determening on what tile the enemy is. This is needed for Mario to be able
	#to kill the enemy when he hits the same block from hte bottom.
	for i in range(get_slide_count()):
		collision = get_slide_collision(i)
					
		if collision.collider is TileMap:
			get_node("/root/Globals").enemy3_tile_pos = collision.collider.world_to_map(position)
			get_node("/root/Globals").enemy3_tile_pos -= collision.normal
		
	#If Mario is hitting the same block the enemy is on, the enemy is going to die.	
	if get_node("/root/Globals").enemy3_tile_pos == get_node("/root/Globals").tile_pos and get_node("/root/Globals").damage == 0:
		queue_free()

#Enemy dies when gets hit from the top by Mario.
func _on_StompDetector_body_entered(body):
	if "player" in body.name:
		if stunned == 1:
			stunned = 0
			$AnimatedSprite.play("stunned")
			timer.start()

#Collisions on the side of the enemy
func _on_KillDetector_area_entered(area):
	if get_node("/root/Globals").invincible == 0:
		if "enemyAttack" or "fireball" in area.name:
			direction = direction
		else:
			if direction == -1:
				$AnimatedSprite.flip_h = true
				direction = 1
			else:
				$AnimatedSprite.flip_h = false
				direction = -1
	else:
		if "DeathDetector" in area.name:
			queue_free()

func _on_KillDetector_body_entered(body):
	if direction == -1:
		$AnimatedSprite.flip_h = true
		direction = 1
	else:
		$AnimatedSprite.flip_h = false
		direction = -1
		
