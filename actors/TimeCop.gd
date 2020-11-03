extends "res://actors/ActorBase.gd"
class_name TimeCopMob

var minimap_icon = "mob"

var chase_player = null
var harm_player = null
var last_harm = null

func _ready():
	rotation = rand_range(0, 2*PI)
	has_weapons[5] = true
	switch_weapon(5)
		
sync func switch_weapon(index):
	.switch_weapon(index)
	var current_weapon_node = get_node("Group/Gun").get_child(0)
	if current_weapon_node.has_node("StartBlocker"):
		current_weapon_node.remove_child(current_weapon_node.get_node("StartBlocker"))
	if current_weapon_node.has_node("EndBlocker"):
		current_weapon_node.remove_child(current_weapon_node.get_node("EndBlocker"))
	var auto_attack = load("res://weapons-mixins/AutoAttack/AutoAttack.tscn").instance()
	auto_attack.manual_control = true
	current_weapon_node.add_child(auto_attack)
			
func _process(delta):
	if health <= 0:
		return
		
	._process(delta)
		
	if harm_player and OS.get_unix_time() - last_harm > 0.3:
		last_harm = OS.get_unix_time()
		harm_player.take_damage(30, 0)
				
func _physics_process(delta):
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
				if chase_player.position.distance_to(position) < 100:
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

	
master func _on_death(by_who):
	var score = $"../../CanvasLayer/Score"
	if not score:
		score = $"../../../CanvasLayer/Score"
	if score:
		score.rpc("increase_score", by_who, 20)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("Die")

	emit_signal("on_removed", self)
	yield(get_tree().create_timer(3), "timeout")	
	queue_free()
	#health = max_health
	#rset("health", health)
	#var SpawnPoints = get_node("../SpawnPoints")
	#var spawn = SpawnPoints.get_child( randi() % SpawnPoints.get_child_count())
	#rpc("respawn_at", spawn.position)
	
func _on_respawn():
	show()
	$AnimationPlayer.play("Spawn")	

master func _on_damage():
	if health > 0:
		$AnimationPlayer2.play("Hit")
		

func _on_heal():
	pass

func _on_health_changed():
	$HealthDisplay.update_healthbar(health, max_health)

func _on_Detect_body_entered(body):
	if body.is_in_group("players"):
		chase_player = body
		var current_weapon_node = get_node("Group/Gun").get_child(0)
		current_weapon_node.get_node("AutoAttack").start_auto_attack()

func _on_Detect_body_exited(body):
	if body.is_in_group("players"):
		chase_player = null
		var current_weapon_node = get_node("Group/Gun").get_child(0)
		current_weapon_node.get_node("AutoAttack").end_auto_attack()

func _on_Harm_body_entered(body):
	if body.is_in_group("players"):
		harm_player = body
		last_harm = OS.get_unix_time()

func _on_Harm_body_exited(body):
	if body.is_in_group("players"):
		harm_player = null

