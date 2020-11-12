extends Node
class_name ItemStats

const itemDictionary = {
	"armor_camouflage":
		{
			"name": "armor_camouflage",
			"label": "The amazing camouflage jacket",
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
			"label": "Just some shoes",
			"value": 10,
			"icon": "armor/shoes_default.png",
			"image": "armor/shoes_default.png",
			"slotType": Global.SlotType.SLOT_FEET,
			"stats": {
				"armor": 1
			}
		},
	"pants_camouflage":
		{
			"label": "The amazing camouflage pants",
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
			"label": "A time police helmet",
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
			"label": "Nice Leather Gloves",
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
	"rifle":
		{
			"label": "Rifle",
			"value": 1000,
			"icon": "weapons/waepon_rifle.png",
			"handNode": "res://weapons/Rifle.tscn",
			"image": "weapons/waepon_rifle.png",
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
			"value": 1300,
			"icon": "weapons/waepon_railgun.png",
			"handNode": "res://weapons/Railgun.tscn",
			"image": "weapons/waepon_railgun.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
				"waittime" : 2,
				"spread" : 0,
				"damage": 110,
				"speed": 3000
			}
		}
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
