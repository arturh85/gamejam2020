extends KinematicBody2D
class_name Mob


puppet var puppet_pos = Vector2()
puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0 
 

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
var last_harm = 0
var dying = false
	
func _ready():
	rotation = rand_range(0, 2*PI)
	
	
func hitsound():
	if health > 0:
		$AnimationPlayer2.play("Hit")
		
func _process(delta):
	if health <= 0:
		return
	health = min(health + health_regeneration * delta, max_health)
	$HealthDisplay.update_healthbar(health, max_health)
	if harm_player and OS.get_unix_time() - last_harm > 0.3:
		last_harm = OS.get_unix_time()
		harm_player.take_damage(30, 0)
		harm_player.hitsound()
	
func _physics_process(delta):
	if respawn_at: 
		position = respawn_at
		respawn_at = null
		show()
		$AnimationPlayer.play("Spawn")
		$CollisionShape2D.set_deferred("disabled", false)
		dying = false
		return
	if health <= 0:
		return
	if is_network_master():
		velocity = transform.x * speed		
		if chase_player:
			$AnimationPlayer.play("Attack")
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_ray(position, chase_player.position)
			if result and result.collider and result.collider.is_in_group("players"):
				velocity = position.direction_to(chase_player.position) * speed * 1.5
				if chase_player.position.distance_to(position) < 40:
					velocity = Vector2(0,0)
				else:
					var collision = move_and_collide(velocity * delta)
					if collision:
						velocity = velocity.bounce(collision.normal).rotated(rand_range(-PI/4, PI/4))
					rotation = velocity.angle()
		else:
			$AnimationPlayer.play("Idle")
			var collision = move_and_collide(velocity * delta)
			if collision:
				velocity = velocity.bounce(collision.normal).rotated(rand_range(-PI/4, PI/4))
			rotation = velocity.angle()
		rset("puppet_velocity", velocity)
		rset("puppet_rotation", rotation)
		rset("puppet_pos", position)
	else:
		position = puppet_pos
		velocity = puppet_velocity
		rotation = puppet_rotation

sync func take_damage(amount, by_who):
	if health <= 0 or dying:
		return
	health -= amount
	rset("health", health)
	$HealthDisplay.update_healthbar(health, max_health)
	if health <= 0:
		dying = true
		$"../CanvasLayer/Score".rpc("increase_score", by_who, 20)
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimationPlayer.play("Die")
		yield(get_tree().create_timer(3), "timeout")
		health = max_health
		rset("health", health)
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
		last_harm = OS.get_unix_time()

func _on_Harm_body_exited(body):
	if body.is_in_group("players"):
		harm_player = null
