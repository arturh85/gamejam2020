extends Node
class_name ItemFactory
const itemImages = [
	preload("res://data/images/items/armor/helmet_police.png"),
	preload("res://inventory/images/Ac_Ring05.png"),
	preload("res://inventory/images/A_Armor05.png"),
	preload("res://inventory/images/A_Armour02.png"),
	preload("res://inventory/images/A_Shoes03.png"),
	preload("res://inventory/images/C_Elm03.png"),
	preload("res://inventory/images/E_Wood02.png"),
	preload("res://inventory/images/P_Red02.png"),
	preload("res://inventory/images/W_Sword001.png"),
	preload("res://inventory/images/Ac_Necklace03.png"),
];

const itemDictionary = {
	"armor_camouflage":
		{
			"name": "armor_camouflage",
			"label": "The amazing camouflage jacket",
			"value": 456,
			"icon": preload("res://data/images/items/armor/body_camouflage.png"),
			"image": "armor/body_camouflage.png",
			"slotType": Global.SlotType.SLOT_ARMOR,
			"stats": {
				"armor": 10
			}
		},
	"normalshoes":
		{
			"label": "Just some shoes",
			"value": 456,
			"icon": preload("res://data/images/items/armor/shoes_default.png"),
			"image": "armor/shoes_default.png",
			"slotType": Global.SlotType.SLOT_FEET,
			"stats": {
				"armor": 1
			}
		},
	"pants_camouflage":
		{
			"label": "The amazing camouflage pants",
			"value": 456,
			"icon": preload("res://data/images/items/armor/pants_camouflage.png"),
			"image": "armor/pants_camouflage.png",
			"slotType": Global.SlotType.SLOT_PANTS,
			"stats": {
				"armor": 5
			}
		},
	"helmet_police":
		{
			"label": "A time police helmet",
			"value": 456,
			"icon": preload("res://data/images/items/armor/helmet_police.png"),
			"image": "armor/helmet_police.png",
			"slotType": Global.SlotType.SLOT_HELMET,
			"stats": {
				"armor": 5
			}
		},
	"leathergloves":
		{
			"label": "Nice Leather Gloves",
			"value": 456,
			"icon": preload("res://data/images/items/armor/leathergloves.png"),
			"image": "armor/leathergloves.png",
			"slotType": Global.SlotType.SLOT_GLOVES,
			"stats": {
				"armor": 2
			}
		},
	"shotgun":
		{
			"label": "Shotgun",
			"value": 456,
			"icon": preload("res://data/images/items/weapons/weapon_shotgun.png"),
			"handNode": "res://weapons/Shotgun.tscn",
			"image": "weapons/weapon_shotgun.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
			}
		},
	"crossbow":
		{
			"label": "Crossbow",
			"value": 456,
			"icon": preload("res://data/images/items/weapons/weapon_crossbow.png"),
			"handNode": "res://weapons/Crossbow.tscn",
			"image": "weapons/weapon_crossbow.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
			}
		},
	"machinegun":
		{
			"label": "Machinegun",
			"value": 456,
			"icon": preload("res://data/images/items/weapons/weapon_machinegun.png"),
			"handNode": "res://weapons/Machinegun.tscn",
			"image": "weapons/weapon_machinegun.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
			}
		},
	"plasmagun":
		{
			"label": "Plasmagun",
			"value": 456,
			"icon": preload("res://data/images/items/weapons/weapon_plasma.png"),
			"handNode": "res://weapons/Plasmagun.tscn",
			"image": "weapons/weapon_plasma.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
			}
		},
	"railgun":
		{
			"label": "Railgun",
			"value": 456,
			"icon": preload("res://data/images/items/weapons/waepon_rifle.png"),
			"handNode": "res://weapons/Railgun.tscn",
			"image": "weapons/waepon_rifle.png",
			"slotType": Global.SlotType.SLOT_QUICK1,
			"stats": {
			}
		},
}

static func generate(item_name):
	var item = itemDictionary[item_name]
	var itemName = item_name
	var itemLabel = item.label
	var itemIcon = item.icon
	var itemImage = item.image
	var itemValue = item.value
	var handNode = item.handNode if item.has("handNode") else null
	var slotType = item.slotType
	return InventoryItem.new(itemName, itemLabel, itemIcon, itemImage, null, itemValue, slotType, handNode)

static func generate_random():
	return generate(itemDictionary.keys()[randi() % itemDictionary.size()])
	

#	0: {
#		"itemName": "Ring",
		#"itemValue": 456,
		#"itemIcon": itemImages[0],
		#"slotType": Global.SlotType.SLOT_RING
	#},
	
#	1: {
		#"itemName": "Sword",
		#"itemValue": 832,
		#"itemIcon": itemImages[7],
		#"slotType": Global.SlotType.SLOT_LHAND
	#},
	#2: {
		#"itemName": "Armor",
		#"itemValue": 623,
		#"itemIcon": itemImages[2],
		#"slotType": Global.SlotType.SLOT_ARMOR
	#},
	#3: {
		#"itemName": "Helmet",
		#"itemValue": 12,
		#"itemIcon": itemImages[4],
		#"slotType": Global.SlotType.SLOT_HELMET
	#},
	#4: {
		#"itemName": "Boots",
		#"itemValue": 654,
		#"itemIcon": itemImages[3],
		#"slotType": Global.SlotType.SLOT_FEET
	#},
	#5: {
		#"itemName": "Shield",
#		"itemValue": 23,
		#"itemIcon": itemImages[5],
		#"slotType": Global.SlotType.SLOT_RHAND
	#},
	#6: {
		#"itemName": "Necklace",
		#"itemValue": 756,
		#"itemIcon": itemImages[8],
		#"slotType": Global.SlotType.SLOT_NECK
	#}
