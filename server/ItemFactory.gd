extends Node
class_name ItemStats

const itemDictionary = {
	# LEVEL 1 ITEMS
	
	"armor_camouflage":
		{
			"label": "Camouflage Jacket",
			"description": "A camouflage jacket",
			"itemLevel": 1,
			"value": 450,
			"icon": "armor/body_camouflage.png",
			"image": "armor/body_camouflage.png",
			"slotType": Global.SlotType.SLOT_ARMOR,
			"stats": {
				"armor": 10
			}
		},
	"normalshoes":
		{
			"label": "Normal shoes",
			"description": "Just a pair shoes",
			"itemLevel": 1,
			"value": 10,
			"icon": "armor/shoes_default.png",
			"image": "armor/shoes_default.png",
			"slotType": Global.SlotType.SLOT_FEET,
			"stats": {
				"armor": 1,
				"speed": 3
			}
		},
	"pants_camouflage":
		{
			"label": "Camouflage Pants",
			"description": "Some camouflage pants",
			"itemLevel": 1,
			"value": 160,
			"icon": "armor/pants_camouflage.png",
			"image": "armor/pants_camouflage.png",
			"slotType": Global.SlotType.SLOT_PANTS,
			"stats": {
				"armor": 5
			}
		},
	"helmet_police":
		{
			"label": "Police helmet",
			"description": "A time police helmet",
			"itemLevel": 1,
			"value": 70,
			"icon": "armor/helmet_police.png",
			"image": "armor/helmet_police.png",
			"slotType": Global.SlotType.SLOT_HELMET,
			"stats": {
				"armor": 5
			}
		},
	"leathergloves":
		{
			"label": "Leather Gloves",
			"description": "Nice Leather Gloves",
			"itemLevel": 1,
			"value": 50,
			"icon": "armor/leathergloves.png",
			"image": "armor/leathergloves.png",
			"slotType": Global.SlotType.SLOT_GLOVES,
			"stats": {
				"armor": 2
			}
		},
	"shotgun":
		{
			"label": "Shotgun",
			"description": "Better than nothing...",
			"itemLevel": 1,
			"value": 100,
			"icon": "weapons/weapon_shotgun.png",
			"handNode": "res://weapons/Shotgun.tscn",
			"image": "weapons/weapon_shotgun.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
				"waittime" : 0.1,
				"spread" : 0.1,
				"damage": 29,
				"speed": 700
			}
		},
	"crossbow":
		{
			"label": "Crossbow",
			"description": "It's not firing usual bolts...",
			"itemLevel": 1,
			"value": 400,
			"icon": "weapons/weapon_crossbow.png",
			"handNode": "res://weapons/Crossbow.tscn",
			"image": "weapons/weapon_crossbow.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
				"waittime" : 0.5,
				"spread" : 0.05,
				"damage": 49,
				"speed": 800
			}
		},
	"machinegun":
		{
			"label": "Machinegun",
			"description": "Conventional but effective",
			"itemLevel": 1,
			"value": 500,
			"icon": "weapons/weapon_machinegun.png",
			"handNode": "res://weapons/Machinegun.tscn",
			"image": "weapons/weapon_machinegun.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
				"waittime" : 0.01,
				"spread" : 0.12,
				"damage": 10,
				"speed": 1500
			}
		},
	"plasmagun":
		{
			"label": "Plasmagun",
			"description": "Be careful. It's very hot",
			"itemLevel": 1,
			"value": 800,
			"icon": "weapons/weapon_plasma.png",
			"handNode": "res://weapons/Plasmagun.tscn",
			"image": "weapons/weapon_plasma.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
				"waittime" : 1.5,
				"spread" : 0.1,
				"damage": 42,
				"speed": 1000
			}
		},
	"uzis":
		{
			"label": "Uzis",
			"description": "Not really good, but 2 of em",
			"itemLevel": 1,
			"value": 800,
			"icon": "weapons/weapon_uzis.png",
			"handNode": "res://weapons/Uzis.tscn",
			"image": "weapons/weapon_uzis.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
				"waittime" : 1.5,
				"spread" : 0.1,
				"damage": 21,
				"speed": 1500
			}
		},
	"rifle":
		{
			"label": "Rifle",
			"description": "Extreme precise!",
			"itemLevel": 1,
			"value": 1000,
			"icon": "weapons/weapon_rifle.png",
			"handNode": "res://weapons/Rifle.tscn",
			"image": "weapons/weapon_rifle.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
				"waittime" : 1.2,
				"spread" : 0,
				"damage": 70,
				"speed": 2000
			}
		},
	"railgun":
		{
			"label": "Railgun",
			"description": "Pew pew pew",
			"itemLevel": 1,
			"value": 1300,
			"icon": "weapons/weapon_railgun.png",
			"handNode": "res://weapons/Railgun.tscn",
			"image": "weapons/weapon_railgun.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
				"waittime" : 2,
				"spread" : 0,
				"damage": 110,
				"speed": 3000
			}
		},
	# LEVEL 2 ITEMS
	"armor_camouflage2":
		{
			"label": "White camouflage jacket",
			"description": "The amazing white camouflage jacket",
			"itemLevel": 2,
			"value": 1010,
			"icon": "armor/body_camouflage2.png",
			"image": "armor/body_camouflage2.png",
			"slotType": Global.SlotType.SLOT_ARMOR,
			"stats": {
				"armor": 20
			}
		},
	"helmet_black":
		{
			"label": "Black helmet",
			"description": "The good old black helmet",
			"itemLevel": 2,
			"value": 700,
			"icon": "armor/helmet_black.png",
			"image": "armor/helmet_black.png",
			"slotType": Global.SlotType.SLOT_HELMET,
			"stats": {
				"armor": 10
			}
		},
	"convenient_gloves":
		{
			"label": "Convenient Gloves",
			"description": "Ahhh. It feels like kitties...",
			"itemLevel": 2,
			"value": 500,
			"icon": "armor/convenient_gloves.png",
			"image": "armor/convenient_gloves.png",
			"slotType": Global.SlotType.SLOT_GLOVES,
			"stats": {
				"armor": 3
			}
		},
	"shoes_greensneaker":
		{
			"label": "Green Sneakers",
			"description": "It's convenient and it's green",
			"itemLevel": 2,
			"value": 420,
			"icon": "armor/shoes_greensneaker.png",
			"image": "armor/shoes_greensneaker.png",
			"slotType": Global.SlotType.SLOT_FEET,
			"stats": {
				"armor": 0,
				"speed": 10
			}
		},
	"pants_blueshorts":
		{
			"label": "Blue shorts",
			"description": "Good shorts!",
			"itemLevel": 2,
			"value": 800,
			"icon": "armor/pants_blueshorts.png",
			"image": "armor/pants_blueshorts.png",
			"slotType": Global.SlotType.SLOT_PANTS,
			"stats": {
				"armor": 8
			}
		},
	"laser":
		{
			"label": "Laser",
			"description": "Basically, it's light",
			"itemLevel": 2,
			"value": 3000,
			"icon": "weapons/weapon_laser.png",
			"handNode": "res://weapons/Laser.tscn",
			"image": "weapons/weapon_laser.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
				"waittime" : 0.35,
				"spread" : 0.05,
				"damage": 120,
				"speed": 4000
			}
		},
	"elecgun":
		{
			"label": "Elec Gun",
			"description": "Very special. Invented by Elec Baldwin",
			"itemLevel": 2,
			"value": 9000,
			"icon": "weapons/weapon_elecgun.png",
			"handNode": "res://weapons/ElecGun.tscn",
			"image": "weapons/weapon_elecgun.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
				"waittime" : 2,
				"spread" : 0.02,
				"damage": 580,
				"speed": 300
			}
		},
	"flamethrower":
		{
			"label": "Flamethrower",
			"description": "Gas in. Fire out.",
			"itemLevel": 2,
			"value": 2600,
			"icon": "weapons/weapon_flamethrower.png",
			"handNode": "res://weapons/Flamethrower.tscn",
			"image": "weapons/weapon_flamethrower.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
				"waittime" : 0.5,# MISSING IMPLEMENTATION?
				"autofire" : 0.5, # MISSING IMPLEMENTATION?
				"spread" : 0.3,
				"damage": 20,
				"speed": 250 # NAME DIFFERENT
			}
		},
	"flamethrower2":
		{
			"label": "Advanced Flamethrower",
			"description": "Carefully, please...",
			"itemLevel": 3,
			"value": 8300,
			"icon": "weapons/weapon_flamethrower2.png",
			"handNode": "res://weapons/Flamethrower2.tscn",
			"image": "weapons/weapon_flamethrower2.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
				"waittime" : 0.5,
				"autofire" : 0.3, 
				"spread" : 0.25,
				"damage": 32,
				"speed": 300 
			}
		},
}

var rarity
var itemDict
var randomness = 0.1
var rng = RandomNumberGenerator.new()


func generate(item_name, luck, level, position):
	
	rng.randomize()
	
	itemDict = deep_copy(itemDictionary[item_name])
	itemDict["level"] = level
	itemDict["name"] = item_name
	itemDict["x"] = position.x
	itemDict["y"] = position.y
	itemDict["id"] = self.get_instance_id()
	
	create(luck)
	
	itemDict["rarity"] = rarity




func create(luck):
	
	var r = rng.randi_range(0, 1000/luck - 1)
	if r == 0:
		self.rarity = Global.ItemRarity.LEGENDARY # 1% bei luck = 10 | 100% bei luck = 1000 | 0.1% bei luck = 1
	elif r > 0 and r <= 3:
		self.rarity = Global.ItemRarity.EPIC # 3% epic
	elif r > 3 and r <= 13:
		self.rarity = Global.ItemRarity.RARE # 10% rare
	elif r > 13 and r <= 38:
		self.rarity = Global.ItemRarity.COMMON # 25% common
	else:
		self.rarity = Global.ItemRarity.NORMAL # 61% normal
	
	var damageFactor = 1
	var speedFactor = 1
	var spreadFactor = 1
	var waitFactor = 1
	
	var armorFactor = 1
	
	var valueFactor = 1
	
	match rarity:
		Global.ItemRarity.COMMON:
			damageFactor = 1.2
			speedFactor = 1.1
			spreadFactor = 0.9
			waitFactor = 0.95
			
			armorFactor = 1.2
			
			valueFactor = 1.9
			
		Global.ItemRarity.RARE:
			damageFactor = 1.5
			speedFactor = 1.2
			spreadFactor = 0.8
			waitFactor = 0.9
			
			armorFactor = 1.4
			
			valueFactor = 2.4
			
		Global.ItemRarity.EPIC:
			damageFactor = 1.8
			speedFactor = 1.3
			spreadFactor = 0.7
			waitFactor = 0.8
			
			armorFactor = 1.7
			
			valueFactor = 6
			
		Global.ItemRarity.LEGENDARY:
			damageFactor = 2.2
			speedFactor = 1.5
			spreadFactor = 0.5
			waitFactor = 0.7
			
			armorFactor = 2
			
			valueFactor = 12

	damageFactor = damageFactor * (1 + rng.randf_range(-randomness, randomness))
	speedFactor = damageFactor * (1 + rng.randf_range(-randomness, randomness))
	spreadFactor = spreadFactor * (1 + rng.randf_range(-randomness, randomness))
	waitFactor = waitFactor * (1 + rng.randf_range(-randomness, randomness))
	armorFactor = armorFactor * (1 + rng.randf_range(-randomness, randomness))
	valueFactor = valueFactor * (1 + rng.randf_range(-randomness, randomness))
	
	if itemDict.stats.has("damage"):
		itemDict.stats["damage"] = round_to_dec(float(itemDict.stats["damage"]) * damageFactor * (1 + int(itemDict["level"]) / 10), 0)
	if itemDict.stats.has("speed"):
		itemDict.stats["speed"] = round_to_dec(float(itemDict.stats["speed"]) * speedFactor, 0)
	if itemDict.stats.has("spread"):
		itemDict.stats["spread"] = round_to_dec(float(itemDict.stats["spread"]) * spreadFactor, 3)
	if itemDict.stats.has("waittime"):
		itemDict.stats["waittime"] = round_to_dec(float(itemDict.stats["waittime"]) * waitFactor, 3)
	if itemDict.stats.has("armor"):
		itemDict.stats["armor"] = round_to_dec(float(itemDict.stats["armor"]) * armorFactor * (1 + int(itemDict["level"]) / 10), 1)
	
	itemDict["value"] = round_to_dec(itemDict["value"] * valueFactor, 0)
		


static func deep_copy(v):
	var t = typeof(v)

	if t == TYPE_DICTIONARY:
		var d = {}
		for k in v:
			d[k] = deep_copy(v[k])
		return d

	elif t == TYPE_ARRAY:
		var d = []
		d.resize(len(v))
		for i in range(len(v)):
			d[i] = deep_copy(v[i])
		return d

	elif t == TYPE_OBJECT:
		if v.has_method("duplicate"):
			return v.duplicate()
		else:
			print("Found an object, but I don't know how to copy it!")
			return v

	else:
		# Other types should be fine,
		# they are value types (except poolarrays maybe)
		return v
		
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
