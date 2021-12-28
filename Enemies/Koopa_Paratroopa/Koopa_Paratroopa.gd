extends KinematicBody2D

const SPEED = 30
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://fireball.tscn")
var on_ground = false
var velocity = Vector2()
var direction = 1
var dropped = 0

var timer
func _init():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5
	timer.connect("timeout", self, "_timeout")
	
func _timeout():
	direction = 1
	

func _physics_process(delta):
	velocity.x = SPEED*direction
	$AnimatedSprite.play("run")
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
			
	velocity.y += GRAVITY*dropped
	
	velocity = move_and_slide(velocity, FLOOR)



func _on_StompDetector_body_entered(body):
	if on_ground == true:
			if body.global_position.y > get_node("StompDetector").global_position.y:
				return
			get_node("BodyCol").disabled = true
			queue_free()
	else:
		dropped = 1

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


func _on_KillDetector_body_entered(body):
	if direction == -1:
		$AnimatedSprite.flip_h = true
		direction = 1
	else:
		$AnimatedSprite.flip_h = false
		direction = -1
