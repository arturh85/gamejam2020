extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



master var puppet_pos = Vector2()
master var puppet_velocity = Vector2()
master var puppet_rotation = 0 
master var puppet_motion = Vector2()
master var health = 0
master var current_map = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_player_name(player_name, id):
	
	$Name.text = str(id) + ": " + name + " - " + player_name
	$Name.rect_position.x = 10
	$Name.rect_position.y = (id-1) * 20 + 10

sync func update_flashlight(visible):
	print(name + " switched flashlight")
	
	pass

sync func switch_quick(wp):
	print(name + " switched weapon")
	
	pass
	
sync func switch_weapon(wp):
	print(name + " switched weapon")
	
	pass

sync func switch_quick_relative(rel):
	print(name + " switched weapon rel")
	
	pass

sync func add_weapon(nr, ammo):
	print(nr + " added weapon")
	
	pass

sync func add_ammo(nr, ammo):
	print(name + " added ammo")
	
	pass

sync func take_damage(damage, by_who):
	print(name + " taking " + str(damage) + " damage ")
	pass


sync func on_took_damage():
	print(name + " took damage")
	print("health: " + str(health))
	pass

sync func pickup_item(item):
	print(name + " picked up ")
	print(item)
	pass
	
	
