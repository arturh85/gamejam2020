extends KinematicBody2D
class_name Mob

signal removed

var speed = 100
var velocity = Vector2()
var health = 150
var max_health = 150
var health_regeneration = 1

var minimap_icon = "mob"
	
	
func _ready():
	rotation = rand_range(0, 2*PI)
	
func _process(delta):
	health = min(health + health_regeneration * delta, max_health)
	$HealthDisplay.update_healthbar(health, max_health)
	
func _physics_process(delta):
	velocity = transform.x * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal).rotated(rand_range(-PI/4, PI/4))
	rotation = velocity.angle()

sync func take_damage(amount, by_who):
	health -= amount
	$HealthDisplay.update_healthbar(health, max_health)
	if health <= 0:
		$"../CanvasLayer/Score".rpc("increase_score", by_who, 20)
		queue_free()
