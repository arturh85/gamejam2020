extends TextureRect
class_name InventoryItem

var itemIcon
var itemImage
var itemName
var itemValue
var itemSlot
var handNode
var slotType
var picked = false
var rarity = 0
var texture2rect

var rng = RandomNumberGenerator.new()

func _init(_itemName, _itemTexture, _itemImage, _itemSlot, _itemValue, _slotType, _handNode):
	rng.randomize();
	self.itemName = _itemName
	self.itemValue = _itemValue
	self.itemSlot = _itemSlot
	self.handNode = _handNode
	self.itemImage = _itemImage
	self.slotType = _slotType
	self.rarity = rng.randi_range(Global.ItemRarity.NORMAL, Global.ItemRarity.LEGENDARY)
	texture = _itemTexture
	self.set_size(texture.get_size())
	
	match slotType:
		Global.SlotType.SLOT_FEET, Global.SlotType.SLOT_PANTS:
			texture2rect = TextureRect.new()
			texture2rect.texture = _itemTexture
			add_child(texture2rect)
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func pickItem():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	picked = true

func putItem():
	if texture.get_size().x > 34:
		rect_scale.x =34 / texture.get_size().x
		rect_scale.y = 34 / texture.get_size().x
	
	rect_position.x = (34 - texture.get_size().x * rect_scale.x) / 2
	rect_position.y = (34 - texture.get_size().y * rect_scale.y) / 2
	if texture2rect:
		
		#texture2rect.rect_position = rect_position
	
		match slotType:
			Global.SlotType.SLOT_FEET:
				rect_position.y = rect_position.y + 4
				texture2rect.rect_position.y = - 8
			Global.SlotType.SLOT_PANTS:
				rect_position.y = rect_position.y + 3
				texture2rect.rect_position.y = - 6
			
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	picked = false
	
