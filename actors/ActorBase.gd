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

var active_quickslot = 0
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

func pickup_item(item):
	for i in range(Global.CHARACTER_SLOT_COUNT-1):
		if not character_slots[i+1] and Global.canEquip(item, i+1):
			set_character_slot(i+1, item)
			return
	for i in range(Global.INVENTORY_SLOT_COUNT):
		if not inventory_slots[i]:
			inventory_slots[i] = item


func equip_item(item: InventoryItem):
	match item.slotType:
		Global.SlotType.SLOT_HELMET:
			if $Group/helmet:
				$Group/helmet.texture = load("res://data/images/items/" + item.itemImage)
		Global.SlotType.SLOT_FEET:
			if $Group/shoe:
				$Group/shoe.texture = load("res://data/images/items/" + item.itemImage)
			if $Group/shoe2:
				$Group/shoe2.texture = load("res://data/images/items/" + item.itemImage)
		Global.SlotType.SLOT_GLOVES:
			if $Group/gloves:
				$Group/gloves.texture = load("res://data/images/items/" + item.itemImage)
		Global.SlotType.SLOT_PANTS:
			if $Group/pant:
				$Group/pant.texture = load("res://data/images/items/" + item.itemImage)
			if $Group/pant2:
				$Group/pant2.texture = load("res://data/images/items/" + item.itemImage)
		Global.SlotType.SLOT_ARMOR:
			if $Group/bodyarmor:
				$Group/bodyarmor.texture = load("res://data/images/items/" + item.itemImage)
		Global.SlotType.SLOT_QUICK1:
			switch_quick(0)
		Global.SlotType.SLOT_QUICK2:
			switch_quick(1)
		Global.SlotType.SLOT_QUICK3:
			switch_quick(2)
		Global.SlotType.SLOT_QUICK4:
			switch_quick(3)

func unequip_item(item: InventoryItem):
	match item.slotType:
		Global.SlotType.SLOT_HELMET:
			if $Group/helmet:
				$Group/helmet.texture = null
		Global.SlotType.SLOT_FEET:
			if $Group/shoe:
				$Group/shoe.texture = null
			if $Group/shoe2:
				$Group/shoe2.texture = null
		Global.SlotType.SLOT_GLOVES:
			if $Group/gloves:
				$Group/gloves.texture = null
		Global.SlotType.SLOT_PANTS:
			if $Group/pant:
				$Group/pant.texture = null
			if $Group/pant2:
				$Group/pant2.texture = null
		Global.SlotType.SLOT_ARMOR:
			if $Group/bodyarmor:
				$Group/bodyarmor.texture = null
		Global.SlotType.SLOT_QUICK1:
			switch_quick(0)
		Global.SlotType.SLOT_QUICK2:
			switch_quick(1)
		Global.SlotType.SLOT_QUICK3:
			switch_quick(2)
		Global.SlotType.SLOT_QUICK4:
			switch_quick(3)

func set_character_slot(idx, item):
	var old_item = character_slots[idx]
	if old_item:
		character_slots[idx] = null
		unequip_item(old_item)
	character_slots[idx] = item
	if item:
		equip_item(item)
			


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
	var c = 4
	while n < 0:
		n += c
	while n >= c:
		n -= c
	return n
			
	
sync func switch_quick(index):
	index = Global.SlotType.SLOT_QUICK1 + index
	var gun_node = get_node("Group/Gun")
	if gun_node.get_child_count() > 0:
		var current_weapon_node = get_node("Group/Gun").get_child(0)
		gun_node.remove_child(current_weapon_node)
		current_weapon_node.call_deferred("free")
	if character_slots[index]:
		var item = character_slots[index]		
		if item.handNode:
			var w = load(item.handNode).instance()
			gun_node.add_child(w, true)
			if w.has_node("Ammo"):
				var ammo_node = w.get_node("Ammo")
				ammo_node.current_capacity = ammo[index]
				get_node("/root/World/CanvasLayer/AmmoHUD").show()
			else:
				get_node("/root/World/CanvasLayer/AmmoHUD").hide()
			active_quickslot = index

sync func add_weapon(nr, ammo_amount=0):
	has_weapons[nr] = true
	ammo[nr] += ammo_amount
	switch_quick(nr)
	
	
sync func add_ammo(nr, ammo_amount=0):
	ammo[nr] += ammo_amount
	if has_weapons[nr]:
		switch_quick(nr)
	
