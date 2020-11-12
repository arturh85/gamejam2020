extends TextureRect
class_name InventoryItem

var icon
var image
var itemName
var label
var value
var handNode
var slotType
var level
var rarity
var stats
var ID
var texture2rect
var itemSlot
var picked = false

func _init(_id, _itemName, _itemLabel, _itemTexture, _itemImage, _itemValue, _slotType, _handNode, _level, _rarity, _stats):
	
	itemName = _itemName
	label = _itemLabel
	image = _itemImage
	value = _itemValue
	slotType = _slotType
	handNode = _handNode
	level = _level
	rarity = _rarity
	stats = _stats
	ID = _id
		
	texture = load("res://data/images/items/" + _itemTexture)
	self.set_size(texture.get_size())
	
	match slotType:
		Global.SlotType.SLOT_FEET, Global.SlotType.SLOT_PANTS:
			texture2rect = TextureRect.new()
			texture2rect.texture = texture
			add_child(texture2rect)
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func pickItem():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	picked = true

func putItem():
	var maxSize = 30
	var fieldSize = 34
	if texture.get_size().x > maxSize or texture.get_size().y > maxSize:
		rect_scale.x = maxSize / max(texture.get_size().x, texture.get_size().y)
		rect_scale.y = maxSize / max(texture.get_size().x, texture.get_size().y)
	
	rect_position.x = (fieldSize - texture.get_size().x * rect_scale.x) / 2
	rect_position.y = (fieldSize - texture.get_size().y * rect_scale.y) / 2
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
	
	
	
