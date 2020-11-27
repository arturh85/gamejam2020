extends "res://ActorBase.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var mobName = ""
var items = Array()
# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	current_map = get_node("../../").name
	for w in get_children():
		items.append(w.id)

var mobControlID = 0
remote func set_mob_control(id):
	mobControlID = id
		
func _process(delta):
	var players = $"/root/World/Players".get_children()
	for player in players:
		if mobControlID > 0 and mobControlID != int(player.name):
			if player.current_map == current_map:
				rset_id(int(player.name), "puppet_velocity", puppet_velocity)
				rset_id(int(player.name), "puppet_rotation", puppet_rotation)
				rset_id(int(player.name), "puppet_pos", puppet_pos)

func save():
	if .has_method("save"):
		var saveDict = .save()
		saveDict["name"] = self.name
		saveDict["mobname"] = mobName
		saveDict["items"] = items
		var sd = {}
		sd["mob"] = saveDict
		return sd

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
	
	
