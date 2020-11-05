extends Node
class_name ItemFactory
const itemImages = [
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
	0: {
		"itemName": "A time police helmet",
		"itemValue": 456,
		"itemIcon": itemImages[0],
		"slotType": Global.SlotType.SLOT_RING
	},
}


static func generate_random():
	var item = itemDictionary[randi() % itemDictionary.size()]
	var itemName = item.itemName
	var itemIcon = item.itemIcon
	var itemValue = item.itemValue
	var slotType = item.slotType
	return InventoryItem.new(itemName, itemIcon, null, itemValue, slotType)


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
