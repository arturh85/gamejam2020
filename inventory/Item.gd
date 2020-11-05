extends TextureRect
class_name InventoryItem

var itemIcon
var itemImage
var itemName
var itemValue
var itemSlot
var slotType
var picked = false
var rarity = 0

var rng = RandomNumberGenerator.new()

func _init(_itemName, _itemTexture, _itemImage, _itemSlot, _itemValue, _slotType):
	rng.randomize();
	self.itemName = _itemName
	self.itemValue = _itemValue
	self.itemSlot = _itemSlot
	self.itemImage = _itemImage
	self.slotType = _slotType
	self.rarity = rng.randi_range(Global.ItemRarity.NORMAL, Global.ItemRarity.LEGENDARY)
	texture = _itemTexture
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func pickItem():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	picked = true

func putItem():
	rect_position = Vector2(0, 0)
	mouse_filter = Control.MOUSE_FILTER_PASS
	picked = false
	
func equip(player: Player):
	match slotType:
		Global.SlotType.SLOT_HELMET:
			player.get_node("Group/helmet").texture = load("res://data/images/items/" + itemImage)
		Global.SlotType.SLOT_FEET:
			player.get_node("Group/shoe").texture = load("res://data/images/items/" + itemImage)
			player.get_node("Group/shoe2").texture = load("res://data/images/items/" + itemImage)
		Global.SlotType.SLOT_GLOVES:
			player.get_node("Group/gloves").texture = load("res://data/images/items/" + itemImage)
		Global.SlotType.SLOT_PANTS:
			player.get_node("Group/pant").texture = load("res://data/images/items/" + itemImage)
			player.get_node("Group/pant2").texture = load("res://data/images/items/" + itemImage)
		Global.SlotType.SLOT_ARMOR:
			player.get_node("Group/bodyarmor").texture = load("res://data/images/items/" + itemImage)
			pass

func unequip(player: Player):
	match slotType:
		Global.SlotType.SLOT_HELMET:
			player.get_node("Group/helmet").texture = null
		Global.SlotType.SLOT_FEET:
			player.get_node("Group/shoe").texture = null
			player.get_node("Group/shoe2").texture = null
		Global.SlotType.SLOT_GLOVES:
			player.get_node("Group/gloves").texture = null
		Global.SlotType.SLOT_PANTS:
			player.get_node("Group/pant").texture = null
			player.get_node("Group/pant2").texture = null
		Global.SlotType.SLOT_ARMOR:
			player.get_node("Group/bodyarmor").texture = null
			pass
