extends KinematicBody2D
class_name Mob

signal removed

var speed = 50
var velocity = Vector2()
var health = 50
var max_health = 50

var minimap_icon = "mob"
	
	
func _ready():
	rotation = rand_range(0, 2*PI)
	
	
func _physics_process(delta):
	velocity = transform.x * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal).rotated(rand_range(-PI/4, PI/4))
	rotation = velocity.angle()

func take_damage(amount):
	health -= amount
	$HealthDisplay.update_healthbar(health)
	if health <= 0:
		queue_free()
