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
	

	var newlevel = target_level.instance()
	
	
	for player in world.get_node("Players").get_children():
		player.setMap(newlevel)
		
			
var once = false

func _on_body_entered(body):
	if body.is_in_group("players"):
		if once:
			print("????????? ", once)
			return
		once = true
		rpc("dostuff")
