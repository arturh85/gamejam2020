extends "res://ActorBase.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



var player_name
var items = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	pass # Replace with function body.

func saveNOTHERE():
	if .has_method("save"):
		var saveDict = .save()
		saveDict["items"] = items
		var sd = {}
		sd["onlinePlayer"] = saveDict
		return sd
		
func set_player_name(p_name, id):
	player_name = p_name
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

sync func pickup_item(itemID):
	var itemsNode = get_node("/root/World/Maps/" + current_map + "/Items")
	var itn = itemsNode.get_children()
	for item in itn:
		if item.stats.id == itemID:
			items[item.stats.id] = item.stats
			itemsNode.remove_child(item)
			
	
	
