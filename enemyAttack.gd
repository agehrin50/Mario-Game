#the hammer that the enemy 4 is throwing

extends Area2D

const GRAVITY = 1	#force of gravity
const SPEED = 150	#speed of the movement
var velocity = Vector2()
var direction = 1	#checking the direction

func _ready():
	velocity.y = -7

#setting the direction of the movement
func set_enemyAttack_direction(dir):
	direction = dir
	if (dir == -1):
		$AnimatedSprite.flip_h = true
		
func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")
	velocity.y += GRAVITY

#if not on the screen, the hammer will disappear
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#if the hammer hits the wall, it will disappear.
func _on_enemyAttack_body_entered(body):
	if "Enemy" in body.name:
		direction = direction
	else:
		queue_free()
	
