extends "res://ActorBase.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var mobName = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	pass # Replace with function body.



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

sync func pickup_item(itemID):
	pass
	
	
