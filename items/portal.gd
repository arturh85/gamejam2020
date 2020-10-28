extends Node2D

export (PackedScene) var target_level = load("res://maps/Random.tscn")

func _on_body_entered(body):
	if body.is_in_group("players"):
		var world = get_node("/root/World")
		var level = world.get_node("Level")
		world.remove_child(level)
		world.add_child(target_level.instance())
		
		
		var SpawnPoints = get_node("../SpawnPoints")
		
		for player in world.get_node("Players").get_children():
			var spawn = SpawnPoints.get_child( randi() % SpawnPoints.get_child_count())
			print("player at", player.position)
			print("respawn at ", spawn.position)
			player.rpc("respawn_at", spawn.position)
