extends Node2D

export (PackedScene) var target_level = load("res://maps/Random.tscn")

remotesync func dostuff():
		
	var world = get_node("/root/World")
	
	for player in world.get_node("Players").get_children():
		player.get_node("AnimationPlayer").play("PortalIn")
		player.lockPlayer()
		
	yield(get_tree().create_timer(0.5), "timeout")
	
	world.get_node("CanvasLayer/Transitions").play("Portal")
	
	yield(get_tree().create_timer(1), "timeout")
	
	var level = world.get_node("Level")
	world.remove_child(level)
	var newlevel = target_level.instance()
	world.add_child(newlevel)
	
	world.get_node("CanvasLayer/MiniMap").update_map_markers()
	
	
	var SpawnPoints = newlevel.get_node("SpawnPoints")
	
	var i = 0
	for player in world.get_node("Players").get_children():
		var spawn = SpawnPoints.get_child(i)
		print("player at", player.position)
		print("respawn at ", spawn.position)
		print("spawn name ", spawn.name)
		i = i+1
		player.rpc("spawn_at", spawn.position)
		player.unlockPlayer()
		
	
	yield(world.get_tree().create_timer(1), "timeout")
	#newlevel.show()
	
	world.get_node("CanvasLayer/Transitions").play("PortalOut")
	
	#for player in world.get_node("Players").get_children():
	#	player.get_node("AnimationPlayer").play_backwards("PortalIn")
		
			
var once = false

func _on_body_entered(body):
	if body.is_in_group("players"):
		if once:
			print("????????? ", once)
			return
		once = true
		rpc("dostuff")
