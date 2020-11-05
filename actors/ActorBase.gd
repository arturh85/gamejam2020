extends HealthBase
class_name ActorBase

enum Weapon {
	Shotgun = 0,
	Plasmagun,
	Machinegun,
	Crossbow,
	Rifle,
	Railgun,
	Lasergun,
}

var weapon_nodes = {
	Weapon.Shotgun: preload("res://weapons/Shotgun.tscn"),
	Weapon.Plasmagun: preload("res://weapons/Plasmagun.tscn"),
	Weapon.Machinegun: preload("res://weapons/Machinegun.tscn"),
	Weapon.Crossbow: preload("res://weapons/Crossbow.tscn"),
	Weapon.Rifle: preload("res://weapons/Rifle.tscn"),
	Weapon.Railgun: preload("res://weapons/Railgun.tscn"),
	Weapon.Lasergun: preload("res://weapons/Lasergun.tscn"),
}

export var speed = 200

export var current_weapon = 0
export var has_weapons = [false, false, false, false, false, false, false]
export var ammo = [0, 0, 0, 0, 0, 0, 0]

var active_quickslot = Global.SlotType.SLOT_QUICK1
var inventory_slots = Array()
var character_slots = Array()


puppet var puppet_pos = Vector2()
puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0 
var last_oxygen_harm = null

var room = null

var velocity = Vector2()
var damage_multiplier = 1
var respawn_position = null


func _ready():
	._ready()
	for _i in Global.CHARACTER_SLOT_COUNT:
		character_slots.append(null)
	for _i in Global.INVENTORY_SLOT_COUNT:
		inventory_slots.append(null)
	pass

func _process(delta):
	._process(delta)
	if respawn_position:
		position = respawn_position
		respawn_position = null
		$CollisionShape2D.set_deferred("disabled", false)
		emit_signal("on_respawn")
	if health <= 0:
		return		
	if room and room.oxygen < 30:
		if last_oxygen_harm and OS.get_unix_time() - last_oxygen_harm > 0.1:
			take_damage((30 - room.oxygen) / 3 if room.oxygen > -1 else 30, 0)
			last_oxygen_harm = OS.get_unix_time()
		elif last_oxygen_harm == null:
			last_oxygen_harm = OS.get_unix_time()
	else:
		last_oxygen_harm = null

master func respawn_at(position):
	health = max_health
	emit_signal("on_health_changed")
	respawn_position = position
	
master func spawn_at(position):
	respawn_position = position


sync func switch_quick_relative(rel):
	var found = null
	var i = current_weapon
	while not found:
		i = wmod(i + rel)
		if i == current_weapon: 
			return
		if has_weapons[i]:
			return switch_quick(i)
			
func wmod(n):
	var c = weapon_nodes.size()
	while n < 0:
		n += c
	while n >= c:
		n -= c
	return n
			
	
sync func switch_quick(index):
	if has_weapons[index]:
		var w = weapon_nodes[index].instance()
		var current_weapon_node = get_node("Group/Gun").get_child(0)
		get_node("Group/Gun").remove_child(current_weapon_node)
		current_weapon_node.call_deferred("free")
		get_node("Group/Gun").add_child(w, true)
		var wchiulds = current_weapon_node.get_children()
		if w.has_node("Ammo"):
			var ammo_node = w.get_node("Ammo")
			ammo_node.current_capacity = ammo[index]
			get_node("/root/World/CanvasLayer/AmmoHUD").show()
		else:
			get_node("/root/World/CanvasLayer/AmmoHUD").hide()
		current_weapon = index

sync func add_weapon(nr, ammo_amount=0):
	has_weapons[nr] = true
	ammo[nr] += ammo_amount
	switch_quick(nr)
	
	
sync func add_ammo(nr, ammo_amount=0):
	ammo[nr] += ammo_amount
	if has_weapons[nr]:
		switch_quick(nr)
	
