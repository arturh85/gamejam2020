extends KinematicBody2D
class_name Mob

signal removed

var speed = 100
var velocity = Vector2()
var health = 150
var max_health = 150
var health_regeneration = 1

var minimap_icon = "mob"
var chase_player = null
var harm_player = null

var respawn_at = null
var died = false
	
func _ready():
	rotation = rand_range(0, 2*PI)
	
func _process(delta):
	if health <= 0:
		return
	health = min(health + health_regeneration * delta, max_health)
	$HealthDisplay.update_healthbar(health, max_health)
	if harm_player:
		harm_player.take_damage(40*delta, 0)
	
func _physics_process(delta):
	if not died:	if respawn_at: 
		position = respawn_at
		respawn_at = null
		return
	if health <= 0:
		return
	velocity = transform.x * speed
	if chase_player:
		velocity = position.direction_to(chase_player.position) * speed * 1.5
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal).rotated(rand_range(-PI/4, PI/4))
	rotation = velocity.angle()

sync func take_damage(amount, by_who):
	if health <= 0:
		return
	health -= amount
	$HealthDisplay.update_healthbar(health, max_health)
	if health <= 0:
		$"../CanvasLayer/Score".rpc("increase_score", by_who, 20)
		$AnimationPlayer.play("Die")
		died = true
		yield(get_tree().create_timer(2), "timeout")
		
		health = max_health
		var SpawnPoints = get_node("../SpawnPoints")
		var spawn = SpawnPoints.get_child( randi() % SpawnPoints.get_child_count())
		respawn_at = spawn.position
		rset("respawn_at", spawn.position)		
		


func _on_Detect_body_entered(body):
	if body.is_in_group("players"):
		chase_player = body


func _on_Detect_body_exited(body):
	if body.is_in_group("players"):
		chase_player = null


func _on_Harm_body_entered(body):
	if body.is_in_group("players"):
		harm_player = body

func _on_Harm_body_exited(body):
	if body.is_in_group("players"):
		harm_player = null
