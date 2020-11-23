extends "res://actors/ActorBase.gd"
class_name BlobMob

var minimap_icon = "mob"

var chase_player = null
var harm_player = null
var last_harm = null

func _ready():
	._ready()
	current_map = $"../../".name
	rotation = rand_range(0, 2*PI)
			
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

	var players = $"/root/gamestate".playerScenes
	var nearestPlayer = null
	for p in players:
		var player = players[p]
		if player.current_map == current_map:
			if nearestPlayer == null:
				nearestPlayer = player
			else:
				if (player.position - position).length() < (nearestPlayer.position - position).length():
					nearestPlayer = player
	
	if nearestPlayer != null and get_tree().get_network_unique_id() == int(nearestPlayer.name):
		
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
					
			#for player in get_node("/root/World/Players").get_children():
			#	if player.name != chase_player.name and player.current_map == current_map:
		#			rset_id(int(player.name), "puppet_velocity", velocity)
		#			rset_id(int(player.name), "puppet_rotation", rotation)
		#			rset_id(int(player.name), "puppet_pos", position)
					#print(player.name + " informed ")
				
			puppet_pos = position
			puppet_velocity = velocity
			puppet_rotation = rotation
			rpc_id(1, "set_mob_control", get_tree().get_network_unique_id())
			rset_id(1, "puppet_velocity", velocity)
			rset_id(1, "puppet_rotation", rotation)
			rset_id(1, "puppet_pos", position)
		else:
			$AnimationPlayer.play("Idle")
		
			var collision = move_and_collide(velocity * delta)
			if collision:
				velocity = velocity.bounce(collision.normal).rotated(rand_range(-PI/4, PI/4))
				
			rotation = velocity.angle()
					
			puppet_pos = position
			puppet_velocity = velocity
			puppet_rotation = rotation
			rpc_id(1, "set_mob_control", get_tree().get_network_unique_id())
			rset_id(1, "puppet_velocity", velocity)
			rset_id(1, "puppet_rotation", rotation)
			rset_id(1, "puppet_pos", position)
	else:
		rpc_id(1, "set_mob_control", 0)
		position = puppet_pos
		velocity = puppet_velocity
		rotation = puppet_rotation
				
	
master func _on_death(by_who):
	var score = $"../../CanvasLayer/Score"
	if not score:
		score = $"../../../CanvasLayer/Score"
	if score and by_who > 0:
		score.rpc("increase_score", by_who, 20)
	$AnimationPlayer.play("Die")
	emit_signal("on_removed", self)
	yield(get_tree().create_timer(3), "timeout")
	queue_free()
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
	pass
		

func _on_Detect_body_entered(body):
	if body.is_in_group("players"):
		if get_tree().get_network_unique_id() == int(body.name):
			chase_player = body

func _on_Detect_body_exited(body):
	if body.is_in_group("players"):
		if get_tree().get_network_unique_id() == int(body.name):
			chase_player = null

func _on_Harm_body_entered(body):
	if body.is_in_group("players"):
		harm_player = body
		last_harm = OS.get_unix_time()

func _on_Harm_body_exited(body):
	if body.is_in_group("players"):
		harm_player = null

