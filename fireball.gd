extends Area2D

const SPEED = 100	#speed of the fireball movement
var velocity = Vector2()
var direction = 1	#direction of the fireball

func _ready():
	pass 

#setting the direction of the fireball
func set_fireball_direction(dir):
	direction = dir
	if (dir == -1):
		$AnimatedSprite.flip_h = true
		
func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")

#If not on the screen, the fireball will be destroyed.
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#if the fireball hits the wall, the fireball will be destroyed.
func _on_fireball_body_entered(body):
	queue_free()
	
#If the fireball hits the enemy, the fireball is destroyed.
func _on_fireball_area_entered(area):
	if "fireball" in area.name:
		direction = direction
	else:
		queue_free()
